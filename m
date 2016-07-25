Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:47174 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752914AbcGYPvn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2016 11:51:43 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u6PFoG1M031737
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:51:42 -0700
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 24c5xkfr0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2016 08:51:42 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Karthik D A <karthida@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 1/8] mwifiex: Fixed endianness problem for big endian platform
Date: Mon, 25 Jul 2016 21:21:04 +0530
Message-ID: <1469461871-3135-2-git-send-email-akarwar@marvell.com> (sfid-20160725_175145_935501_0BD6A03D)
In-Reply-To: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
References: <1469461871-3135-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

The driver sends and recives information to and from the firmware.
Correct endianness should be ensured as firmware follows little
endian format and host can be little/big endian.

Signed-off-by: Karthik D A <karthida@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h          | 30 +++++++++++-----------
 drivers/net/wireless/marvell/mwifiex/sta_cmd.c     | 27 ++++++++++---------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  2 +-
 3 files changed, 31 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index 5596b6b..c46267b 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -1646,7 +1646,7 @@ struct mwifiex_ie_types_sta_info {
 };
 
 struct host_cmd_ds_sta_list {
-	u16 sta_count;
+	__le16 sta_count;
 	u8 tlv[0];
 } __packed;
 
@@ -2034,26 +2034,26 @@ struct host_cmd_ds_set_bss_mode {
 
 struct host_cmd_ds_pcie_details {
 	/* TX buffer descriptor ring address */
-	u32 txbd_addr_lo;
-	u32 txbd_addr_hi;
+	__le32 txbd_addr_lo;
+	__le32 txbd_addr_hi;
 	/* TX buffer descriptor ring count */
-	u32 txbd_count;
+	__le32 txbd_count;
 
 	/* RX buffer descriptor ring address */
-	u32 rxbd_addr_lo;
-	u32 rxbd_addr_hi;
+	__le32 rxbd_addr_lo;
+	__le32 rxbd_addr_hi;
 	/* RX buffer descriptor ring count */
-	u32 rxbd_count;
+	__le32 rxbd_count;
 
 	/* Event buffer descriptor ring address */
-	u32 evtbd_addr_lo;
-	u32 evtbd_addr_hi;
+	__le32 evtbd_addr_lo;
+	__le32 evtbd_addr_hi;
 	/* Event buffer descriptor ring count */
-	u32 evtbd_count;
+	__le32 evtbd_count;
 
 	/* Sleep cookie buffer physical address */
-	u32 sleep_cookie_addr_lo;
-	u32 sleep_cookie_addr_hi;
+	__le32 sleep_cookie_addr_lo;
+	__le32 sleep_cookie_addr_hi;
 } __packed;
 
 struct mwifiex_ie_types_rssi_threshold {
@@ -2093,8 +2093,8 @@ struct mwifiex_ie_types_mc_group_info {
 	u8 chan_buf_weight;
 	u8 band_config;
 	u8 chan_num;
-	u32 chan_time;
-	u32 reserved;
+	__le32 chan_time;
+	__le32 reserved;
 	union {
 		u8 sdio_func_num;
 		u8 usb_ep_num;
@@ -2185,7 +2185,7 @@ struct host_cmd_ds_robust_coex {
 } __packed;
 
 struct host_cmd_ds_wakeup_reason {
-	u16  wakeup_reason;
+	__le16  wakeup_reason;
 } __packed;
 
 struct host_cmd_ds_gtk_rekey_params {
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
index 7897037..108c11c 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmd.c
@@ -1244,20 +1244,23 @@ mwifiex_cmd_pcie_host_spec(struct mwifiex_private *priv,
 		return 0;
 
 	/* Send the ring base addresses and count to firmware */
-	host_spec->txbd_addr_lo = (u32)(card->txbd_ring_pbase);
-	host_spec->txbd_addr_hi = (u32)(((u64)card->txbd_ring_pbase)>>32);
-	host_spec->txbd_count = MWIFIEX_MAX_TXRX_BD;
-	host_spec->rxbd_addr_lo = (u32)(card->rxbd_ring_pbase);
-	host_spec->rxbd_addr_hi = (u32)(((u64)card->rxbd_ring_pbase)>>32);
-	host_spec->rxbd_count = MWIFIEX_MAX_TXRX_BD;
-	host_spec->evtbd_addr_lo = (u32)(card->evtbd_ring_pbase);
-	host_spec->evtbd_addr_hi = (u32)(((u64)card->evtbd_ring_pbase)>>32);
-	host_spec->evtbd_count = MWIFIEX_MAX_EVT_BD;
+	host_spec->txbd_addr_lo = cpu_to_le32((u32)(card->txbd_ring_pbase));
+	host_spec->txbd_addr_hi =
+			cpu_to_le32((u32)(((u64)card->txbd_ring_pbase) >> 32));
+	host_spec->txbd_count = cpu_to_le32(MWIFIEX_MAX_TXRX_BD);
+	host_spec->rxbd_addr_lo = cpu_to_le32((u32)(card->rxbd_ring_pbase));
+	host_spec->rxbd_addr_hi =
+			cpu_to_le32((u32)(((u64)card->rxbd_ring_pbase) >> 32));
+	host_spec->rxbd_count = cpu_to_le32(MWIFIEX_MAX_TXRX_BD);
+	host_spec->evtbd_addr_lo = cpu_to_le32((u32)(card->evtbd_ring_pbase));
+	host_spec->evtbd_addr_hi =
+			cpu_to_le32((u32)(((u64)card->evtbd_ring_pbase) >> 32));
+	host_spec->evtbd_count = cpu_to_le32(MWIFIEX_MAX_EVT_BD);
 	if (card->sleep_cookie_vbase) {
 		host_spec->sleep_cookie_addr_lo =
-						(u32)(card->sleep_cookie_pbase);
-		host_spec->sleep_cookie_addr_hi =
-				 (u32)(((u64)(card->sleep_cookie_pbase)) >> 32);
+				cpu_to_le32((u32)(card->sleep_cookie_pbase));
+		host_spec->sleep_cookie_addr_hi = cpu_to_le32((u32)(((u64)
+					(card->sleep_cookie_pbase)) >> 32));
 		mwifiex_dbg(priv->adapter, INFO,
 			    "sleep_cook_lo phy addr: 0x%x\n",
 			    host_spec->sleep_cookie_addr_lo);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index ccf54932..90e191b 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -962,7 +962,7 @@ static int mwifiex_ret_uap_sta_list(struct mwifiex_private *priv,
 	int i;
 	struct mwifiex_sta_node *sta_node;
 
-	for (i = 0; i < sta_list->sta_count; i++) {
+	for (i = 0; i < (le16_to_cpu(sta_list->sta_count)); i++) {
 		sta_node = mwifiex_get_sta_entry(priv, sta_info->mac);
 		if (unlikely(!sta_node))
 			continue;
-- 
1.9.1

