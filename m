Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49039 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700AbbGPPJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2015 11:09:40 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id t6GF9daw031161
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:09:39 -0700
Received: from sc-exch04.marvell.com ([199.233.58.184])
	by mx0a-0016f401.pphosted.com with ESMTP id 1vnb4adjxy-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2015 08:09:39 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Aniket Nagarnaik <aniketn@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH v2 1/3] mwifiex: add bss mode TLV to extended scan command
Date: Thu, 16 Jul 2015 08:05:21 -0700
Message-ID: <1437059123-19477-2-git-send-email-akarwar@marvell.com> (sfid-20150716_170943_497831_7F7B690A)
In-Reply-To: <1437059123-19477-1-git-send-email-akarwar@marvell.com>
References: <1437059123-19477-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aniket Nagarnaik <aniketn@marvell.com>

We are setting BSS mode as ANY so that firmware will provide
all types of scan entries.

Signed-off-by: Aniket Nagarnaik <aniketn@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h   |  6 ++++++
 drivers/net/wireless/mwifiex/scan.c | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index cd09051..59662bb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -177,6 +177,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define TLV_TYPE_CHANNEL_STATS      (PROPRIETARY_TLV_BASE_ID + 198)
 #define TLV_BTCOEX_WL_AGGR_WINSIZE  (PROPRIETARY_TLV_BASE_ID + 202)
 #define TLV_BTCOEX_WL_SCANTIME      (PROPRIETARY_TLV_BASE_ID + 203)
+#define TLV_TYPE_BSS_MODE           (PROPRIETARY_TLV_BASE_ID + 206)
 
 #define MWIFIEX_TX_DATA_BUF_SIZE_2K        2048
 
@@ -1370,6 +1371,11 @@ struct host_cmd_ds_802_11_scan_ext {
 	u8    tlv_buffer[1];
 } __packed;
 
+struct mwifiex_ie_types_bss_mode {
+	struct mwifiex_ie_types_header  header;
+	u8 bss_mode;
+} __packed;
+
 struct mwifiex_ie_types_bss_scan_rsp {
 	struct mwifiex_ie_types_header header;
 	u8 bssid[ETH_ALEN];
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index baf9715..ef2bef8 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -823,6 +823,7 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	int i;
 	u8 ssid_filter;
 	struct mwifiex_ie_types_htcap *ht_cap;
+	struct mwifiex_ie_types_bss_mode *bss_mode;
 
 	/* The tlv_buf_len is calculated for each scan command.  The TLVs added
 	   in this routine will be preserved since the routine that sends the
@@ -968,6 +969,15 @@ mwifiex_config_scan(struct mwifiex_private *priv,
 	else
 		*max_chan_per_scan = MWIFIEX_DEF_CHANNELS_PER_SCAN_CMD;
 
+	if (adapter->ext_scan) {
+		bss_mode = (struct mwifiex_ie_types_bss_mode *)tlv_pos;
+		bss_mode->header.type = cpu_to_le16(TLV_TYPE_BSS_MODE);
+		bss_mode->header.len = cpu_to_le16(sizeof(bss_mode->bss_mode));
+		bss_mode->bss_mode = scan_cfg_out->bss_mode;
+		tlv_pos += sizeof(bss_mode->header) +
+			   le16_to_cpu(bss_mode->header.len);
+	}
+
 	/* If the input config or adapter has the number of Probes set,
 	   add tlv */
 	if (num_probes) {
-- 
1.8.1.4

