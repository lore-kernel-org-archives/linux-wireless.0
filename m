Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [67.231.148.174] ([67.231.148.174]:27823 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752666AbaCHDmP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 22:42:15 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/6] mwifiex: add VHT MCS rate configuration support
Date: Fri, 7 Mar 2014 19:41:27 -0800
Message-ID: <1394250091-18477-2-git-send-email-bzhao@marvell.com> (sfid-20140308_044224_990767_9A0E92FA)
In-Reply-To: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
References: <1394250091-18477-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

During Tx rate configuration, newer firmware V15 expects bitmap
for VHT MCS rates as well.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/fw.h          |  1 +
 drivers/net/wireless/mwifiex/main.h        |  2 +-
 drivers/net/wireless/mwifiex/sta_cmd.c     | 14 ++++++++++++++
 drivers/net/wireless/mwifiex/sta_cmdresp.c |  9 +++++++++
 4 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 5b30834..341e419 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1105,6 +1105,7 @@ struct mwifiex_rate_scope {
 	__le16 hr_dsss_rate_bitmap;
 	__le16 ofdm_rate_bitmap;
 	__le16 ht_mcs_rate_bitmap[8];
+	__le16 vht_mcs_rate_bitmap[8];
 } __packed;
 
 struct mwifiex_rate_drop_pattern {
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 5f9bfb0..713dd24 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -116,7 +116,7 @@ enum {
 #define MWIFIEX_TYPE_DATA				0
 #define MWIFIEX_TYPE_EVENT				3
 
-#define MAX_BITMAP_RATES_SIZE			10
+#define MAX_BITMAP_RATES_SIZE			18
 
 #define MAX_CHANNEL_BAND_BG     14
 #define MAX_CHANNEL_BAND_A      165
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 4315a3b..e3cac14 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -185,6 +185,13 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 		     i++)
 			rate_scope->ht_mcs_rate_bitmap[i] =
 				cpu_to_le16(pbitmap_rates[2 + i]);
+		if (priv->adapter->fw_api_ver == MWIFIEX_FW_V15) {
+			for (i = 0;
+			     i < ARRAY_SIZE(rate_scope->vht_mcs_rate_bitmap);
+			     i++)
+				rate_scope->vht_mcs_rate_bitmap[i] =
+					cpu_to_le16(pbitmap_rates[10 + i]);
+		}
 	} else {
 		rate_scope->hr_dsss_rate_bitmap =
 			cpu_to_le16(priv->bitmap_rates[0]);
@@ -195,6 +202,13 @@ static int mwifiex_cmd_tx_rate_cfg(struct mwifiex_private *priv,
 		     i++)
 			rate_scope->ht_mcs_rate_bitmap[i] =
 				cpu_to_le16(priv->bitmap_rates[2 + i]);
+		if (priv->adapter->fw_api_ver == MWIFIEX_FW_V15) {
+			for (i = 0;
+			     i < ARRAY_SIZE(rate_scope->vht_mcs_rate_bitmap);
+			     i++)
+				rate_scope->vht_mcs_rate_bitmap[i] =
+					cpu_to_le16(priv->bitmap_rates[10 + i]);
+		}
 	}
 
 	rate_drop = (struct mwifiex_rate_drop_pattern *) ((u8 *) rate_scope +
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index a8f7d54..bfebb01 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -304,6 +304,15 @@ static int mwifiex_ret_tx_rate_cfg(struct mwifiex_private *priv,
 				priv->bitmap_rates[2 + i] =
 					le16_to_cpu(rate_scope->
 						    ht_mcs_rate_bitmap[i]);
+
+			if (priv->adapter->fw_api_ver == MWIFIEX_FW_V15) {
+				for (i = 0; i < ARRAY_SIZE(rate_scope->
+							   vht_mcs_rate_bitmap);
+				     i++)
+					priv->bitmap_rates[10 + i] =
+					    le16_to_cpu(rate_scope->
+							vht_mcs_rate_bitmap[i]);
+			}
 			break;
 			/* Add RATE_DROP tlv here */
 		}
-- 
1.8.2.3

