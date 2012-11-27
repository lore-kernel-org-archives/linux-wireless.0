Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:37048 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752545Ab2K0UMY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 15:12:24 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: advertise GreenField, 40MHz intolerance support to cfg80211
Date: Tue, 27 Nov 2012 12:09:20 -0800
Message-Id: <1354046960-4513-1-git-send-email-bzhao@marvell.com> (sfid-20121127_211242_373743_D07331FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for advertising GreenField, 40MHz intolerance
or LDPC coding support to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: fix the typo (Gabor Stefanik)

 drivers/net/wireless/mwifiex/cfg80211.c |   15 +++++++++++++++
 drivers/net/wireless/mwifiex/fw.h       |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3b1c277..a875499 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1948,6 +1948,21 @@ mwifiex_setup_ht_caps(struct ieee80211_sta_ht_cap *ht_info,
 	else
 		ht_info->cap &= ~IEEE80211_HT_CAP_TX_STBC;
 
+	if (ISSUPP_GREENFIELD(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_GRN_FLD;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_GRN_FLD;
+
+	if (ISENABLED_40MHZ_INTOLERANT(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_40MHZ_INTOLERANT;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_40MHZ_INTOLERANT;
+
+	if (ISSUPP_RXLDPC(adapter->hw_dot_11n_dev_cap))
+		ht_info->cap |= IEEE80211_HT_CAP_LDPC_CODING;
+	else
+		ht_info->cap &= ~IEEE80211_HT_CAP_LDPC_CODING;
+
 	ht_info->cap &= ~IEEE80211_HT_CAP_MAX_AMSDU;
 	ht_info->cap |= IEEE80211_HT_CAP_SM_PS;
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index dda588b..4dc8e2e 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -194,6 +194,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
 #define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
+#define ISENABLED_40MHZ_INTOLERANT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
+#define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
 
 /* httxcfg bitmap
  * 0		reserved
-- 
1.7.0.2

