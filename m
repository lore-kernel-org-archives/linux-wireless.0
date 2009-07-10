Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:51969 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853AbZGJQmg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 12:42:36 -0400
Subject: [PATCH] nl80211: report BSS status
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 10 Jul 2009 18:42:31 +0200
Message-Id: <1247244151.29747.10.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When connected to a BSS, or joined to an IBSS, we'll want
to know in userspace without using wireless extensions, so
report the BSS status in the BSS list. Userspace can query
the BSS list, display all the information and retrieve the
station information as well.

For example (from hwsim):

$ iw dev wlan1 scan dump
BSS 02:00:00:00:00:00 (on wlan1) -- associated
	freq: 2462
	beacon interval: 100
	capability: ESS ShortSlotTime (0x0401)
	signal: -50.00 dBm
	SSID: j
	Supported rates: 1.0* 2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 
	DS Paramater set: channel 11
	ERP: <no flags>
	Extended supported rates: 24.0 36.0 48.0 54.0 

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/linux/nl80211.h |   11 ++++++++
 net/wireless/nl80211.c  |   65 +++++++++++++++++++++++++++++++++++-------------
 2 files changed, 59 insertions(+), 17 deletions(-)

--- wireless-testing.orig/include/linux/nl80211.h	2009-07-10 18:36:04.000000000 +0200
+++ wireless-testing/include/linux/nl80211.h	2009-07-10 18:36:28.000000000 +0200
@@ -1260,6 +1260,7 @@ enum nl80211_channel_type {
  *	in mBm (100 * dBm) (s32)
  * @NL80211_BSS_SIGNAL_UNSPEC: signal strength of the probe response/beacon
  *	in unspecified units, scaled to 0..100 (u8)
+ * @NL80211_BSS_STATUS: status, if this BSS is "used"
  * @__NL80211_BSS_AFTER_LAST: internal
  * @NL80211_BSS_MAX: highest BSS attribute
  */
@@ -1273,6 +1274,7 @@ enum nl80211_bss {
 	NL80211_BSS_INFORMATION_ELEMENTS,
 	NL80211_BSS_SIGNAL_MBM,
 	NL80211_BSS_SIGNAL_UNSPEC,
+	NL80211_BSS_STATUS,
 
 	/* keep last */
 	__NL80211_BSS_AFTER_LAST,
@@ -1280,6 +1282,15 @@ enum nl80211_bss {
 };
 
 /**
+ * enum nl80211_bss_status - BSS "status"
+ */
+enum nl80211_bss_status {
+	NL80211_BSS_STATUS_AUTHENTICATED,
+	NL80211_BSS_STATUS_ASSOCIATED,
+	NL80211_BSS_STATUS_IBSS_JOINED,
+};
+
+/**
  * enum nl80211_auth_type - AuthenticationType
  *
  * @NL80211_AUTHTYPE_OPEN_SYSTEM: Open System authentication
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-10 18:36:03.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-10 18:36:28.000000000 +0200
@@ -3093,11 +3093,15 @@ static int nl80211_trigger_scan(struct s
 
 static int nl80211_send_bss(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			    struct cfg80211_registered_device *rdev,
-			    struct net_device *dev,
-			    struct cfg80211_bss *res)
+			    struct wireless_dev *wdev,
+			    struct cfg80211_internal_bss *intbss)
 {
+	struct cfg80211_bss *res = &intbss->pub;
 	void *hdr;
 	struct nlattr *bss;
+	int i;
+
+	ASSERT_WDEV_LOCK(wdev);
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags,
 			     NL80211_CMD_NEW_SCAN_RESULTS);
@@ -3106,7 +3110,7 @@ static int nl80211_send_bss(struct sk_bu
 
 	NLA_PUT_U32(msg, NL80211_ATTR_SCAN_GENERATION,
 		    rdev->bss_generation);
-	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, dev->ifindex);
+	NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, wdev->netdev->ifindex);
 
 	bss = nla_nest_start(msg, NL80211_ATTR_BSS);
 	if (!bss)
@@ -3135,6 +3139,28 @@ static int nl80211_send_bss(struct sk_bu
 		break;
 	}
 
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+		if (intbss == wdev->current_bss)
+			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
+				    NL80211_BSS_STATUS_ASSOCIATED);
+		else for (i = 0; i < MAX_AUTH_BSSES; i++) {
+			if (intbss != wdev->auth_bsses[i])
+				continue;
+			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
+				    NL80211_BSS_STATUS_AUTHENTICATED);
+			break;
+		}
+		break;
+	case NL80211_IFTYPE_ADHOC:
+		if (intbss == wdev->current_bss)
+			NLA_PUT_U32(msg, NL80211_BSS_STATUS,
+				    NL80211_BSS_STATUS_IBSS_JOINED);
+		break;
+	default:
+		break;
+	}
+
 	nla_nest_end(msg, bss);
 
 	return genlmsg_end(msg, hdr);
@@ -3147,9 +3173,10 @@ static int nl80211_send_bss(struct sk_bu
 static int nl80211_dump_scan(struct sk_buff *skb,
 			     struct netlink_callback *cb)
 {
-	struct cfg80211_registered_device *dev;
-	struct net_device *netdev;
+	struct cfg80211_registered_device *rdev;
+	struct net_device *dev;
 	struct cfg80211_internal_bss *scan;
+	struct wireless_dev *wdev;
 	int ifidx = cb->args[0];
 	int start = cb->args[1], idx = 0;
 	int err;
@@ -3170,39 +3197,43 @@ static int nl80211_dump_scan(struct sk_b
 		cb->args[0] = ifidx;
 	}
 
-	netdev = dev_get_by_index(&init_net, ifidx);
-	if (!netdev)
+	dev = dev_get_by_index(&init_net, ifidx);
+	if (!dev)
 		return -ENODEV;
 
-	dev = cfg80211_get_dev_from_ifindex(ifidx);
-	if (IS_ERR(dev)) {
-		err = PTR_ERR(dev);
+	rdev = cfg80211_get_dev_from_ifindex(ifidx);
+	if (IS_ERR(rdev)) {
+		err = PTR_ERR(rdev);
 		goto out_put_netdev;
 	}
 
-	spin_lock_bh(&dev->bss_lock);
-	cfg80211_bss_expire(dev);
+	wdev = dev->ieee80211_ptr;
+
+	wdev_lock(wdev);
+	spin_lock_bh(&rdev->bss_lock);
+	cfg80211_bss_expire(rdev);
 
-	list_for_each_entry(scan, &dev->bss_list, list) {
+	list_for_each_entry(scan, &rdev->bss_list, list) {
 		if (++idx <= start)
 			continue;
 		if (nl80211_send_bss(skb,
 				NETLINK_CB(cb->skb).pid,
 				cb->nlh->nlmsg_seq, NLM_F_MULTI,
-				dev, netdev, &scan->pub) < 0) {
+				rdev, wdev, scan) < 0) {
 			idx--;
 			goto out;
 		}
 	}
 
  out:
-	spin_unlock_bh(&dev->bss_lock);
+	spin_unlock_bh(&rdev->bss_lock);
+	wdev_unlock(wdev);
 
 	cb->args[1] = idx;
 	err = skb->len;
-	cfg80211_unlock_rdev(dev);
+	cfg80211_unlock_rdev(rdev);
  out_put_netdev:
-	dev_put(netdev);
+	dev_put(dev);
 
 	return err;
 }


