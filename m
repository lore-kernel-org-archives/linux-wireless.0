Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:21535 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbaBHA1o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 11/30] mwifiex: update beamforming capability field for HT
Date: Fri, 7 Feb 2014 16:27:26 -0800
Message-ID: <1391819254-21130-1-git-send-email-bzhao@marvell.com> (sfid-20140208_012748_572709_1AFBAEE1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch makes sure that beamforming capability field in
ht capability info gets filled if hardware supports the feature.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/11n.c | 4 ++++
 drivers/net/wireless/mwifiex/fw.h  | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 6261f8c..822e622 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -64,6 +64,10 @@ mwifiex_fill_cap_info(struct mwifiex_private *priv, u8 radio_type,
 
 	ht_cap->ht_cap.cap_info = cpu_to_le16(sband->ht_cap.cap);
 	ht_cap->ht_cap.extended_ht_cap_info = cpu_to_le16(ht_ext_cap);
+
+	if (ISSUPP_BEAMFORMING(priv->adapter->hw_dot_11n_dev_cap))
+		ht_cap->ht_cap.tx_BF_cap_info =
+				cpu_to_le32(MWIFIEX_DEF_11N_TX_BF_CAP);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ed41af1..cad9f86 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -186,6 +186,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
 				 IEEE80211_HT_CAP_SM_PS)
 
+#define MWIFIEX_DEF_11N_TX_BF_CAP	0x09E1E008
+
 #define MWIFIEX_DEF_AMPDU	IEEE80211_HT_AMPDU_PARM_FACTOR
 
 /* dev_cap bitmap
@@ -209,6 +211,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
 #define ISENABLED_40MHZ_INTOLERANT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
 #define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
+#define ISSUPP_BEAMFORMING(Dot11nDevCap) (Dot11nDevCap & BIT(30))
 
 /* httxcfg bitmap
  * 0		reserved
-- 
1.8.2.3

