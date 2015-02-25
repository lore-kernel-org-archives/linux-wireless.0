Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:40752 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbbBYHxZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 02:53:25 -0500
Received: by labgd6 with SMTP id gd6so2097062lab.7
        for <linux-wireless@vger.kernel.org>; Tue, 24 Feb 2015 23:53:23 -0800 (PST)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH v2 2/4] ath10k: make peer type configurable
Date: Wed, 25 Feb 2015 08:55:09 +0100
Message-Id: <1424850911-21017-3-git-send-email-marek.puzyniak@tieto.com> (sfid-20150225_085334_827217_FF94105F)
In-Reply-To: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
References: <1424850911-21017-1-git-send-email-marek.puzyniak@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Peer type was hardcoded to default value.
For future implementation it is required
to make is configurable.

Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c     | 17 +++++++++++------
 drivers/net/wireless/ath/ath10k/wmi-ops.h |  8 +++++---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  5 +++--
 drivers/net/wireless/ath/ath10k/wmi.c     |  3 ++-
 drivers/net/wireless/ath/ath10k/wmi.h     |  6 ++++++
 5 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 6d126d0..7378656 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -364,7 +364,8 @@ static u8 ath10k_parse_mpdudensity(u8 mpdudensity)
 	}
 }
 
-static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
+static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr,
+			      enum wmi_peer_type peer_type)
 {
 	int ret;
 
@@ -373,7 +374,7 @@ static int ath10k_peer_create(struct ath10k *ar, u32 vdev_id, const u8 *addr)
 	if (ar->num_peers >= ar->max_num_peers)
 		return -ENOBUFS;
 
-	ret = ath10k_wmi_peer_create(ar, vdev_id, addr);
+	ret = ath10k_wmi_peer_create(ar, vdev_id, addr, peer_type);
 	if (ret) {
 		ath10k_warn(ar, "failed to create wmi peer %pM on vdev %i: %i\n",
 			    addr, vdev_id, ret);
@@ -1187,7 +1188,8 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		return;
 	}
 
-	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer);
+	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer,
+				 WMI_PEER_TYPE_DEFAULT);
 	if (ret) {
 		ath10k_warn(ar, "failed to create IBSS self peer %pM for vdev %d: %d\n",
 			    self_peer, arvif->vdev_id, ret);
@@ -2417,7 +2419,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 				   peer_addr, vdev_id);
 
 		if (!peer) {
-			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
+			ret = ath10k_peer_create(ar, vdev_id, peer_addr,
+						 WMI_PEER_TYPE_DEFAULT);
 			if (ret)
 				ath10k_warn(ar, "failed to create peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
@@ -3300,7 +3303,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
-		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to create vdev %i peer for AP: %d\n",
 				    arvif->vdev_id, ret);
@@ -4023,7 +4027,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
-		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index 04dc4b9..a2cded8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-ops.h
+++ b/drivers/net/wireless/ath/ath10k/wmi-ops.h
@@ -81,7 +81,8 @@ struct wmi_ops {
 	struct sk_buff *(*gen_vdev_wmm_conf)(struct ath10k *ar, u32 vdev_id,
 					     const struct wmi_wmm_params_all_arg *arg);
 	struct sk_buff *(*gen_peer_create)(struct ath10k *ar, u32 vdev_id,
-					   const u8 peer_addr[ETH_ALEN]);
+					   const u8 peer_addr[ETH_ALEN],
+					   enum wmi_peer_type peer_type);
 	struct sk_buff *(*gen_peer_delete)(struct ath10k *ar, u32 vdev_id,
 					   const u8 peer_addr[ETH_ALEN]);
 	struct sk_buff *(*gen_peer_flush)(struct ath10k *ar, u32 vdev_id,
@@ -625,14 +626,15 @@ ath10k_wmi_vdev_wmm_conf(struct ath10k *ar, u32 vdev_id,
 
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
index 71614ba..809c046 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1681,7 +1681,8 @@ ath10k_wmi_tlv_op_gen_sta_keepalive(struct ath10k *ar,
 
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-				  const u8 peer_addr[ETH_ALEN])
+				  const u8 peer_addr[ETH_ALEN],
+				  enum wmi_peer_type peer_type)
 {
 	struct wmi_tlv_peer_create_cmd *cmd;
 	struct wmi_tlv *tlv;
@@ -1696,7 +1697,7 @@ ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	cmd->peer_type = __cpu_to_le32(WMI_TLV_PEER_TYPE_DEFAULT); /* FIXME */
+	cmd->peer_type = __cpu_to_le32(peer_type);
 	ether_addr_copy(cmd->peer_addr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv peer create\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index aeea1c7..b285291 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4519,7 +4519,8 @@ ath10k_wmi_op_gen_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id,
 
 static struct sk_buff *
 ath10k_wmi_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-			      const u8 peer_addr[ETH_ALEN])
+			      const u8 peer_addr[ETH_ALEN],
+			      enum wmi_peer_type peer_type)
 {
 	struct wmi_peer_create_cmd *cmd;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 20ce360..0ffa90a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4324,6 +4324,12 @@ struct wmi_peer_create_cmd {
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

