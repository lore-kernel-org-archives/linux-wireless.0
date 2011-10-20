Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37571 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1JTBDm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 21:03:42 -0400
Received: by mail-iy0-f174.google.com with SMTP id k3so2770432iae.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Oct 2011 18:03:42 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: anagar6@uic.edu, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>,
	johannes@sipsolutions.net, linville@tuxdriver.com
Subject: [PATCH 5/6] mac80211: add WMM IE to mesh frames
Date: Wed, 19 Oct 2011 18:03:25 -0700
Message-Id: <1319072606-28291-6-git-send-email-thomas@cozybit.com> (sfid-20111020_030345_916865_9978AD0F)
In-Reply-To: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the WMM IE in mesh peering and beacon frames. This is needed
tell any potential peers what our WMM / EDCA parameters are.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 include/linux/ieee80211.h |   26 +++++++++++++
 include/net/mac80211.h    |    4 ++
 net/mac80211/mesh_plink.c |    4 +-
 net/mac80211/tx.c         |    2 +
 net/mac80211/util.c       |   92 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 127 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 48363c3..ec6f396 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -152,6 +152,11 @@
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_MASK	0x03
 #define IEEE80211_WMM_IE_STA_QOSINFO_SP_SHIFT	5
 
+#define IEEE80211_WMM_IE_ECWMIN_MASK		0x0f
+#define IEEE80211_WMM_IE_ECWMIN_SHIFT		0
+#define IEEE80211_WMM_IE_ECWMAX_MASK		0xf0
+#define IEEE80211_WMM_IE_ECWMAX_SHIFT		4
+
 #define IEEE80211_HT_CTL_LEN		4
 
 struct ieee80211_hdr {
@@ -605,6 +610,27 @@ struct ieee80211_tim_ie {
 	u8 virtual_map[1];
 } __attribute__ ((packed));
 
+struct ieee80211_wmm_ac_param {
+	u8 ac_aci_acm_aifsn;
+	u8 ac_ecwmin_ecwmax;
+	__le16 ac_txop_limit;
+} __attribute__ ((packed));
+
+/**
+ * struct ieee80211_wmm_param
+ *
+ * This structure refers to "WMM parameter information element"
+ */
+struct ieee80211_wmm_param_ie {
+	u8 oui[3];
+	u8 oui_type;
+	u8 oui_subtype;
+	u8 version;
+	u8 qos_info;
+	u8 reserved;
+	struct ieee80211_wmm_ac_param ac[4];
+} __attribute__ ((packed));
+
 /**
  * struct ieee80211_meshconf_ie
  *
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dc1123a..fd28b2b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -3649,4 +3649,8 @@ int ieee80211_add_srates_ie(struct ieee80211_vif *vif, struct sk_buff *skb);
 
 int ieee80211_add_ext_srates_ie(struct ieee80211_vif *vif,
 				struct sk_buff *skb);
+int ieee80211_build_wmm_ie(struct ieee80211_vif *vif,
+			   u8 *ie_data);
+int ieee80211_add_wmm_ie(struct ieee80211_vif *vif,
+			 struct sk_buff *skb);
 #endif /* MAC80211_H */
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index f0705e6..069e5dc 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -177,6 +177,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 			    2 + sizeof(struct ieee80211_meshconf_ie) +
 			    2 + sizeof(struct ieee80211_ht_cap) +
 			    2 + sizeof(struct ieee80211_ht_info) +
+			    2 + sizeof(struct ieee80211_wmm_param_ie) +
 			    2 + 8 + /* peering IE */
 			    sdata->u.mesh.ie_len);
 	if (!skb)
@@ -256,7 +257,8 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 
 	if (action != WLAN_SP_MESH_PEERING_CLOSE) {
 		if (mesh_add_ht_cap_ie(skb, sdata) ||
-		    mesh_add_ht_info_ie(skb, sdata))
+		    mesh_add_ht_info_ie(skb, sdata) ||
+		    ieee80211_add_wmm_ie(&sdata->vif, skb))
 			return -1;
 	}
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index faca189..dfb6bb9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2294,6 +2294,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 				    2 + sizeof(struct ieee80211_ht_info) +
 				    2 + sdata->u.mesh.mesh_id_len +
 				    2 + sizeof(struct ieee80211_meshconf_ie) +
+				    2 + sizeof(struct ieee80211_wmm_param_ie) +
 				    sdata->u.mesh.ie_len);
 		if (!skb)
 			goto out;
@@ -2324,6 +2325,7 @@ struct sk_buff *ieee80211_beacon_get_tim(struct ieee80211_hw *hw,
 		    mesh_add_ht_info_ie(skb, sdata) ||
 		    mesh_add_meshid_ie(skb, sdata) ||
 		    mesh_add_meshconf_ie(skb, sdata) ||
+		    ieee80211_add_wmm_ie(&sdata->vif, skb) ||
 		    mesh_add_vendor_ies(skb, sdata)) {
 			pr_err("o11s: couldn't add ies!\n");
 			goto out;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 72b3a2e..071b425 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1419,6 +1419,98 @@ u8 *ieee80211_ie_build_ht_info(u8 *pos,
 	return pos + sizeof(struct ieee80211_ht_info);
 }
 
+static inline u8 ieee80211_wmm_ecw(struct ieee80211_tx_queue_params *txq)
+{
+	u8 cw_min, cw_max, n = 0;
+
+	/* cw_min and cw_max are transmitted as n in 2^n - 1 */
+	while ((txq->cw_min >> n) & 0x01)
+		n++;
+	cw_min = n;
+
+	n = 0;
+	while ((txq->cw_max >> n) & 0x01)
+		n++;
+	cw_max = n;
+
+	return ((cw_min << IEEE80211_WMM_IE_ECWMIN_SHIFT) &
+				IEEE80211_WMM_IE_ECWMIN_MASK) |
+		((cw_max << IEEE80211_WMM_IE_ECWMAX_SHIFT) &
+				IEEE80211_WMM_IE_ECWMAX_MASK);
+}
+
+static inline u8 ieee80211_aci_to_q(u8 aci)
+{
+	u8 q;
+
+	switch (aci) {
+	case 1:		/* BK */
+		q = 3;
+		break;
+	default:
+	case 0:		/* BE */
+		q = 2;
+		break;
+	case 2:		/* VI */
+		q = 1;
+		break;
+	case 3:		/* VO */
+		q = 0;
+		break;
+	}
+
+	return q;
+}
+
+int ieee80211_build_wmm_ie(struct ieee80211_vif *vif, u8 *data)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	struct ieee80211_wmm_param_ie *wmm;
+	struct ieee80211_wmm_ac_param *ac;
+	struct ieee80211_tx_queue_params *txconf;
+	u8 aci;
+
+	wmm = (struct ieee80211_wmm_param_ie *) data;
+	wmm->oui[0] = 0x00;
+	wmm->oui[1] = 0x50;
+	wmm->oui[2] = 0xf2;
+	wmm->oui_type = 2; /* WMM */
+	wmm->oui_subtype = 1; /* WMM param */
+	wmm->version = 1;
+	wmm->qos_info = 0;
+	wmm->reserved = 0;
+
+	for (aci = 0; aci < 4; aci++) {
+		ac = &wmm->ac[aci];
+		txconf = &sdata->tx_conf[ieee80211_aci_to_q(aci)];
+
+		ac->ac_aci_acm_aifsn = (aci << 5) | txconf->aifs;
+		ac->ac_ecwmin_ecwmax = ieee80211_wmm_ecw(txconf);
+		ac->ac_txop_limit = cpu_to_le16(txconf->txop);
+	}
+
+	return 0;
+}
+
+int ieee80211_add_wmm_ie(struct ieee80211_vif *vif,
+			 struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+	u8 *pos;
+
+	if (sdata->local->hw.queues < 4)
+		return 0;
+
+	if (skb_tailroom(skb) < 2 + sizeof(struct ieee80211_wmm_param_ie))
+		return -ENOMEM;
+
+	pos = skb_put(skb, 2 + sizeof(struct ieee80211_wmm_param_ie));
+	*pos++ = WLAN_EID_VENDOR_SPECIFIC;
+	*pos++ = sizeof(struct ieee80211_wmm_param_ie);
+
+	return ieee80211_build_wmm_ie(vif, pos);
+}
+
 enum nl80211_channel_type
 ieee80211_ht_info_to_channel_type(struct ieee80211_ht_info *ht_info)
 {
-- 
1.7.5.4

