Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab0G3ERE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:17:04 -0400
Subject: [wt PATCH 5/5] libertas: scan before assocation if no BSSID was
 given
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1280470034.14523.4.camel@dcbw.foobar.com>
References: <1280470034.14523.4.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:18:31 -0700
Message-ID: <1280470711.14523.16.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix this leftover TODO from the cfg80211 conversion by doing a scan
if cfg80211 didn't pass in the BSSID for us.  Since the scan code
uses so much of the cfg80211_scan_request structure to build up the
firmware command, we just fake one when the scan request is triggered
internally.  But we need to make sure that internal 'fake' cfg82011
scan request does get back to cfg82011 via cfg80211_scan_done().

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/cfg.c  |  148 ++++++++++++++++++++++++++--------
 drivers/net/wireless/libertas/dev.h  |    5 +
 drivers/net/wireless/libertas/main.c |    1 +
 3 files changed, 121 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
index a8c0126..623b81e 100644
--- a/drivers/net/wireless/libertas/cfg.c
+++ b/drivers/net/wireless/libertas/cfg.c
@@ -715,8 +715,13 @@ static void lbs_scan_worker(struct work_struct *work)
 
 	if (priv->scan_channel >= priv->scan_req->n_channels) {
 		/* Mark scan done */
-		cfg80211_scan_done(priv->scan_req, false);
+		if (priv->internal_scan)
+			kfree(priv->scan_req);
+		else
+			cfg80211_scan_done(priv->scan_req, false);
+
 		priv->scan_req = NULL;
+		priv->last_scan = jiffies;
 	}
 
 	/* Restart network */
@@ -727,10 +732,33 @@ static void lbs_scan_worker(struct work_struct *work)
 
 	kfree(scan_cmd);
 
+	/* Wake up anything waiting on scan completion */
+	if (priv->scan_req == NULL) {
+		lbs_deb_scan("scan: waking up waiters\n");
+		wake_up_all(&priv->scan_q);
+	}
+
  out_no_scan_cmd:
 	lbs_deb_leave(LBS_DEB_SCAN);
 }
 
+static void _internal_start_scan(struct lbs_private *priv, bool internal,
+	struct cfg80211_scan_request *request)
+{
+	lbs_deb_enter(LBS_DEB_CFG80211);
+
+	lbs_deb_scan("scan: ssids %d, channels %d, ie_len %zd\n",
+		request->n_ssids, request->n_channels, request->ie_len);
+
+	priv->scan_channel = 0;
+	queue_delayed_work(priv->work_thread, &priv->scan_work,
+		msecs_to_jiffies(50));
+
+	priv->scan_req = request;
+	priv->internal_scan = internal;
+
+	lbs_deb_leave(LBS_DEB_CFG80211);
+}
 
 static int lbs_cfg_scan(struct wiphy *wiphy,
 	struct net_device *dev,
@@ -747,18 +775,11 @@ static int lbs_cfg_scan(struct wiphy *wiphy,
 		goto out;
 	}
 
-	lbs_deb_scan("scan: ssids %d, channels %d, ie_len %zd\n",
-		request->n_ssids, request->n_channels, request->ie_len);
-
-	priv->scan_channel = 0;
-	queue_delayed_work(priv->work_thread, &priv->scan_work,
-		msecs_to_jiffies(50));
+	_internal_start_scan(priv, false, request);
 
 	if (priv->surpriseremoved)
 		ret = -EIO;
 
-	priv->scan_req = request;
-
  out:
 	lbs_deb_leave_args(LBS_DEB_CFG80211, "ret %d", ret);
 	return ret;
@@ -1193,7 +1214,62 @@ done:
 	return ret;
 }
 
+static struct cfg80211_scan_request *
+_new_connect_scan_req(struct wiphy *wiphy, struct cfg80211_connect_params *sme)
+{
+	struct cfg80211_scan_request *creq = NULL;
+	int i, n_channels = 0;
+	enum ieee80211_band band;
+
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		if (wiphy->bands[band])
+			n_channels += wiphy->bands[band]->n_channels;
+	}
+
+	creq = kzalloc(sizeof(*creq) + sizeof(struct cfg80211_ssid) +
+		       n_channels * sizeof(void *),
+		       GFP_ATOMIC);
+	if (!creq)
+		return NULL;
+
+	/* SSIDs come after channels */
+	creq->ssids = (void *)&creq->channels[n_channels];
+	creq->n_channels = n_channels;
+	creq->n_ssids = 1;
+
+	/* Scan all available channels */
+	i = 0;
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		int j;
+
+		if (!wiphy->bands[band])
+			continue;
+
+		for (j = 0; j < wiphy->bands[band]->n_channels; j++) {
+			/* ignore disabled channels */
+			if (wiphy->bands[band]->channels[j].flags &
+						IEEE80211_CHAN_DISABLED)
+				continue;
+
+			creq->channels[i] = &wiphy->bands[band]->channels[j];
+			i++;
+		}
+	}
+	if (i) {
+		/* Set real number of channels specified in creq->channels[] */
+		creq->n_channels = i;
+
+		/* Scan for the SSID we're going to connect to */
+		memcpy(creq->ssids[0].ssid, sme->ssid, sme->ssid_len);
+		creq->ssids[0].ssid_len = sme->ssid_len;
+	} else {
+		/* No channels found... */
+		kfree(creq);
+		creq = NULL;
+	}
 
+	return creq;
+}
 
 static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_connect_params *sme)
@@ -1205,37 +1281,43 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	lbs_deb_enter(LBS_DEB_CFG80211);
 
-	if (sme->bssid) {
-		bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
-			sme->ssid, sme->ssid_len,
-			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
-	} else {
-		/*
-		 * Here we have an impedance mismatch. The firmware command
-		 * CMD_802_11_ASSOCIATE always needs a BSSID, it cannot
-		 * connect otherwise. However, for the connect-API of
-		 * cfg80211 the bssid is purely optional. We don't get one,
-		 * except the user specifies one on the "iw" command line.
-		 *
-		 * If we don't got one, we could initiate a scan and look
-		 * for the best matching cfg80211_bss entry.
-		 *
-		 * Or, better yet, net/wireless/sme.c get's rewritten into
-		 * something more generally useful.
+	if (!sme->bssid) {
+		/* Run a scan if one isn't in-progress already and if the last
+		 * scan was done more than 2 seconds ago.
 		 */
-		lbs_pr_err("TODO: no BSS specified\n");
-		ret = -ENOTSUPP;
-		goto done;
-	}
+		if (priv->scan_req == NULL &&
+		    time_after(jiffies, priv->last_scan + (2 * HZ))) {
+			struct cfg80211_scan_request *creq;
 
+			creq = _new_connect_scan_req(wiphy, sme);
+			if (!creq) {
+				ret = -EINVAL;
+				goto done;
+			}
+
+			lbs_deb_assoc("assoc: scanning for compatible AP\n");
+			_internal_start_scan(priv, true, creq);
+		}
+
+		/* Wait for any in-progress scan to complete */
+		lbs_deb_assoc("assoc: waiting for scan to complete\n");
+		wait_event_interruptible_timeout(priv->scan_q,
+						 (priv->scan_req == NULL),
+						 (15 * HZ));
+		lbs_deb_assoc("assoc: scanning competed\n");
+	}
 
+	/* Find the BSS we want using available scan results */
+	bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
+		sme->ssid, sme->ssid_len,
+		WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
 	if (!bss) {
-		lbs_pr_err("assicate: bss %pM not in scan results\n",
+		lbs_pr_err("assoc: bss %pM not in scan results\n",
 			   sme->bssid);
 		ret = -ENOENT;
 		goto done;
 	}
-	lbs_deb_assoc("trying %pM", sme->bssid);
+	lbs_deb_assoc("trying %pM\n", bss->bssid);
 	lbs_deb_assoc("cipher 0x%x, key index %d, key len %d\n",
 		      sme->crypto.cipher_group,
 		      sme->key_idx, sme->key_len);
@@ -1298,7 +1380,7 @@ static int lbs_cfg_connect(struct wiphy *wiphy, struct net_device *dev,
 	lbs_set_radio(priv, preamble, 1);
 
 	/* Do the actual association */
-	lbs_associate(priv, bss, sme);
+	ret = lbs_associate(priv, bss, sme);
 
  done:
 	if (bss)
diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 3c7e255..f062ed5 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -161,6 +161,11 @@ struct lbs_private {
 	/** Scanning */
 	struct delayed_work scan_work;
 	int scan_channel;
+	/* Queue of things waiting for scan completion */
+	wait_queue_head_t scan_q;
+	/* Whether the scan was initiated internally and not by cfg80211 */
+	bool internal_scan;
+	unsigned long last_scan;
 };
 
 extern struct cmd_confirm_sleep confirm_sleep;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 2589671..24958a8 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -719,6 +719,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	priv->deep_sleep_required = 0;
 	priv->wakeup_dev_required = 0;
 	init_waitqueue_head(&priv->ds_awake_q);
+	init_waitqueue_head(&priv->scan_q);
 	priv->authtype_auto = 1;
 	priv->is_host_sleep_configured = 0;
 	priv->is_host_sleep_activated = 0;
-- 
1.7.2


