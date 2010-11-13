Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:57310 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab0KMBAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Nov 2010 20:00:21 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oAD10KQp021949
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 12 Nov 2010 17:00:20 -0800
Message-ID: <4CDDE324.3070801@candelatech.com>
Date: Fri, 12 Nov 2010 17:00:20 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Scanning improvements for multiple VIFS.
References: <4CDDCC72.6070006@candelatech.com>
In-Reply-To: <4CDDCC72.6070006@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2010 03:23 PM, Ben Greear wrote:
> When I am using lots of virtual stations, each of them will attempt
> to scan when started. Most of them get EBUSY
> until finally everyone is associated. This can take a long time.
>
> I was considering trying something a bit different.
>
> In nl80211_trigger_scan, if rdev->scan_req is != NULL,
> instead of returning EBUSY, what if we set a flag in
> the VIF that said "I want scan results too."
>
> Then, when whatever is scanning is finished, it would send
> scan results to all interested vifs.

Maybe something like the attached?  I crashed my ath9k
box with DMA errors and such with this patch, but not
sure if it is the root of the problem or not...

I'll test some more later.

Take it easy,
Ben

[ white space damaged, I'm sure ]


diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e0950c8..dd8d830 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -694,6 +694,17 @@ struct cfg80211_ssid {
  	u8 ssid_len;
  };

+
+/**
+ * struct cfg80211_srd -- Scan-Req device container.
+ * @next:  Next container in list.
+ * @dev:  network device.
+ */
+struct cfg80211_srd {
+	struct cfg80211_srd *next;
+	struct net_device *dev;
+};
+
  /**
   * struct cfg80211_scan_request - scan request description
   *
@@ -718,7 +729,7 @@ struct cfg80211_scan_request {

  	/* internal */
  	struct wiphy *wiphy;
-	struct net_device *dev;
+	struct cfg80211_srd* devs;
  	bool aborted;
  	bool can_scan_one;

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 9c21ebf..20ae948 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -640,9 +640,19 @@ static void wdev_cleanup_work(struct work_struct *work)

  	cfg80211_lock_rdev(rdev);

-	if (WARN_ON(rdev->scan_req && rdev->scan_req->dev == wdev->netdev)) {
-		rdev->scan_req->aborted = true;
-		___cfg80211_scan_done(rdev, true);
+	if (rdev->scan_req) {
+		struct cfg80211_srd *ptr = rdev->scan_req->devs;
+		while (ptr) {
+			/* Maybe just remove from linked-list if not
+			 * the primary?
+			 */
+			if (WARN_ON(ptr->dev == wdev->netdev)) {
+				rdev->scan_req->aborted = true;
+				___cfg80211_scan_done(rdev, true);
+				break;
+			}
+			ptr = ptr->next;
+		}
  	}

  	cfg80211_unlock_rdev(rdev);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 72d0cc8..343271f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2857,6 +2857,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
  	enum ieee80211_band band;
  	size_t ie_len;
  	bool do_all_chan = true;
+	struct cfg80211_srd *srd;

  	if (!is_valid_ie_attr(info->attrs[NL80211_ATTR_IE]))
  		return -EINVAL;
@@ -2866,8 +2867,18 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
  	if (!rdev->ops->scan)
  		return -EOPNOTSUPP;

-	if (rdev->scan_req)
-		return -EBUSY;
+	srd = kmalloc(sizeof(*srd), GFP_KERNEL);
+	if (!srd)
+		return -ENOMEM;
+	
+	if (rdev->scan_req) {
+		dev_hold(dev);
+		srd->dev = dev;
+		/* Initial requestor remains at the front of the list */
+		srd->next = rdev->scan_req->devs->next;
+		rdev->scan_req->devs->next = srd;
+		return 0;
+	}

  	if (info->attrs[NL80211_ATTR_SCAN_FREQUENCIES]) {
  		n_channels = validate_scan_freqs(
@@ -2993,7 +3004,9 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
  		       request->ie_len);
  	}

-	request->dev = dev;
+	srd->dev = dev;
+	srd->next = NULL;
+	request->devs = srd;
  	request->wiphy = &rdev->wiphy;

  	rdev->scan_req = request;
@@ -3006,6 +3019,7 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
   out_free:
  		rdev->scan_req = NULL;
  		kfree(request);
+		kfree(srd);
  	}

  	return err;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 503ebb8..a95a3c6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -22,6 +22,8 @@
  void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
  {
  	struct cfg80211_scan_request *request;
+	struct cfg80211_srd *devs;
+	struct cfg80211_srd *tmp;
  	struct net_device *dev;
  #ifdef CONFIG_CFG80211_WEXT
  	union iwreq_data wrqu;
@@ -34,29 +36,35 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
  	if (!request)
  		return;

-	dev = request->dev;
+	devs = request->devs;
+	while (devs) {
+		dev = devs->dev;

-	/*
-	 * This must be before sending the other events!
-	 * Otherwise, wpa_supplicant gets completely confused with
-	 * wext events.
-	 */
-	cfg80211_sme_scan_done(dev);
+		/*
+		 * This must be before sending the other events!
+		 * Otherwise, wpa_supplicant gets completely confused with
+		 * wext events.
+		 */
+		cfg80211_sme_scan_done(dev);

-	if (request->aborted)
-		nl80211_send_scan_aborted(rdev, dev);
-	else
-		nl80211_send_scan_done(rdev, dev);
+		if (request->aborted)
+			nl80211_send_scan_aborted(rdev, dev);
+		else
+			nl80211_send_scan_done(rdev, dev);

  #ifdef CONFIG_CFG80211_WEXT
-	if (!request->aborted) {
-		memset(&wrqu, 0, sizeof(wrqu));
+		if (!request->aborted) {
+			memset(&wrqu, 0, sizeof(wrqu));

-		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
-	}
+			wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
+		}
  #endif

-	dev_put(dev);
+		dev_put(dev);
+		tmp = devs;
+		devs = devs->next;
+		kfree(tmp);
+	}

  	rdev->scan_req = NULL;

@@ -672,6 +680,7 @@ int cfg80211_wext_siwscan(struct net_device *dev,
  	struct cfg80211_scan_request *creq = NULL;
  	int i, err, n_channels = 0;
  	enum ieee80211_band band;
+	struct cfg80211_srd *srd = NULL;

  	if (!netif_running(dev))
  		return -ENETDOWN;
@@ -684,11 +693,22 @@ int cfg80211_wext_siwscan(struct net_device *dev,
  	if (IS_ERR(rdev))
  		return PTR_ERR(rdev);

-	if (rdev->scan_req) {
-		err = -EBUSY;
+	srd = kmalloc(sizeof(*srd), GFP_KERNEL);
+	if (!srd) {
+		err = -ENOMEM;
  		goto out;
  	}

+	if (rdev->scan_req) {
+		dev_hold(dev);
+		srd->dev = dev;
+		/* Initial requestor remains at the front of the list */
+		srd->next = rdev->scan_req->devs->next;
+		rdev->scan_req->devs->next = srd;
+		cfg80211_unlock_rdev(rdev);
+		return 0;
+	}
+
  	wiphy = &rdev->wiphy;

  	/* Determine number of channels, needed to allocate creq */
@@ -709,7 +729,9 @@ int cfg80211_wext_siwscan(struct net_device *dev,
  	}

  	creq->wiphy = wiphy;
-	creq->dev = dev;
+	srd->dev = dev;
+	srd->next = NULL;
+	creq->devs = srd;
  	/* SSIDs come after channels */
  	creq->ssids = (void *)&creq->channels[n_channels];
  	creq->n_channels = n_channels;
@@ -782,9 +804,11 @@ int cfg80211_wext_siwscan(struct net_device *dev,
  		nl80211_send_scan_start(rdev, dev);
  		/* creq now owned by driver */
  		creq = NULL;
+		srd = NULL;
  		dev_hold(dev);
  	}
   out:
+	kfree(srd);
  	kfree(creq);
  	cfg80211_unlock_rdev(rdev);
  	return err;
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 3e0e638..aae4617 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -79,13 +79,24 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
  	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
  	struct cfg80211_scan_request *request;
  	int n_channels, err;
+	struct cfg80211_srd *srd;

  	ASSERT_RTNL();
  	ASSERT_RDEV_LOCK(rdev);
  	ASSERT_WDEV_LOCK(wdev);

-	if (rdev->scan_req)
-		return -EBUSY;
+	srd = kmalloc(sizeof(*srd), GFP_KERNEL);
+	if (!srd)
+		return -ENOMEM;
+	
+	if (rdev->scan_req) {
+		dev_hold(wdev->netdev);
+		srd->dev = wdev->netdev;
+		/* Initial requestor remains at the front of the list */
+		srd->next = rdev->scan_req->devs->next;
+		rdev->scan_req->devs->next = srd;
+		return 0;
+	}

  	if (wdev->conn->params.channel) {
  		n_channels = 1;
@@ -133,7 +144,9 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
  		wdev->conn->params.ssid_len);
  	request->ssids[0].ssid_len = wdev->conn->params.ssid_len;

-	request->dev = wdev->netdev;
+	srd->dev = wdev->netdev;
+	srd->next = NULL;
+	request->devs = srd;
  	request->wiphy = &rdev->wiphy;

  	rdev->scan_req = request;
@@ -146,6 +159,7 @@ static int cfg80211_conn_scan(struct wireless_dev *wdev)
  	} else {
  		rdev->scan_req = NULL;
  		kfree(request);
+		kfree(srd);
  	}
  	return err;
  }


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

