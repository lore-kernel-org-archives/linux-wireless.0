Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33011 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751278AbdGQPKE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 11:10:04 -0400
Received: by mail-oi0-f68.google.com with SMTP id k186so2558377oib.0
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jul 2017 08:10:04 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH v2 02/11] rtlwifi: Fix MAX MPDU of VHT capability
Date: Mon, 17 Jul 2017 10:09:45 -0500
Message-Id: <20170717150954.1441-3-Larry.Finger@lwfinger.net> (sfid-20170717_171012_101395_A0300F8E)
In-Reply-To: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
References: <20170717150954.1441-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

We must choose only one of VHT_CAP among
IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895,
IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 and
IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
v2 - no changes
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index 883e29e96edc..0f36594da76c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -249,8 +249,6 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 
 		vht_cap->vht_supported = true;
 		vht_cap->cap =
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
 			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 			IEEE80211_VHT_CAP_SHORT_GI_80 |
 			IEEE80211_VHT_CAP_TXSTBC |
@@ -283,8 +281,6 @@ static void _rtl_init_hw_vht_capab(struct ieee80211_hw *hw,
 
 		vht_cap->vht_supported = true;
 		vht_cap->cap =
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895 |
-			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991 |
 			IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454 |
 			IEEE80211_VHT_CAP_SHORT_GI_80 |
 			IEEE80211_VHT_CAP_TXSTBC |
-- 
2.12.3
