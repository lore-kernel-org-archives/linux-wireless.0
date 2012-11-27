Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:49965 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933086Ab2K0D2l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2012 22:28:41 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: advertise GreenField, 40MHz intolerance support to cfg80211
Date: Mon, 26 Nov 2012 19:28:33 -0800
Message-Id: <1353986913-3087-1-git-send-email-bzhao@marvell.com> (sfid-20121127_042847_980353_7E7E5C3D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for advertising GreenField, 40MHz intolerance
or LDPC coding support to cfg80211.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |   15 +++++++++++++++
 drivers/net/wireless/mwifiex/fw.h       |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 3b1c277..13333e4 100644
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
+	if (ISENABLED_40MHZ_INTOLARENT(adapter->hw_dot_11n_dev_cap))
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
index dda588b..b125b7a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -194,6 +194,8 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define ISSUPP_TXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(25))
 #define ISSUPP_RXSTBC(Dot11nDevCap) (Dot11nDevCap & BIT(26))
 #define ISSUPP_GREENFIELD(Dot11nDevCap) (Dot11nDevCap & BIT(29))
+#define ISENABLED_40MHZ_INTOLARENT(Dot11nDevCap) (Dot11nDevCap & BIT(8))
+#define ISSUPP_RXLDPC(Dot11nDevCap) (Dot11nDevCap & BIT(22))
 
 /* httxcfg bitmap
  * 0		reserved
-- 
1.7.0.2

