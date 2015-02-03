Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:50288 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbbBCKk3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2015 05:40:29 -0500
Received: by mail-wi0-f171.google.com with SMTP id l15so23134647wiw.4
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2015 02:40:28 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [RFC 2/4] ath10k: make peer type configurable
Date: Tue,  3 Feb 2015 11:41:52 +0100
Message-Id: <1422960114-25137-3-git-send-email-marek.puzyniak@tieto.com> (sfid-20150203_114045_231524_E14D09A2)
In-Reply-To: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
References: <1422960114-25137-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peer type was hardcoded to default value.
For future implementation it is required
to make is configurable.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 14 +++++++++-----
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  8 +++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  5 +++--
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  6 ++++++
 5 files changed, 25 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index c5815ce..7f0a594 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -381,7 +381,8 @@ ath10k_mac_get_any_chandef_iter(struct ieee80211_hw *hw,
 	*def = &conf->def;
 }
 
-static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
+static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr,
+			      enum wmi_peer_type peer_type)
 {
 	int ret;
 
@@ -390,7 +391,7 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 	if (ar->num_peers >= ar->max_num_peers)
 		return -ENOBUFS;
 
-	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
+	ret = ath10k_wmi_peer_create(ar, vdev_id, addr, peer_type);
 	if (ret) {
 		ath10k_warn(ar, "failed to create wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
@@ -2772,7 +2773,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 				   peer_addr, vdev_id);
 
 		if (!peer) {
-			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
+			ret = ath10k_peer_create(ar, vdev_id, peer_addr,
+						 WMI_PEER_TYPE_DEFAULT);
 			if (ret)
 				ath10k_warn(ar, "failed to create peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
@@ -3686,7 +3688,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
 	    arvif->vdev_type == WMI_VDEV_TYPE_IBSS) {
-		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to create vdev %i peer for AP/IBSS: %d\n",
 				    arvif->vdev_id, ret);
@@ -4439,7 +4442,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
-		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 71334f5..16d2d7c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -83,7 +83,8 @@ struct wmi_ops {
 	struct sk_buff *(*gen_vdev_wmm_conf)(struct ath10k *ar, u32 vdev_id,
 					     const struct wmi_wmm_params_all_arg *arg);
 	struct sk_buff *(*gen_peer_create)(struct ath10k *ar, u32 vdev_id,
-					   const u8 peer_addr[ETH_ALEN]);
+					   const u8 peer_addr[ETH_ALEN],
+					   enum wmi_peer_type peer_type);
 	struct sk_buff *(*gen_peer_delete)(struct ath10k *ar, u32 vdev_id,
 					   const u8 peer_addr[ETH_ALEN]);
 	struct sk_buff *(*gen_peer_flush)(struct ath10k *ar, u32 vdev_id,
@@ -633,14 +634,15 @@ ath10k_wmi_vdev_wmm_conf(struct ath10k *ar, u32 vdev_id,
 
 static inline int
 ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
-		       const u8 peer_addr[ETH_ALEN])
+		       const u8 peer_addr[ETH_ALEN],
+		       enum wmi_peer_type peer_type)
 {
 	struct sk_buff *skb;
 
 	if (!ar->wmi.ops->gen_peer_create)
 		return -EOPNOTSUPP;
 
-	skb = ar->wmi.ops->gen_peer_create(ar, vdev_id, peer_addr);
+	skb = ar->wmi.ops->gen_peer_create(ar, vdev_id, peer_addr, peer_type);
 	if (IS_ERR(skb))
 		return PTR_ERR(skb);
 
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index a846821..16b0e6b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1963,7 +1963,8 @@ ath10k_wmi_tlv_op_gen_sta_keepalive(struct ath10k *ar,
 
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-				  const u8 peer_addr[ETH_ALEN])
+				  const u8 peer_addr[ETH_ALEN],
+				  enum wmi_peer_type peer_type)
 {
 	struct wmi_tlv_peer_create_cmd *cmd;
 	struct wmi_tlv *tlv;
@@ -1978,7 +1979,7 @@ ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	cmd->peer_type = __cpu_to_le32(WMI_TLV_PEER_TYPE_DEFAULT); /* FIXME */
+	cmd->peer_type = __cpu_to_le32(peer_type);
 	ether_addr_copy(cmd->peer_addr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d03d175..2415845 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4574,7 +4574,8 @@ ath10k_wmi_op_gen_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id,
 
 static struct sk_buff *
 ath10k_wmi_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-			      const u8 peer_addr[ETH_ALEN])
+			      const u8 peer_addr[ETH_ALEN],
+			      enum wmi_peer_type peer_type)
 {
 	struct wmi_peer_create_cmd *cmd;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 23d76c0..01cdb8b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4348,6 +4348,12 @@ struct wmi_peer_create_cmd {
 	struct wmi_mac_addr peer_macaddr;
 } __packed;
 
+enum wmi_peer_type {
+	WMI_PEER_TYPE_DEFAULT = 0,
+	WMI_PEER_TYPE_BSS = 1,
+	WMI_PEER_TYPE_TDLS = 2,
+};
+
 struct wmi_peer_delete_cmd {
 	__le32 vdev_id;
 	struct wmi_mac_addr peer_macaddr;
-- 
2.1.4

