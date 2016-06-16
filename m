Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:56437 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754384AbcFPN3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2016 09:29:55 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u5GDRACW022469
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:29:54 -0700
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 23gj5fs0f1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jun 2016 06:29:54 -0700
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Cathy Luo <cluo@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 5/6] mwifiex: fix AP unable to start in VHT40 problem
Date: Thu, 16 Jun 2016 18:52:25 +0530
Message-ID: <1466083346-18607-5-git-send-email-akarwar@marvell.com> (sfid-20160616_153001_747905_A68A40F4)
In-Reply-To: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
References: <1466083346-18607-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch populates secondary channel offset and downloads it to
firmware to fix the problem.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/ioctl.h   |  2 ++
 drivers/net/wireless/marvell/mwifiex/uap_cmd.c | 30 ++++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index a5a48c1..f5b8fd1 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -83,6 +83,8 @@ struct wep_key {
 #define MWIFIEX_AUTH_MODE_AUTO  0xFF
 #define BAND_CONFIG_BG          0x00
 #define BAND_CONFIG_A           0x01
+#define MWIFIEX_SEC_CHAN_BELOW	0x30
+#define MWIFIEX_SEC_CHAN_ABOVE	0x10
 #define MWIFIEX_SUPPORTED_RATES                 14
 #define MWIFIEX_SUPPORTED_RATES_EXT             32
 #define MWIFIEX_TDLS_SUPPORTED_RATES		8
diff --git a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
index f79d00d..a7e9f54 100644
--- a/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
+++ b/drivers/net/wireless/marvell/mwifiex/uap_cmd.c
@@ -19,6 +19,7 @@
 
 #include "main.h"
 #include "11ac.h"
+#include "11n.h"
 
 /* This function parses security related parameters from cfg80211_ap_settings
  * and sets into FW understandable bss_config structure.
@@ -521,9 +522,9 @@ mwifiex_uap_bss_param_prepare(u8 *tlv, void *cmd_buf, u16 *param_size)
 		tlv += sizeof(struct host_cmd_tlv_rates) + i;
 	}
 	if (bss_cfg->channel &&
-	    ((bss_cfg->band_cfg == BAND_CONFIG_BG &&
+	    (((bss_cfg->band_cfg & BIT(0)) == BAND_CONFIG_BG &&
 	      bss_cfg->channel <= MAX_CHANNEL_BAND_BG) ||
-	    (bss_cfg->band_cfg == BAND_CONFIG_A &&
+	    ((bss_cfg->band_cfg & BIT(0)) == BAND_CONFIG_A &&
 	     bss_cfg->channel <= MAX_CHANNEL_BAND_A))) {
 		chan_band = (struct host_cmd_tlv_channel_band *)tlv;
 		chan_band->header.type = cpu_to_le16(TLV_TYPE_CHANNELBANDLIST);
@@ -833,6 +834,31 @@ void mwifiex_uap_set_channel(struct mwifiex_private *priv,
 			config_bands |= BAND_AAC;
 	}
 
+	switch (chandef.width) {
+	case NL80211_CHAN_WIDTH_5:
+	case NL80211_CHAN_WIDTH_10:
+	case NL80211_CHAN_WIDTH_20_NOHT:
+	case NL80211_CHAN_WIDTH_20:
+		break;
+	case NL80211_CHAN_WIDTH_40:
+		if (chandef.center_freq1 < chandef.chan->center_freq)
+			bss_cfg->band_cfg |= MWIFIEX_SEC_CHAN_BELOW;
+		else
+			bss_cfg->band_cfg |= MWIFIEX_SEC_CHAN_ABOVE;
+		break;
+	case NL80211_CHAN_WIDTH_80:
+	case NL80211_CHAN_WIDTH_80P80:
+	case NL80211_CHAN_WIDTH_160:
+		bss_cfg->band_cfg |=
+		    mwifiex_get_sec_chan_offset(bss_cfg->channel) << 4;
+		break;
+	default:
+		mwifiex_dbg(priv->adapter,
+			    WARN, "Unknown channel width: %d\n",
+			    chandef.width);
+		break;
+	}
+
 	priv->adapter->config_bands = config_bands;
 
 	if (old_bands != config_bands) {
-- 
1.9.1

