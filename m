Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:36336 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbaGQOOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:07 -0400
Received: by mail-we0-f176.google.com with SMTP id q58so3215328wes.7
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:04 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 01/15] mac80211: track TDLS initiator internally
Date: Thu, 17 Jul 2014 17:14:17 +0300
Message-Id: <1405606471-30128-2-git-send-email-arik@wizery.com> (sfid-20140717_161434_108121_72029640)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Infer the TDLS initiator and track it in mac80211 via a STA flag. This
avoids breaking old userspace that doesn't pass it via nl80211 APIs.

The only case where userspace will need to pass the initiator is when the
STA is removed due to unreachability before a teardown packet is sent.
Support for unreachability was only recently added to wpa_supplicant, so
it won't be a problem in practice.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/sta_info.h |  3 +++
 net/mac80211/tdls.c     | 35 ++++++++++++++++++++++++-----------
 2 files changed, 27 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 2a04361..e37f009 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -47,6 +47,8 @@
  * @WLAN_STA_TDLS_PEER: Station is a TDLS peer.
  * @WLAN_STA_TDLS_PEER_AUTH: This TDLS peer is authorized to send direct
  *	packets. This means the link is enabled.
+ * @WLAN_STA_TDLS_INITIATOR: We are the initiator of the TDLS link with this
+ *	station.
  * @WLAN_STA_UAPSD: Station requested unscheduled SP while driver was
  *	keeping station in power-save mode, reply when the driver
  *	unblocks the station.
@@ -76,6 +78,7 @@ enum ieee80211_sta_info_flags {
 	WLAN_STA_PSPOLL,
 	WLAN_STA_TDLS_PEER,
 	WLAN_STA_TDLS_PEER_AUTH,
+	WLAN_STA_TDLS_INITIATOR,
 	WLAN_STA_UAPSD,
 	WLAN_STA_SP,
 	WLAN_STA_4ADDR_EVENT,
diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index f718533..b01b310 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -203,6 +203,7 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	struct sk_buff *skb = NULL;
 	bool send_direct;
 	const u8 *init_addr, *rsp_addr;
+	struct sta_info *sta;
 	int ret;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
@@ -245,32 +246,40 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (extra_ies_len)
 		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
 
-	/* sanity check for initiator */
+	rcu_read_lock();
+	sta = sta_info_get(sdata, peer);
+
+	/* infer the initiator if we can, to support old userspace */
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
+		if (sta)
+			set_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
+		/* fall-through */
 	case WLAN_TDLS_SETUP_CONFIRM:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
-		if (!initiator) {
-			ret = -EINVAL;
-			goto fail;
-		}
+		initiator = true;
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
+		/*
+		 * In some testing scenarios, we send a request and response.
+		 * Make the last packet sent take effect for the initiator
+		 * value.
+		 */
+		if (sta)
+			clear_sta_flag(sta, WLAN_STA_TDLS_INITIATOR);
+		/* fall-through */
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		if (initiator) {
-			ret = -EINVAL;
-			goto fail;
-		}
+		initiator = false;
 		break;
 	case WLAN_TDLS_TEARDOWN:
 		/* any value is ok */
 		break;
 	default:
 		ret = -ENOTSUPP;
-		goto fail;
+		break;
 	}
 
-	if (initiator) {
+	if (initiator || (sta && test_sta_flag(sta, WLAN_STA_TDLS_INITIATOR))) {
 		init_addr = sdata->vif.addr;
 		rsp_addr = peer;
 	} else {
@@ -278,6 +287,10 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 		rsp_addr = sdata->vif.addr;
 	}
 
+	rcu_read_unlock();
+	if (ret < 0)
+		goto fail;
+
 	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
 				   sdata->u.mgd.bssid);
 
-- 
1.9.1

