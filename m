Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DA2C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:50:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31BD22087C
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 08:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 31BD22087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbeJHQBQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:01:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56007 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbeJHQBP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:01:15 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1g9RFE-00032H-UD; Mon, 08 Oct 2018 08:50:29 +0000
From:   Colin King <colin.king@canonical.com>
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8821ae: replace _rtl8821ae_mrate_idx_to_arfr_id with generic version
Date:   Mon,  8 Oct 2018 09:50:28 +0100
Message-Id: <20181008085028.23874-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Function _rtl8821ae_mrate_idx_to_arfr_id is functionally identical to
the generic version rtl_mrate_idx_to_arfr_id, so remove 
_rtl8821ae_mrate_idx_to_arfr_id and use the generic one instead.

This also fixes a missing break statement found by CoverityScan in
_rtl8821ae_mrate_idx_to_arfr_id, namely: CID#1167237 ("Missing break
in switch")

Thanks to Joe Perches for spotting this when I submitted an earlier patch.

Fixes: 3c05bedb5fef ("Staging: rtl8812ae: Add Realtek 8821 PCI WIFI driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 .../wireless/realtek/rtlwifi/rtl8821ae/hw.c   | 71 +------------------
 1 file changed, 1 insertion(+), 70 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 317c1b3101da..ba258318ee9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -3404,75 +3404,6 @@ static void rtl8821ae_update_hal_rate_table(struct ieee80211_hw *hw,
 		 "%x\n", rtl_read_dword(rtlpriv, REG_ARFR0));
 }
 
-static u8 _rtl8821ae_mrate_idx_to_arfr_id(
-	struct ieee80211_hw *hw, u8 rate_index,
-	enum wireless_mode wirelessmode)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_phy *rtlphy = &rtlpriv->phy;
-	u8 ret = 0;
-	switch (rate_index) {
-	case RATR_INX_WIRELESS_NGB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 1;
-		else
-			ret = 0;
-		; break;
-	case RATR_INX_WIRELESS_N:
-	case RATR_INX_WIRELESS_NG:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 5;
-		else
-			ret = 4;
-		; break;
-	case RATR_INX_WIRELESS_NB:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 3;
-		else
-			ret = 2;
-		; break;
-	case RATR_INX_WIRELESS_GB:
-		ret = 6;
-		break;
-	case RATR_INX_WIRELESS_G:
-		ret = 7;
-		break;
-	case RATR_INX_WIRELESS_B:
-		ret = 8;
-		break;
-	case RATR_INX_WIRELESS_MC:
-		if ((wirelessmode == WIRELESS_MODE_B)
-			|| (wirelessmode == WIRELESS_MODE_G)
-			|| (wirelessmode == WIRELESS_MODE_N_24G)
-			|| (wirelessmode == WIRELESS_MODE_AC_24G))
-			ret = 6;
-		else
-			ret = 7;
-	case RATR_INX_WIRELESS_AC_5N:
-		if (rtlphy->rf_type == RF_1T1R)
-			ret = 10;
-		else
-			ret = 9;
-		break;
-	case RATR_INX_WIRELESS_AC_24N:
-		if (rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_80) {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 10;
-			else
-				ret = 9;
-		} else {
-			if (rtlphy->rf_type == RF_1T1R)
-				ret = 11;
-			else
-				ret = 12;
-		}
-		break;
-	default:
-		ret = 0; break;
-	}
-	return ret;
-}
-
 static u32 _rtl8821ae_rate_to_bitmap_2ssvht(__le16 vht_rate)
 {
 	u8 i, j, tmp_rate;
@@ -3761,7 +3692,7 @@ static void rtl8821ae_update_hal_rate_mask(struct ieee80211_hw *hw,
 		break;
 	}
 
-	ratr_index = _rtl8821ae_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
+	ratr_index = rtl_mrate_idx_to_arfr_id(hw, ratr_index, wirelessmode);
 	sta_entry->ratr_index = ratr_index;
 	ratr_bitmap = _rtl8821ae_set_ra_vht_ratr_bitmap(hw, wirelessmode,
 							ratr_bitmap);
-- 
2.17.1

