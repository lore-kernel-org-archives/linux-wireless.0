Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:39172 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752928AbbCIMnU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 08:43:20 -0400
Received: by lbiw7 with SMTP id w7so23823572lbi.6
        for <linux-wireless@vger.kernel.org>; Mon, 09 Mar 2015 05:43:17 -0700 (PDT)
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Marek Puzyniak <marek.puzyniak@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Subject: [PATCH v3 2/3] ath10k: make peer type configurable
Date: Mon,  9 Mar 2015 13:45:37 +0100
Message-Id: <1425905138-9966-3-git-send-email-marek.puzyniak@tieto.com> (sfid-20150309_134347_972799_D129F0DB)
In-Reply-To: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
References: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
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
index d5771e4..0eed7b5 100644
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
@@ -1223,7 +1224,8 @@ static void ath10k_control_ibss(struct ath10k_vif *arvif,
 		return;
 	}
 
-	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer);
+	ret = ath10k_peer_create(arvif->ar, arvif->vdev_id, self_peer,
+				 WMI_PEER_TYPE_DEFAULT);
 	if (ret) {
 		ath10k_warn(ar, "failed to create IBSS self peer %pM for vdev %d: %d\n",
 			    self_peer, arvif->vdev_id, ret);
@@ -2617,7 +2619,8 @@ void ath10k_offchan_tx_work(struct work_struct *work)
 				   peer_addr, vdev_id);
 
 		if (!peer) {
-			ret = ath10k_peer_create(ar, vdev_id, peer_addr);
+			ret = ath10k_peer_create(ar, vdev_id, peer_addr,
+						 WMI_PEER_TYPE_DEFAULT);
 			if (ret)
 				ath10k_warn(ar, "failed to create peer %pM on vdev %d: %d\n",
 					    peer_addr, vdev_id, ret);
@@ -3522,7 +3525,8 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 	}
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
-		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, vif->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to create vdev %i peer for AP: %d\n",
 				    arvif->vdev_id, ret);
@@ -4272,7 +4276,8 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 			goto exit;
 		}
 
-		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr);
+		ret = ath10k_peer_create(ar, arvif->vdev_id, sta->addr,
+					 WMI_PEER_TYPE_DEFAULT);
 		if (ret) {
 			ath10k_warn(ar, "failed to add peer %pM for vdev %d when adding a new sta: %i\n",
 				    sta->addr, arvif->vdev_id, ret);
diff --git a/drivers/net/wireless/ath/ath10k/wmi-ops.h b/drivers/net/wireless/ath/ath10k/wmi-ops.h
index c8b64e7..0a00abd 100644
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
@@ -624,14 +625,15 @@ ath10k_wmi_vdev_wmm_conf(struct ath10k *ar, u32 vdev_id,
 
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
index 939d86b..103393f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -1831,7 +1831,8 @@ ath10k_wmi_tlv_op_gen_sta_keepalive(struct ath10k *ar,
 
 static struct sk_buff *
 ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-				  const u8 peer_addr[ETH_ALEN])
+				  const u8 peer_addr[ETH_ALEN],
+				  enum wmi_peer_type peer_type)
 {
 	struct wmi_tlv_peer_create_cmd *cmd;
 	struct wmi_tlv *tlv;
@@ -1846,7 +1847,7 @@ ath10k_wmi_tlv_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
 	tlv->len = __cpu_to_le16(sizeof(*cmd));
 	cmd = (void *)tlv->value;
 	cmd->vdev_id = __cpu_to_le32(vdev_id);
-	cmd->peer_type = __cpu_to_le32(WMI_TLV_PEER_TYPE_DEFAULT); /* FIXME */
+	cmd->peer_type = __cpu_to_le32(peer_type);
 	ether_addr_copy(cmd->peer_addr.addr, peer_addr);
 
 	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi tlv peer create\n");
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 29aef7e..635d372 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4456,7 +4456,8 @@ ath10k_wmi_op_gen_vdev_spectral_enable(struct ath10k *ar, u32 vdev_id,
 
 static struct sk_buff *
 ath10k_wmi_op_gen_peer_create(struct ath10k *ar, u32 vdev_id,
-			      const u8 peer_addr[ETH_ALEN])
+			      const u8 peer_addr[ETH_ALEN],
+			      enum wmi_peer_type peer_type)
 {
 	struct wmi_peer_create_cmd *cmd;
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index adf935b..165fa55 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4333,6 +4333,12 @@ struct wmi_peer_create_cmd {
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

