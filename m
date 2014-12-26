Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:40635 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751614AbaLZLD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2014 06:03:56 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBQAxt8X031889
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:03:55 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1rfjy5x15v-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Fri, 26 Dec 2014 03:03:55 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Subject: [PATCH v3 4/4] mwifiex: get supported BA stream info from FW
Date: Fri, 26 Dec 2014 03:02:34 -0800
Message-ID: <1419591754-4086-4-git-send-email-patila@marvell.com> (sfid-20141226_120400_126485_2DA4CB4E)
In-Reply-To: <1419591754-4086-1-git-send-email-patila@marvell.com>
References: <1419591754-4086-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds support to get number of BA streams
supported information from FW. Some newer chips(e.g. 8897 series)
support 4 BA streams for TX; so driver should not disallow BA stream
setup just after 2 streams have been established.

Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.h | 14 +++++++++++---
 drivers/net/wireless/mwifiex/fw.h  |  1 +
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index f275675..8e2e394 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -130,7 +130,9 @@ static inline u8 mwifiex_space_avail_for_new_ba_stream(
 {
 	struct mwifiex_private *priv;
 	u8 i;
-	u32 ba_stream_num = 0;
+	u32 ba_stream_num = 0, ba_stream_max;
+
+	ba_stream_max = MWIFIEX_MAX_TX_BASTREAM_SUPPORTED;
 
 	for (i = 0; i < adapter->priv_num; i++) {
 		priv = adapter->priv[i];
@@ -139,8 +141,14 @@ static inline u8 mwifiex_space_avail_for_new_ba_stream(
 				&priv->tx_ba_stream_tbl_ptr);
 	}
 
-	return ((ba_stream_num <
-		 MWIFIEX_MAX_TX_BASTREAM_SUPPORTED) ? true : false);
+	if (adapter->fw_api_ver == MWIFIEX_FW_V15) {
+		ba_stream_max =
+			       GETSUPP_TXBASTREAMS(adapter->hw_dot_11n_dev_cap);
+		if (!ba_stream_max)
+			ba_stream_max = MWIFIEX_MAX_TX_BASTREAM_SUPPORTED;
+	}
+
+	return ((ba_stream_num < ba_stream_max) ? true : false);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index fb5936e..9a82323 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -233,6 +233,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
 #define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
 #define ISALLOWED_CHANWIDTH40(ht_param) (ht_param & BIT(2))
+#define GETSUPP_TXBASTREAMS(Dot11nDevCap) ((Dot11nDevCap >> 18) & 0xF)
 
 /* httxcfg bitmap
  * 0		reserved
-- 
1.8.1.4

