Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:9067 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbbFPFyH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:07 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 1/8] ath10k: enhance swba event handler to adapt different size tim bitmap
Date: Tue, 16 Jun 2015 11:23:08 +0530
Message-ID: <1434433995-8451-2-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_075410_923790_2EB93681)
In-Reply-To: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Due to 512 client support in 10.4 firmware, size of tim ie is going
to be slightly higher than non 10.4 firmware. So, size of tim_bitmap
what is carried in swba event from 10.4 firmware is bit higher.

The only bottle neck to reuse existing swba handler
ath10k_wmi_event_host_swba() for 10.4 is that code designed to deal
with fixed size tim bitmap(ie, tim_info[].tim_bitmap in wmi_swba_ev_arg).
This patch removes such size limitation and makes it more suitable
to handle swba event which has different size tim bitmap.

All existing swba event parsing functions are changed to adapt this
change. Actual support to handle 10.4 swba event is added in next patch.
Only preparation is made in this patch.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 18 +++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c     | 49 +++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath10k/wmi.h     | 10 ++++++-
 3 files changed, 62 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index e165e26..e8f6912 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -709,6 +709,8 @@ static int ath10k_wmi_tlv_swba_tim_parse(struct ath10k *ar, u16 tag, u16 len,
 					 const void *ptr, void *data)
 {
 	struct wmi_tlv_swba_parse *swba = data;
+	struct wmi_tim_info_arg *tim_info_arg;
+	const struct wmi_tim_info *tim_info_ev = ptr;
 
 	if (tag != WMI_TLV_TAG_STRUCT_TIM_INFO)
 		return -EPROTO;
@@ -716,7 +718,21 @@ static int ath10k_wmi_tlv_swba_tim_parse(struct ath10k *ar, u16 tag, u16 len,
 	if (swba->n_tim >= ARRAY_SIZE(swba->arg->tim_info))
 		return -ENOBUFS;
 
-	swba->arg->tim_info[swba->n_tim++] = ptr;
+	if (__le32_to_cpu(tim_info_ev->tim_len) >
+	     sizeof(tim_info_ev->tim_bitmap)) {
+		ath10k_warn(ar, "refusing to parse invalid swba structure\n");
+		return -EPROTO;
+	}
+
+	tim_info_arg = &swba->arg->tim_info[swba->n_tim];
+	tim_info_arg->tim_len = tim_info_ev->tim_len;
+	tim_info_arg->tim_mcast = tim_info_ev->tim_mcast;
+	tim_info_arg->tim_bitmap = tim_info_ev->tim_bitmap;
+	tim_info_arg->tim_changed = tim_info_ev->tim_changed;
+	tim_info_arg->tim_num_ps_pending = tim_info_ev->tim_num_ps_pending;
+
+	swba->n_tim++;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8d4ff3e..793d7c21 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2788,33 +2788,38 @@ exit:
 static void ath10k_wmi_update_tim(struct ath10k *ar,
 				  struct ath10k_vif *arvif,
 				  struct sk_buff *bcn,
-				  const struct wmi_tim_info *tim_info)
+				  const struct wmi_tim_info_arg *tim_info)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)bcn->data;
 	struct ieee80211_tim_ie *tim;
 	u8 *ies, *ie;
 	u8 ie_len, pvm_len;
 	__le32 t;
-	u32 v;
+	u32 v, tim_len;
+
+	/* When FW reports 0 in tim_len, ensure atleast first byte
+	 * in tim_bitmap is considered for pvm calculation.
+	 */
+	tim_len = tim_info->tim_len ? __le32_to_cpu(tim_info->tim_len) : 1;
 
 	/* if next SWBA has no tim_changed the tim_bitmap is garbage.
 	 * we must copy the bitmap upon change and reuse it later */
 	if (__le32_to_cpu(tim_info->tim_changed)) {
 		int i;
 
-		BUILD_BUG_ON(sizeof(arvif->u.ap.tim_bitmap) !=
-			     sizeof(tim_info->tim_bitmap));
+		WARN_ON(sizeof(arvif->u.ap.tim_bitmap) < tim_len);
 
-		for (i = 0; i < sizeof(arvif->u.ap.tim_bitmap); i++) {
+		for (i = 0; i < tim_len; i++) {
 			t = tim_info->tim_bitmap[i / 4];
 			v = __le32_to_cpu(t);
 			arvif->u.ap.tim_bitmap[i] = (v >> ((i % 4) * 8)) & 0xFF;
 		}
 
-		/* FW reports either length 0 or 16
-		 * so we calculate this on our own */
+		/* FW reports either length 0 or length based on max supported
+		 * station. so we calculate this on our own
+		 */
 		arvif->u.ap.tim_len = 0;
-		for (i = 0; i < sizeof(arvif->u.ap.tim_bitmap); i++)
+		for (i = 0; i < tim_len; i++)
 			if (arvif->u.ap.tim_bitmap[i])
 				arvif->u.ap.tim_len = i;
 
@@ -2838,7 +2843,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 	pvm_len = ie_len - 3; /* exclude dtim count, dtim period, bmap ctl */
 
 	if (pvm_len < arvif->u.ap.tim_len) {
-		int expand_size = sizeof(arvif->u.ap.tim_bitmap) - pvm_len;
+		int expand_size = tim_len - pvm_len;
 		int move_size = skb_tail_pointer(bcn) - (ie + 2 + ie_len);
 		void *next_ie = ie + 2 + ie_len;
 
@@ -2853,7 +2858,7 @@ static void ath10k_wmi_update_tim(struct ath10k *ar,
 		}
 	}
 
-	if (pvm_len > sizeof(arvif->u.ap.tim_bitmap)) {
+	if (pvm_len > tim_len) {
 		ath10k_warn(ar, "tim pvm length is too great (%d)\n", pvm_len);
 		return;
 	}
@@ -2917,7 +2922,21 @@ static int ath10k_wmi_op_pull_swba_ev(struct ath10k *ar, struct sk_buff *skb,
 		if (WARN_ON_ONCE(i == ARRAY_SIZE(arg->tim_info)))
 			break;
 
-		arg->tim_info[i] = &ev->bcn_info[i].tim_info;
+		if (__le32_to_cpu(ev->bcn_info[i].tim_info.tim_len) >
+		     sizeof(ev->bcn_info[i].tim_info.tim_bitmap)) {
+			ath10k_warn(ar, "refusing to parse invalid swba structure\n");
+			return -EPROTO;
+		}
+
+		arg->tim_info[i].tim_len = ev->bcn_info[i].tim_info.tim_len;
+		arg->tim_info[i].tim_mcast = ev->bcn_info[i].tim_info.tim_mcast;
+		arg->tim_info[i].tim_bitmap =
+				ev->bcn_info[i].tim_info.tim_bitmap;
+		arg->tim_info[i].tim_changed =
+				ev->bcn_info[i].tim_info.tim_changed;
+		arg->tim_info[i].tim_num_ps_pending =
+				ev->bcn_info[i].tim_info.tim_num_ps_pending;
+
 		arg->noa_info[i] = &ev->bcn_info[i].p2p_noa_info;
 		i++;
 	}
@@ -2930,7 +2949,7 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 	struct wmi_swba_ev_arg arg = {};
 	u32 map;
 	int i = -1;
-	const struct wmi_tim_info *tim_info;
+	const struct wmi_tim_info_arg *tim_info;
 	const struct wmi_p2p_noa_info *noa_info;
 	struct ath10k_vif *arvif;
 	struct sk_buff *bcn;
@@ -2959,7 +2978,7 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			break;
 		}
 
-		tim_info = arg.tim_info[i];
+		tim_info = &arg.tim_info[i];
 		noa_info = arg.noa_info[i];
 
 		ath10k_dbg(ar, ATH10K_DBG_MGMT,
@@ -2974,6 +2993,10 @@ void ath10k_wmi_event_host_swba(struct ath10k *ar, struct sk_buff *skb)
 			   __le32_to_cpu(tim_info->tim_bitmap[1]),
 			   __le32_to_cpu(tim_info->tim_bitmap[0]));
 
+		/* TODO: Only first 4 word from tim_bitmap is dumped.
+		 * Extend debug code to dump full tim_bitmap.
+		 */
+
 		arvif = ath10k_get_arvif(ar, vdev_id);
 		if (arvif == NULL) {
 			ath10k_warn(ar, "no vif for vdev_id %d found\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1371c8a..e63f68c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -5093,6 +5093,14 @@ struct wmi_tim_info {
 	__le32 tim_num_ps_pending;
 } __packed;
 
+struct wmi_tim_info_arg {
+	__le32 tim_len;
+	__le32 tim_mcast;
+	const __le32 *tim_bitmap;
+	__le32 tim_changed;
+	__le32 tim_num_ps_pending;
+} __packed;
+
 /* Maximum number of NOA Descriptors supported */
 #define WMI_P2P_MAX_NOA_DESCRIPTORS 4
 #define WMI_P2P_OPPPS_ENABLE_BIT	BIT(0)
@@ -5643,7 +5651,7 @@ struct wmi_peer_kick_ev_arg {
 
 struct wmi_swba_ev_arg {
 	__le32 vdev_map;
-	const struct wmi_tim_info *tim_info[WMI_MAX_AP_VDEV];
+	struct wmi_tim_info_arg tim_info[WMI_MAX_AP_VDEV];
 	const struct wmi_p2p_noa_info *noa_info[WMI_MAX_AP_VDEV];
 };
 
-- 
1.8.1.2

