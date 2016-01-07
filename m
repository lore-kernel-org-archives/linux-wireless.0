Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:22615 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752458AbcAGJee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 04:34:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u079YYfL018919
	for <linux-wireless@vger.kernel.org>; Thu, 7 Jan 2016 01:34:34 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0b-0016f401.pphosted.com with ESMTP id 208ynrkk5w-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 01:34:34 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Ganapathi Bhat <gbhat@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/6] mwifiex: add RSSI support for net-detect
Date: Thu, 7 Jan 2016 01:31:30 -0800
Message-ID: <1452159091-30997-6-git-send-email-akarwar@marvell.com> (sfid-20160107_103443_992025_CDB1665B)
In-Reply-To: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
References: <1452159091-30997-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ganapathi Bhat <gbhat@marvell.com>

This patch adds support for waking up the device on
finding better RSSI. Threshold RSSI value will be
configured by application.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c |  4 ++++
 drivers/net/wireless/marvell/mwifiex/fw.h       |  5 +++++
 drivers/net/wireless/marvell/mwifiex/scan.c     | 15 +++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index c80d9e2..8461553 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2582,6 +2582,10 @@ mwifiex_cfg80211_sched_scan_start(struct wiphy *wiphy,
 	bgscan_cfg->bss_type = MWIFIEX_BSS_MODE_INFRA;
 	bgscan_cfg->action = MWIFIEX_BGSCAN_ACT_SET;
 	bgscan_cfg->enable = true;
+	if (request->min_rssi_thold != NL80211_SCAN_RSSI_THOLD_OFF) {
+		bgscan_cfg->report_condition |= MWIFIEX_BGSCAN_SSID_RSSI_MATCH;
+		bgscan_cfg->rssi_threshold = request->min_rssi_thold;
+	}
 
 	if (mwifiex_send_cmd(priv, HostCmd_CMD_802_11_BG_SCAN_CONFIG,
 			     HostCmd_ACT_GEN_SET, 0, bgscan_cfg, true)) {
diff --git a/drivers/net/wireless/marvell/mwifiex/fw.h b/drivers/net/wireless/marvell/mwifiex/fw.h
index d293e48..4af9168 100644
--- a/drivers/net/wireless/marvell/mwifiex/fw.h
+++ b/drivers/net/wireless/marvell/mwifiex/fw.h
@@ -759,6 +759,11 @@ struct mwifiex_ie_types_repeat_count {
 	__le16 repeat_count;
 } __packed;
 
+struct mwifiex_ie_types_min_rssi_threshold {
+	struct mwifiex_ie_types_header header;
+	__le16 rssi_threshold;
+} __packed;
+
 struct mwifiex_ie_types_bgscan_start_later {
 	struct mwifiex_ie_types_header header;
 	__le16 start_later;
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 0a85b05..6fdb40f 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -2258,6 +2258,7 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 	int i;
 	struct mwifiex_ie_types_num_probes *num_probes_tlv;
 	struct mwifiex_ie_types_repeat_count *repeat_count_tlv;
+	struct mwifiex_ie_types_min_rssi_threshold *rssi_threshold_tlv;
 	struct mwifiex_ie_types_bgscan_start_later *start_later_tlv;
 	struct mwifiex_ie_types_wildcard_ssid_params *wildcard_ssid_tlv;
 	struct mwifiex_ie_types_chan_list_param_set *chan_list_tlv;
@@ -2308,6 +2309,20 @@ int mwifiex_cmd_802_11_bg_scan_config(struct mwifiex_private *priv,
 			le16_to_cpu(repeat_count_tlv->header.len);
 	}
 
+	if (bgscan_cfg_in->rssi_threshold) {
+		rssi_threshold_tlv =
+			(struct mwifiex_ie_types_min_rssi_threshold *)tlv_pos;
+		rssi_threshold_tlv->header.type =
+			cpu_to_le16(TLV_TYPE_RSSI_LOW);
+		rssi_threshold_tlv->header.len =
+			cpu_to_le16(sizeof(rssi_threshold_tlv->rssi_threshold));
+		rssi_threshold_tlv->rssi_threshold =
+			cpu_to_le16(bgscan_cfg_in->rssi_threshold);
+
+		tlv_pos += sizeof(rssi_threshold_tlv->header) +
+			le16_to_cpu(rssi_threshold_tlv->header.len);
+	}
+
 	for (i = 0; i < bgscan_cfg_in->num_ssids; i++) {
 		ssid_len = bgscan_cfg_in->ssid_list[i].ssid.ssid_len;
 
-- 
1.8.1.4

