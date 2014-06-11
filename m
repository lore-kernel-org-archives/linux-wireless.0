Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:36436 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186AbaFKOSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:42 -0400
Received: by mail-we0-f169.google.com with SMTP id t60so3987610wes.28
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:41 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 05/10] mac80211: use TDLS initiator in tdls_mgmt operations
Date: Wed, 11 Jun 2014 17:18:22 +0300
Message-Id: <1402496307-32522-5-git-send-email-arik@wizery.com> (sfid-20140611_161846_094028_BCFB0865)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TDLS initiator is set once during link setup. If determines the
address ordering in the link identifier IE.
Use the value from userspace in order to have a correct teardown packet.
With the current code, a teardown from the responder side fails the TDLS
MIC check because of a bad link identifier IE.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/tdls.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 0b3ca2c..c4a9af3 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -193,13 +193,14 @@ static int
 ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 				const u8 *peer, u8 action_code,
 				u8 dialog_token, u16 status_code,
-				u32 peer_capability, const u8 *extra_ies,
-				size_t extra_ies_len)
+				u32 peer_capability, bool initiator,
+				const u8 *extra_ies, size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = NULL;
 	bool send_direct;
+	const u8 *init_addr, *rsp_addr;
 	int ret;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
@@ -242,27 +243,42 @@ ieee80211_tdls_prep_mgmt_packet(struct wiphy *wiphy, struct net_device *dev,
 	if (extra_ies_len)
 		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
 
-	/* the TDLS link IE is always added last */
+	/* sanity check for initiator */
 	switch (action_code) {
 	case WLAN_TDLS_SETUP_REQUEST:
 	case WLAN_TDLS_SETUP_CONFIRM:
-	case WLAN_TDLS_TEARDOWN:
 	case WLAN_TDLS_DISCOVERY_REQUEST:
-		/* we are the initiator */
-		ieee80211_tdls_add_link_ie(skb, sdata->vif.addr, peer,
-					   sdata->u.mgd.bssid);
+		if (!initiator) {
+			ret = -EINVAL;
+			goto fail;
+		}
 		break;
 	case WLAN_TDLS_SETUP_RESPONSE:
 	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
-		/* we are the responder */
-		ieee80211_tdls_add_link_ie(skb, peer, sdata->vif.addr,
-					   sdata->u.mgd.bssid);
+		if (initiator) {
+			ret = -EINVAL;
+			goto fail;
+		}
+		break;
+	case WLAN_TDLS_TEARDOWN:
+		/* any value is ok */
 		break;
 	default:
 		ret = -ENOTSUPP;
 		goto fail;
 	}
 
+	if (initiator) {
+		init_addr = sdata->vif.addr;
+		rsp_addr = peer;
+	} else {
+		init_addr = peer;
+		rsp_addr = sdata->vif.addr;
+	}
+
+	ieee80211_tdls_add_link_ie(skb, init_addr, rsp_addr,
+				   sdata->u.mgd.bssid);
+
 	if (send_direct) {
 		ieee80211_tx_skb(sdata, skb);
 		return 0;
@@ -327,8 +343,8 @@ int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 
 	ret = ieee80211_tdls_prep_mgmt_packet(wiphy, dev, peer, action_code,
 					      dialog_token, status_code,
-					      peer_capability, extra_ies,
-					      extra_ies_len);
+					      peer_capability, initiator,
+					      extra_ies, extra_ies_len);
 	if (ret < 0)
 		goto exit;
 
-- 
1.9.1

