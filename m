Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18189 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab1LRCFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 21:05:40 -0500
From: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Rishi Panjwani <rpanjwan@qca.qualcomm.com>
Subject: [PATCH] ath6kl: Support for TCP checksum offload to firmware
Date: Sat, 17 Dec 2011 18:00:31 -0800
Message-ID: <1324173631-14594-2-git-send-email-rpanjwan@qca.qualcomm.com> (sfid-20111218_030544_201463_39C1A1D2)
In-Reply-To: <1324173631-14594-1-git-send-email-rpanjwan@qca.qualcomm.com>
References: <1324173631-14594-1-git-send-email-rpanjwan@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The change enables offloading TCP checksum calculation to firmware.
This has been achieved by adding a module param called csum_offload.
The support has been added for QA team's testing purposes and currently
there is no plan to offload the feature to firmware by default.
To enable TCP checksum offload, at the time of loading the ath6kl
driver, add 'csum_offload=1' to the load instruction as follows:
insmod ath6kl_sdio.ko csum_offload=1

Signed-off-by: Rishi Panjwani <rpanjwan@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/core.h |    2 +
 drivers/net/wireless/ath/ath6kl/init.c |    7 ++++++
 drivers/net/wireless/ath/ath6kl/txrx.c |   38 +++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.h  |    3 ++
 4 files changed, 45 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 96f65c9..69b6b22 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -180,6 +180,8 @@ struct ath6kl_fw_ie {
 #define ATH6KL_CONF_ENABLE_TX_BURST		BIT(3)
 #define ATH6KL_CONF_SUSPEND_CUTPOWER		BIT(4)
 
+extern bool csum_offload;
+
 enum wlan_low_pwr_state {
 	WLAN_POWER_STATE_ON,
 	WLAN_POWER_STATE_CUT_PWR,
diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
index c97f83c..721b602 100644
--- a/drivers/net/wireless/ath/ath6kl/init.c
+++ b/drivers/net/wireless/ath/ath6kl/init.c
@@ -28,10 +28,12 @@
 unsigned int debug_mask;
 static unsigned int testmode;
 static bool suspend_cutpower;
+bool csum_offload;
 
 module_param(debug_mask, uint, 0644);
 module_param(testmode, uint, 0644);
 module_param(suspend_cutpower, bool, 0444);
+module_param(csum_offload, bool, 0444);
 
 static const struct ath6kl_hw hw_list[] = {
 	{
@@ -1649,6 +1651,11 @@ int ath6kl_core_init(struct ath6kl *ar)
 
 	set_bit(FIRST_BOOT, &ar->flag);
 
+	if (csum_offload) {
+		ndev->features |= NETIF_F_IP_CSUM;
+		ar->rx_meta_ver = WMI_META_VERSION_2;
+	}
+
 	ret = ath6kl_init_hw_start(ar);
 	if (ret) {
 		ath6kl_err("Failed to start hardware: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index 506a303..e0d3907 100644
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
@@ -265,6 +267,13 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (test_bit(WMI_ENABLED, &ar->flag)) {
+		if (csum_offload && csum == CHECKSUM_PARTIAL) {
+			csum_start = skb->csum_start -
+					(skb->network_header - skb->head) +
+					sizeof(struct ath6kl_llc_snap_hdr);
+			csum_dest = skb->csum_offset + csum_start;
+		}
+
 		if (skb_headroom(skb) < dev->needed_headroom) {
 			struct sk_buff *tmp_skb = skb;
 
@@ -281,11 +290,30 @@ int ath6kl_data_tx(struct sk_buff *skb, struct net_device *dev)
 			goto fail_tx;
 		}
 
-		if (ath6kl_wmi_data_hdr_add(ar->wmi, skb, DATA_MSGTYPE,
-					    more_data, 0, 0, NULL,
-					    vif->fw_vif_idx)) {
-			ath6kl_err("wmi_data_hdr_add failed\n");
-			goto fail_tx;
+		if (csum_offload && (csum == CHECKSUM_PARTIAL)) {
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

