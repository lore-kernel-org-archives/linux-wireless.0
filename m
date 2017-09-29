Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34666 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752405AbdI2TsI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Sep 2017 15:48:08 -0400
Received: by mail-oi0-f67.google.com with SMTP id l81so292678oib.1
        for <linux-wireless@vger.kernel.org>; Fri, 29 Sep 2017 12:48:08 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 01/10] rtlwifi: Fix MAX MPDU of VHT capability
Date: Fri, 29 Sep 2017 14:47:51 -0500
Message-Id: <20170929194800.15617-2-Larry.Finger@lwfinger.net> (sfid-20170929_214809_305353_814E7F2E)
In-Reply-To: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
References: <20170929194800.15617-1-Larry.Finger@lwfinger.net>
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
 drivers/net/wireless/realtek/rtlwifi/base.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index ea18aa7afecb..fcf6e31d0fb9 100644
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
2.13.5
