Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39179 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2CQXBH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2012 19:01:07 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net
Subject: [PATCH 1/3] cfg80211: use compare_ether_addr on MAC addresses instead of memcmp
Date: Sun, 18 Mar 2012 00:00:52 +0100
Message-Id: <1332025254-5048-1-git-send-email-nbd@openwrt.org> (sfid-20120318_000112_395789_79EBB401)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Because of the constant size and guaranteed 16 bit alignment, the inline
compare_ether_addr function is much cheaper than calling memcmp.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/mlme.c |   32 +++++++++++++++++---------------
 net/wireless/scan.c |    2 +-
 2 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index f5a7ac3..e14fdcc 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -6,6 +6,7 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/etherdevice.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
 #include <linux/slab.h>
@@ -100,7 +101,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
 	ASSERT_WDEV_LOCK(wdev);
 
 	if (wdev->current_bss &&
-	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(wdev->current_bss->pub.bssid, bssid) == 0) {
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
 		wdev->current_bss = NULL;
@@ -115,7 +116,7 @@ void __cfg80211_send_deauth(struct net_device *dev,
 
 		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
-		from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
+		from_ap = compare_ether_addr(mgmt->sa, dev->dev_addr) != 0;
 		__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
 		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
@@ -154,7 +155,7 @@ void __cfg80211_send_disassoc(struct net_device *dev,
 		return;
 
 	if (wdev->current_bss &&
-	    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(wdev->current_bss->pub.bssid, bssid) == 0) {
 		cfg80211_sme_disassoc(dev, wdev->current_bss);
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
@@ -165,7 +166,7 @@ void __cfg80211_send_disassoc(struct net_device *dev,
 
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
-	from_ap = memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0;
+	from_ap = compare_ether_addr(mgmt->sa, dev->dev_addr) != 0;
 	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 }
 EXPORT_SYMBOL(__cfg80211_send_disassoc);
@@ -285,7 +286,7 @@ int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 			return -EINVAL;
 
 	if (wdev->current_bss &&
-	    memcmp(bssid, wdev->current_bss->pub.bssid, ETH_ALEN) == 0)
+	    compare_ether_addr(bssid, wdev->current_bss->pub.bssid) == 0)
 		return -EALREADY;
 
 	memset(&req, 0, sizeof(req));
@@ -362,7 +363,7 @@ int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 	memset(&req, 0, sizeof(req));
 
 	if (wdev->current_bss && prev_bssid &&
-	    memcmp(wdev->current_bss->pub.bssid, prev_bssid, ETH_ALEN) == 0) {
+	    compare_ether_addr(wdev->current_bss->pub.bssid, prev_bssid) == 0) {
 		/*
 		 * Trying to reassociate: Allow this to proceed and let the old
 		 * association to be dropped when the new one is completed.
@@ -446,7 +447,8 @@ int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 
 	if (local_state_change) {
 		if (wdev->current_bss &&
-		    memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0) {
+		    compare_ether_addr(wdev->current_bss->pub.bssid, bssid)
+		    == 0) {
 			cfg80211_unhold_bss(wdev->current_bss);
 			cfg80211_put_bss(&wdev->current_bss->pub);
 			wdev->current_bss = NULL;
@@ -495,7 +497,7 @@ static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
 	req.local_state_change = local_state_change;
 	req.ie = ie;
 	req.ie_len = ie_len;
-	if (memcmp(wdev->current_bss->pub.bssid, bssid, ETH_ALEN) == 0)
+	if (compare_ether_addr(wdev->current_bss->pub.bssid, bssid) == 0)
 		req.bss = &wdev->current_bss->pub;
 	else
 		return -ENOTCONN;
@@ -758,8 +760,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 				break;
 			}
 
-			if (memcmp(wdev->current_bss->pub.bssid,
-				   mgmt->bssid, ETH_ALEN)) {
+			if (compare_ether_addr(wdev->current_bss->pub.bssid,
+					       mgmt->bssid)) {
 				err = -ENOTCONN;
 				break;
 			}
@@ -772,8 +774,8 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 				break;
 
 			/* for station, check that DA is the AP */
-			if (memcmp(wdev->current_bss->pub.bssid,
-				   mgmt->da, ETH_ALEN)) {
+			if (compare_ether_addr(wdev->current_bss->pub.bssid,
+					       mgmt->da)) {
 				err = -ENOTCONN;
 				break;
 			}
@@ -781,11 +783,11 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		case NL80211_IFTYPE_AP:
 		case NL80211_IFTYPE_P2P_GO:
 		case NL80211_IFTYPE_AP_VLAN:
-			if (memcmp(mgmt->bssid, dev->dev_addr, ETH_ALEN))
+			if (compare_ether_addr(mgmt->bssid, dev->dev_addr))
 				err = -EINVAL;
 			break;
 		case NL80211_IFTYPE_MESH_POINT:
-			if (memcmp(mgmt->sa, mgmt->bssid, ETH_ALEN)) {
+			if (compare_ether_addr(mgmt->sa, mgmt->bssid)) {
 				err = -EINVAL;
 				break;
 			}
@@ -804,7 +806,7 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			return err;
 	}
 
-	if (memcmp(mgmt->sa, dev->dev_addr, ETH_ALEN) != 0)
+	if (compare_ether_addr(mgmt->sa, dev->dev_addr) != 0)
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 70faadf..fdbcfe6 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -378,7 +378,7 @@ static int cmp_bss_core(struct cfg80211_bss *a,
 			       b->len_information_elements);
 	}
 
-	return memcmp(a->bssid, b->bssid, ETH_ALEN);
+	return compare_ether_addr(a->bssid, b->bssid);
 }
 
 static int cmp_bss(struct cfg80211_bss *a,
-- 
1.7.3.2

