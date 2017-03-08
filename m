Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52051 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753711AbdCHOeb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 09:34:31 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v28Dnm6H013973
        for <linux-wireless@vger.kernel.org>; Wed, 8 Mar 2017 05:57:03 -0800
Received: from sc-exch04.marvell.com ([199.233.58.184])
        by mx0b-0016f401.pphosted.com with ESMTP id 2913vkx8bq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Wed, 08 Mar 2017 05:57:03 -0800
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Karthik D A <karthida@marvell.com>
Subject: [PATCH 1/3] mwifiex: add qualifier to firmware structures
Date: Wed, 8 Mar 2017 19:17:07 +0530
Message-ID: <1488980829-6075-2-git-send-email-gbhat@marvell.com> (sfid-20170308_153509_355653_927548B8)
In-Reply-To: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
References: <1488980829-6075-1-git-send-email-gbhat@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karthik D A <karthida@marvell.com>

Adding qualifier "__packed" indicates that no padding should be
performed on the qualified object for alignment.
This patch adds qualifier __packed to the required firmware
structures in mwifiex driver.

Signed-off-by: Karthik D A <karthida@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/fw.h  | 36 +++++++++++++++---------------
 drivers/net/wireless/marvell/mwifiex/usb.h |  4 ++--
 2 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index cb6a1a8..0b68374 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -31,17 +31,17 @@ struct rfc_1042_hdr {
 	u8 llc_ctrl;
 	u8 snap_oui[3];
 	__be16 snap_type;
-};
+} __packed;
 
 struct rx_packet_hdr {
 	struct ethhdr eth803_hdr;
 	struct rfc_1042_hdr rfc1042_hdr;
-};
+} __packed;
 
 struct tx_packet_hdr {
 	struct ethhdr eth803_hdr;
 	struct rfc_1042_hdr rfc1042_hdr;
-};
+} __packed;
 
 #define B_SUPPORTED_RATES               5
 #define G_SUPPORTED_RATES               9
@@ -707,7 +707,7 @@ struct uap_txpd {
 	u8 reserved1[2];
 	u8 tx_token_id;
 	u8 reserved[2];
-};
+} __packed;
 
 struct uap_rxpd {
 	u8 bss_type;
@@ -723,7 +723,7 @@ struct uap_rxpd {
 	u8 ht_info;
 	u8 reserved[3];
 	u8 flags;
-};
+} __packed;
 
 struct mwifiex_fw_chan_stats {
 	u8 chan_num;
@@ -987,7 +987,7 @@ struct mwifiex_ps_param {
 	__le16 adhoc_wake_period;
 	__le16 mode;
 	__le16 delay_to_ps;
-};
+} __packed;
 
 #define HS_DEF_WAKE_INTERVAL          100
 #define HS_DEF_INACTIVITY_TIMEOUT      50
@@ -996,7 +996,7 @@ struct mwifiex_ps_param_in_hs {
 	struct mwifiex_ie_types_header header;
 	__le32 hs_wake_int;
 	__le32 hs_inact_timeout;
-};
+} __packed;
 
 #define BITMAP_AUTO_DS         0x01
 #define BITMAP_STA_PS          0x10
@@ -1062,7 +1062,7 @@ struct host_cmd_ds_802_11_rssi_info {
 	__le16 nbcn;
 	__le16 reserved[9];
 	long long reserved_1;
-};
+} __packed;
 
 struct host_cmd_ds_802_11_rssi_info_rsp {
 	__le16 action;
@@ -1077,12 +1077,12 @@ struct host_cmd_ds_802_11_rssi_info_rsp {
 	__le16 bcn_rssi_avg;
 	__le16 bcn_nf_avg;
 	long long tsf_bcn;
-};
+} __packed;
 
 struct host_cmd_ds_802_11_mac_address {
 	__le16 action;
 	u8 mac_addr[ETH_ALEN];
-};
+} __packed;
 
 struct host_cmd_ds_mac_control {
 	__le32 action;
@@ -1230,7 +1230,7 @@ struct host_cmd_ds_802_11_get_log {
 	__le32 wep_icv_err_cnt[4];
 	__le32 bcn_rcv_cnt;
 	__le32 bcn_miss_cnt;
-};
+} __packed;
 
 /* Enumeration for rate format */
 enum _mwifiex_rate_format {
@@ -1368,12 +1368,12 @@ struct host_cmd_ds_rf_ant_mimo {
 	__le16 tx_ant_mode;
 	__le16 action_rx;
 	__le16 rx_ant_mode;
-};
+} __packed;
 
 struct host_cmd_ds_rf_ant_siso {
 	__le16 action;
 	__le16 ant_mode;
-};
+} __packed;
 
 struct host_cmd_ds_tdls_oper {
 	__le16 tdls_action;
@@ -1383,13 +1383,13 @@ struct host_cmd_ds_tdls_oper {
 
 struct mwifiex_tdls_config {
 	__le16 enable;
-};
+} __packed;
 
 struct mwifiex_tdls_config_cs_params {
 	u8 unit_time;
 	u8 thr_otherlink;
 	u8 thr_directlink;
-};
+} __packed;
 
 struct mwifiex_tdls_init_cs_params {
 	u8 peer_mac[ETH_ALEN];
@@ -1404,7 +1404,7 @@ struct mwifiex_tdls_init_cs_params {
 
 struct mwifiex_tdls_stop_cs_params {
 	u8 peer_mac[ETH_ALEN];
-};
+} __packed;
 
 struct host_cmd_ds_tdls_config {
 	__le16 tdls_action;
@@ -1709,7 +1709,7 @@ struct mwifiex_ie_types_local_pwr_constraint {
 struct mwifiex_ie_types_wmm_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 wmm_ie[1];
-};
+} __packed;
 
 struct mwifiex_ie_types_mgmt_frame {
 	struct mwifiex_ie_types_header header;
@@ -1834,7 +1834,7 @@ struct host_cmd_ds_mem_access {
 	__le16 reserved;
 	__le32 addr;
 	__le32 value;
-};
+} __packed;
 
 struct mwifiex_ie_types_qos_info {
 	struct mwifiex_ie_types_header header;
diff --git a/drivers/net/wireless/marvell/mwifiex/usb.h b/drivers/net/wireless/marvell/mwifiex/usb.h
index e5f204e..16017ae 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.h
+++ b/drivers/net/wireless/marvell/mwifiex/usb.h
@@ -102,12 +102,12 @@ struct fw_header {
 struct fw_sync_header {
 	__le32 cmd;
 	__le32 seq_num;
-};
+} __packed;
 
 struct fw_data {
 	struct fw_header fw_hdr;
 	__le32 seq_num;
 	u8 data[1];
-};
+} __packed;
 
 #endif /*_MWIFIEX_USB_H */
-- 
1.9.1
