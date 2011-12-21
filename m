Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54717 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1LUA0d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 19:26:33 -0500
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2] ath6kl: Support for TCP checksum offload to firmware
Date: Tue, 20 Dec 2011 16:25:36 -0800
Message-ID: <1324427136-8183-1-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111221_012637_788927_B7ACD0F9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change enables offloading TCP checksum calculation to firmware.
The support has been added for QA team's testing purposes and currently
there is no plan to offload the feature to firmware by default at
load time.

To enable TCP checksum offload for tx and rx paths, use
the ethtool as follows:
ethtool -K <interface> tx on
ethtool -K <interface> rx on

To disable TCP checksum offload, for tx and rx paths, use
the ethtool as follows:
ethtool -K <interface> tx off
ethtool -K <interface> rx off

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/init.c |    2 +
 drivers/net/wireless/ath/ath6kl/txrx.c |   61 +++++++++++++++++++++++++++++---
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 ++
 3 files changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c97f83c..b232cc4 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -1649,6 +1649,8 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
+	ndev->hw_features |= (NETIF_F_IP_CSUM | NETIF_F_RXCSUM);
+
 	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
 		ath6kl_err("Failed to start hardware: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 506a303..e402b73 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -244,6 +244,8 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	u8 ac = 99 ; /* initialize to unmapped ac */
 	bool chk_adhoc_ps_mapping = false, more_data = false;
 	int ret;
+	struct wmi_tx_meta_v2 meta_v2;
+	u8 csum_start = 0, csum_dest = 0, csum = skb->ip_summed;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
 		   "%s: skb=0x%p, data=0x%p, len=0x%x\n", __func__,
@@ -265,6 +267,14 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
+		if ((dev->hw_features & NETIF_F_IP_CSUM) &&
+				(csum == CHECKSUM_PARTIAL)) {
+			csum_start = skb->csum_start -
+					(skb_network_header(skb) - skb->head) +
+					sizeof(struct ath6kl_llc_snap_hdr);
+			csum_dest = skb->csum_offset + csum_start;
+		}
+
 		if (skb_headroom(skb) < dev->needed_headroom) {
 			struct sk_buff *tmp_skb = skb;
 
@@ -281,11 +291,31 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if (ath6kl_wmi_data_hdr_add(ar->wmi, skb, DATA_MSGTYPE,
-					    more_data, 0, 0, NULL,
-					    vif->fw_vif_idx)) {
-			ath6kl_err("wmi_data_hdr_add failed\n");
-			goto fail_tx;
+		if ((dev->hw_features & NETIF_F_IP_CSUM) &&
+				(csum == CHECKSUM_PARTIAL)) {
+			meta_v2.csum_start = csum_start;
+			meta_v2.csum_dest = csum_dest;
+
+/*instruct target to calculate checksum*/
+			meta_v2.csum_flags = CSUM_OFFLOAD_FLAG;
+			ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
+					DATA_MSGTYPE, more_data, 0,
+					WMI_META_VERSION_2,
+					&meta_v2, vif->fw_vif_idx);
+			if (ret) {
+				ath6kl_warn("failed to add tcp checksum:%d\n"
+						, ret);
+				goto fail_tx;
+			}
+		} else {
+			ret = ath6kl_wmi_data_hdr_add(ar->wmi, skb,
+						DATA_MSGTYPE, more_data, 0, 0,
+						NULL, vif->fw_vif_idx);
+			if (ret) {
+				ath6kl_warn("failed to add wmi data header:%d\n"
+						, ret);
+				goto fail_tx;
+			}
 		}
 
 		if ((vif->nw_type == ADHOC_NETWORK) &&
@@ -1259,6 +1289,27 @@ void ath6kl_rx(struct htc_target *target, struct htc_packet *packet)
 		break;
 	}
 
+/*Support for configuring rx checksum offload*/
+	if ((vif->ndev->features & NETIF_F_RXCSUM) &&
+		(ar->rx_meta_ver != WMI_META_VERSION_2)) {
+		ar->rx_meta_ver = WMI_META_VERSION_2;
+		if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
+			if_idx, ar->rx_meta_ver, 0, 0)) {
+			ath6kl_err("unable to set the rx frame format\n");
+			status = -EIO;
+		}
+	} else if (!(vif->ndev->features & NETIF_F_RXCSUM) &&
+		(ar->rx_meta_ver == WMI_META_VERSION_2)) {
+		ar->rx_meta_ver = 0;
+		if (ath6kl_wmi_set_rx_frame_format_cmd(ar->wmi,
+			if_idx, ar->rx_meta_ver, 0, 0)) {
+			ath6kl_err("unable to set the rx frame format\n");
+			status = -EIO;
+		}
+
+	}
+
+
 	if (dot11_hdr)
 		status = ath6kl_wmi_dot11_hdr_remove(ar->wmi, skb);
 	else if (!is_amsdu)
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 4e4f0f7..c2b83c7 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -257,6 +257,9 @@ static inline u8 wmi_data_hdr_get_if_idx(struct wmi_data_hdr *dhdr)
 #define WMI_META_VERSION_1	0x01
 #define WMI_META_VERSION_2	0x02
 
+/* Flag to signal to FW to calculate TCP checksum */
+#define CSUM_OFFLOAD_FLAG 0x01
+
 struct wmi_tx_meta_v1 {
 	/* packet ID to identify the tx request */
 	u8 pkt_id;
-- 
1.7.0.4

