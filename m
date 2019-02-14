Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2A28C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6688A21B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:36:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FlyZJsuz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503412AbfBNWgw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:36:52 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41360 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393758AbfBNWgv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:51 -0500
Received: by mail-ot1-f68.google.com with SMTP id u16so13364291otk.8
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvU37TH8W7fdUIWTwzuR8QQYeWVLFWQJFUVJ1jfMA9Q=;
        b=FlyZJsuzzOxjpes73DBOfuBjlfuZNL/TegbISpoUgc2g9rDaeoALnMY3PI6bmm0eVy
         8fFr9L70FqtgWKcjRmIP87RqE8CoaHrHcb5t9eHrGHUKmdbp+1vUj6JbAf2nTLuL2FIQ
         pTlFmlEel6HD8wwxvQUcnMMDYk3NcGnVXEybEvMmHkyL1+GbSA650sZxgiWz6fPSbLsB
         +Z9Nsuqa+7Vfy16sYisb9hj4Rg3ElIqMV4vslbola0mh+BCuotjLlPnMUbha8XwkCc+/
         vU91/jFwPwfFb2hgaVq72kSBcy4NdSBi68xWYcvfBFDKCFoby7kGLlda3twyKIq8MZqn
         x/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=zvU37TH8W7fdUIWTwzuR8QQYeWVLFWQJFUVJ1jfMA9Q=;
        b=qjMfPGT4pVAGOpOYVgtcERJ40ouhm0D75xeaTDyemFuM64QecwTjfb0zNTxzpqE7Gp
         2xgZvsnJV31F7iO9BXML8ftICGqJt1wh+m2ak1U0Jny2MpWhQHuK9Ey6fxA/vWbaehgU
         09TAvyKTCeGxho8qt1O6doTWA5OevlN8xlq5+wCdhkJRXHuknu2/GR5f4bnv4jFla72O
         LOz4OM/oyGwmfgvclUjJ6B2t/Qrg4hItYMQWw8S17W7mZRWvitEHuyKNmbQvE2fBytR4
         fWsFKgl7NrV2wYAP9XnB6eH8oTBdtRQgZ+SeX0j2v0dXyk8WWXXsQHn6TLS1PGqj8hWe
         PU/Q==
X-Gm-Message-State: AHQUAuaa6vcMjxyFXhvcvUkmhURRikx00LwbWF9Wl+q7GZvsOUn8LP8r
        BOTFGAZCn0NuQrYpTDSAXfY=
X-Google-Smtp-Source: AHgI3IaLgCdIkwGjZ3QBuXx4+ybfDZDD7hsrEGXlaz4aAuRqeNOFEkdW6Slod2med1kjR/TCB087og==
X-Received: by 2002:a9d:37b7:: with SMTP id x52mr4122072otb.214.1550183809309;
        Thu, 14 Feb 2019 14:36:49 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:48 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 1/8] rtlwifi: Remove CamelCase variables from base code
Date:   Thu, 14 Feb 2019 16:36:37 -0600
Message-Id: <20190214223644.8035-2-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

There are a number of CamelCase variables remaining in the source
files of modules rtl_pci, rtl_usb, and rtlwifi.

The following checkpatch excettions are also fixed:

for_kalle1/0001-rtlwifi-Remove-CamelCase-variables-from-base-code.patch
-----------------------------------------------------------------------
CHECK: Unnecessary parentheses around 'rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
                             rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]'
#68: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:377:
+                       if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
+                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]) ||
+                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
+                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
                                                                   1])) {

CHECK: Unnecessary parentheses around 'rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
                             rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
                                                                   1]'
#68: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:377:
+                       if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
+                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i]) ||
+                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
+                            rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
                                                                   1])) {

WARNING: line over 80 characters
#70: FILE: drivers/net/wireless/realtek/rtlwifi/efuse.c:379:
+                           (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=

CHECK: No space is necessary after a cast
#186: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c:396:
+       status->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);

CHECK: No space is necessary after a cast
#208: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c:335:
+       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);

CHECK: No space is necessary after a cast
#243: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:301:
+       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);

CHECK: No space is necessary after a cast
#252: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c:368:
+       stats.rx_is40mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);

CHECK: No space is necessary after a cast
#265: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c:475:
+       stats->rx_is40mhzpacket = (bool) GET_RX_DESC_BW(pdesc);

WARNING: Unnecessary space before function pointer arguments
#455: FILE: drivers/net/wireless/realtek/rtlwifi/wifi.h:1462:
+       void (*writen_sync) (struct rtl_priv *rtlpriv, u32 addr, void *buf,

WARNING: Unnecessary space before function pointer arguments
#483: FILE: drivers/net/wireless/realtek/rtlwifi/wifi.h:2257:
+       void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pdesc,

Note that not all checkpatch exceptions are addressed. Those will be
handled in later patches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h  |  2 +-
 drivers/net/wireless/realtek/rtlwifi/efuse.c  | 44 +++++++++----------
 drivers/net/wireless/realtek/rtlwifi/efuse.h  |  2 +-
 drivers/net/wireless/realtek/rtlwifi/regd.c   |  8 ++--
 .../wireless/realtek/rtlwifi/rtl8188ee/trx.c  |  4 +-
 .../wireless/realtek/rtlwifi/rtl8192ce/trx.c  |  4 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/hw.c   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192cu/trx.c  |  4 +-
 .../wireless/realtek/rtlwifi/rtl8192de/trx.c  |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192ee/trx.c  |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192se/trx.c  |  4 +-
 .../wireless/realtek/rtlwifi/rtl8723ae/trx.c  |  4 +-
 .../wireless/realtek/rtlwifi/rtl8723be/trx.c  |  4 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c    |  6 +--
 drivers/net/wireless/realtek/rtlwifi/usb.h    |  2 +-
 drivers/net/wireless/realtek/rtlwifi/wifi.h   | 26 +++++------
 16 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index a7c2b14decf3..ef142f708117 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -136,7 +136,7 @@ enum dbgp_flag_e {
 	FEEPROM = 11,
 	FPWR = 12,
 	FDM = 13,
-	FDBGCtrl = 14,
+	FDBGCTRL = 14,
 	FC2H = 15,
 	FBT = 16,
 	FINIT = 17,
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 5b18eb889634..cf58a18a108f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -365,20 +365,20 @@ bool efuse_shadow_update_chk(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
-	u8 section_idx, i, Base;
+	u8 section_idx, i, base;
 	u16 words_need = 0, hdr_num = 0, totalbytes, efuse_used;
 	bool wordchanged, result = true;
 
 	for (section_idx = 0; section_idx < 16; section_idx++) {
-		Base = section_idx * 8;
+		base = section_idx * 8;
 		wordchanged = false;
 
 		for (i = 0; i < 8; i = i + 2) {
-			if ((rtlefuse->efuse_map[EFUSE_INIT_MAP][Base + i] !=
-			     rtlefuse->efuse_map[EFUSE_MODIFY_MAP][Base + i]) ||
-			    (rtlefuse->efuse_map[EFUSE_INIT_MAP][Base + i + 1] !=
-			     rtlefuse->efuse_map[EFUSE_MODIFY_MAP][Base + i +
-								   1])) {
+			if (rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i] !=
+			    rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i] ||
+			    rtlefuse->efuse_map[EFUSE_INIT_MAP][base + i + 1] !=
+			    rtlefuse->efuse_map[EFUSE_MODIFY_MAP][base + i +
+								   1]) {
 				words_need++;
 				wordchanged = true;
 			}
@@ -519,7 +519,7 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
 }
 EXPORT_SYMBOL(rtl_efuse_shadow_map_update);
 
-void efuse_force_write_vendor_Id(struct ieee80211_hw *hw)
+void efuse_force_write_vendor_id(struct ieee80211_hw *hw)
 {
 	u8 tmpdata[8] = { 0xFF, 0xFF, 0xEC, 0x10, 0xFF, 0xFF, 0xFF, 0xFF };
 
@@ -1111,7 +1111,7 @@ void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	u8 tempval;
-	u16 tmpV16;
+	u16 tmpv16;
 
 	if (pwrstate && (rtlhal->hw_type != HARDWARE_TYPE_RTL8192SE)) {
 
@@ -1120,31 +1120,31 @@ void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate)
 			rtl_write_byte(rtlpriv,
 				       rtlpriv->cfg->maps[EFUSE_ACCESS], 0x69);
 		} else {
-			tmpV16 =
+			tmpv16 =
 			  rtl_read_word(rtlpriv,
 					rtlpriv->cfg->maps[SYS_ISO_CTRL]);
-			if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
-				tmpV16 |= rtlpriv->cfg->maps[EFUSE_PWC_EV12V];
+			if (!(tmpv16 & rtlpriv->cfg->maps[EFUSE_PWC_EV12V])) {
+				tmpv16 |= rtlpriv->cfg->maps[EFUSE_PWC_EV12V];
 				rtl_write_word(rtlpriv,
 					       rtlpriv->cfg->maps[SYS_ISO_CTRL],
-					       tmpV16);
+					       tmpv16);
 			}
 		}
-		tmpV16 = rtl_read_word(rtlpriv,
+		tmpv16 = rtl_read_word(rtlpriv,
 				       rtlpriv->cfg->maps[SYS_FUNC_EN]);
-		if (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_FEN_ELDR])) {
-			tmpV16 |= rtlpriv->cfg->maps[EFUSE_FEN_ELDR];
+		if (!(tmpv16 & rtlpriv->cfg->maps[EFUSE_FEN_ELDR])) {
+			tmpv16 |= rtlpriv->cfg->maps[EFUSE_FEN_ELDR];
 			rtl_write_word(rtlpriv,
-				       rtlpriv->cfg->maps[SYS_FUNC_EN], tmpV16);
+				       rtlpriv->cfg->maps[SYS_FUNC_EN], tmpv16);
 		}
 
-		tmpV16 = rtl_read_word(rtlpriv, rtlpriv->cfg->maps[SYS_CLK]);
-		if ((!(tmpV16 & rtlpriv->cfg->maps[EFUSE_LOADER_CLK_EN])) ||
-		    (!(tmpV16 & rtlpriv->cfg->maps[EFUSE_ANA8M]))) {
-			tmpV16 |= (rtlpriv->cfg->maps[EFUSE_LOADER_CLK_EN] |
+		tmpv16 = rtl_read_word(rtlpriv, rtlpriv->cfg->maps[SYS_CLK]);
+		if ((!(tmpv16 & rtlpriv->cfg->maps[EFUSE_LOADER_CLK_EN])) ||
+		    (!(tmpv16 & rtlpriv->cfg->maps[EFUSE_ANA8M]))) {
+			tmpv16 |= (rtlpriv->cfg->maps[EFUSE_LOADER_CLK_EN] |
 				   rtlpriv->cfg->maps[EFUSE_ANA8M]);
 			rtl_write_word(rtlpriv,
-				       rtlpriv->cfg->maps[SYS_CLK], tmpV16);
+				       rtlpriv->cfg->maps[SYS_CLK], tmpv16);
 		}
 	}
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.h b/drivers/net/wireless/realtek/rtlwifi/efuse.h
index ba608c9027f9..9fdcf4672714 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.h
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.h
@@ -85,7 +85,7 @@ void efuse_shadow_write(struct ieee80211_hw *hw, u8 type,
 bool efuse_shadow_update(struct ieee80211_hw *hw);
 bool efuse_shadow_update_chk(struct ieee80211_hw *hw);
 void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw);
-void efuse_force_write_vendor_Id(struct ieee80211_hw *hw);
+void efuse_force_write_vendor_id(struct ieee80211_hw *hw);
 void efuse_re_pg_section(struct ieee80211_hw *hw, u8 section_idx);
 void efuse_power_switch(struct ieee80211_hw *hw, u8 write, u8 pwrstate);
 int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
diff --git a/drivers/net/wireless/realtek/rtlwifi/regd.c b/drivers/net/wireless/realtek/rtlwifi/regd.c
index db5a63964e9a..b6afc029fa46 100644
--- a/drivers/net/wireless/realtek/rtlwifi/regd.c
+++ b/drivers/net/wireless/realtek/rtlwifi/regd.c
@@ -4,7 +4,7 @@
 #include "wifi.h"
 #include "regd.h"
 
-static struct country_code_to_enum_rd allCountries[] = {
+static struct country_code_to_enum_rd all_countries[] = {
 	{COUNTRY_CODE_FCC, "US"},
 	{COUNTRY_CODE_IC, "US"},
 	{COUNTRY_CODE_ETSI, "EC"},
@@ -369,9 +369,9 @@ static struct country_code_to_enum_rd *_rtl_regd_find_country(u16 countrycode)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
-		if (allCountries[i].countrycode == countrycode)
-			return &allCountries[i];
+	for (i = 0; i < ARRAY_SIZE(all_countries); i++) {
+		if (all_countries[i].countrycode == countrycode)
+			return &all_countries[i];
 	}
 	return NULL;
 }
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
index c2f670726198..84e9e6fd5e9f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/trx.c
@@ -393,7 +393,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 				(GET_RX_DESC_FAGGR(pdesc) == 1));
 	if (status->packet_report_type == NORMAL_RX)
 		status->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	status->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	status->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	status->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
 
 	status->is_cck = RTL8188_RX_HAL_IS_CCK_RATE(status->rate);
@@ -420,7 +420,7 @@ bool rtl88ee_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (status->rx_is40Mhzpacket)
+	if (status->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index 2e8f77876a81..e62fb737ec3c 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -332,7 +332,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	stats->isfirst_ampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	stats->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
 
 	stats->is_cck = RX_HAL_IS_CCK_RATE(pdesc->rxmcs);
@@ -346,7 +346,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	if (stats->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (stats->rx_is40Mhzpacket)
+	if (stats->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (stats->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 1afd2a9a3778..7557d23f56e2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -1331,7 +1331,7 @@ void rtl92cu_card_disable(struct ieee80211_hw *hw)
 	_rtl92cu_set_media_status(hw, opmode);
 	rtlpriv->cfg->ops->led_control(hw, LED_CTL_POWER_OFF);
 	RT_SET_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC);
-	if (rtlusb->disableHWSM)
+	if (rtlusb->disablehwsm)
 		_CardDisableHWSM(hw);
 	else
 		_CardDisableWithoutHWSM(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index c46c808a637f..be2330f3aec8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -298,7 +298,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	stats->isfirst_ampdu = (bool)((GET_RX_DESC_PAGGR(pdesc) == 1)
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	stats->is_ht = (bool)GET_RX_DESC_RX_HT(pdesc);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
@@ -365,7 +365,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	stats.isampdu = (bool) ((GET_RX_DESC_PAGGR(rxdesc) == 1)
 				   && (GET_RX_DESC_FAGGR(rxdesc) == 1));
 	stats.timestamp_low = GET_RX_DESC_TSFL(rxdesc);
-	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
+	stats.rx_is40mhzpacket = (bool)GET_RX_DESC_BW(rxdesc);
 	stats.is_ht = (bool)GET_RX_DESC_RX_HT(rxdesc);
 	/* TODO: is center_freq changed when doing scan? */
 	/* TODO: Shall we add protection or just skip those two step? */
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
index 37a6ec8d153b..9bff819da2ef 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/trx.c
@@ -472,7 +472,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	stats->isfirst_ampdu = (bool) ((GET_RX_DESC_PAGGR(pdesc) == 1)
 					 && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	stats->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
index c53b11e83ae2..f99fbf264291 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/trx.c
@@ -371,7 +371,7 @@ bool rtl92ee_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (status->rx_is40Mhzpacket)
+	if (status->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
index 22fd942decb1..fc42715b866b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192se/trx.c
@@ -253,7 +253,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	stats->isfirst_ampdu = (bool) ((GET_RX_STATUS_DESC_PAGGR(pdesc) == 1)
 			       && (GET_RX_STATUS_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_STATUS_DESC_TSFL(pdesc);
-	stats->rx_is40Mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
+	stats->rx_is40mhzpacket = (bool)GET_RX_STATUS_DESC_BW(pdesc);
 	stats->is_ht = (bool)GET_RX_STATUS_DESC_RX_HT(pdesc);
 	stats->is_cck = SE_RX_HAL_IS_CCK_RATE(pdesc);
 
@@ -266,7 +266,7 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	if (stats->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (stats->rx_is40Mhzpacket)
+	if (stats->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (stats->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
index 7c82c197fcb2..78b44d3fc648 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/trx.c
@@ -280,7 +280,7 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 	status->isfirst_ampdu = (bool)((GET_RX_DESC_PAGGR(pdesc) == 1) &&
 				       (GET_RX_DESC_FAGGR(pdesc) == 1));
 	status->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	status->rx_is40Mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
+	status->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	status->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
 
 	status->is_cck = RX_HAL_IS_CCK_RATE(status->rate);
@@ -294,7 +294,7 @@ bool rtl8723e_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (status->rx_is40Mhzpacket)
+	if (status->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
index c4d4af31c947..a8e16581a07b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/trx.c
@@ -316,7 +316,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 	status->isampdu = (bool)(GET_RX_DESC_PAGGR(pdesc) == 1);
 	status->isfirst_ampdu = (bool)(GET_RX_DESC_PAGGR(pdesc) == 1);
 	status->timestamp_low = GET_RX_DESC_TSFL(pdesc);
-	status->rx_is40Mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
+	status->rx_is40mhzpacket = (bool)GET_RX_DESC_BW(pdesc);
 	status->bandwidth = (u8)GET_RX_DESC_BW(pdesc);
 	status->macid = GET_RX_DESC_MACID(pdesc);
 	status->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
@@ -350,7 +350,7 @@ bool rtl8723be_rx_query_desc(struct ieee80211_hw *hw,
 	if (status->crc)
 		rx_status->flag |= RX_FLAG_FAILED_FCS_CRC;
 
-	if (status->rx_is40Mhzpacket)
+	if (status->rx_is40mhzpacket)
 		rx_status->bw = RATE_INFO_BW_40;
 
 	if (status->is_ht)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index b8e9402eb7a9..ad562b8c74d6 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -194,7 +194,7 @@ static void _usb_write32_async(struct rtl_priv *rtlpriv, u32 addr, u32 val)
 	_usb_write_async(to_usb_device(dev), addr, val, 4);
 }
 
-static void _usb_writeN_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
+static void _usb_writen_sync(struct rtl_priv *rtlpriv, u32 addr, void *data,
 			     u16 len)
 {
 	struct device *dev = rtlpriv->io.dev;
@@ -229,7 +229,7 @@ static void _rtl_usb_io_handler_init(struct device *dev,
 	rtlpriv->io.read8_sync		= _usb_read8_sync;
 	rtlpriv->io.read16_sync		= _usb_read16_sync;
 	rtlpriv->io.read32_sync		= _usb_read32_sync;
-	rtlpriv->io.writeN_sync		= _usb_writeN_sync;
+	rtlpriv->io.writen_sync		= _usb_writen_sync;
 }
 
 static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
@@ -393,7 +393,7 @@ static void rtl_usb_init_sw(struct ieee80211_hw *hw)
 	rtlusb->irq_mask[0] = 0xFFFFFFFF;
 	/* HIMR_EX - turn all on */
 	rtlusb->irq_mask[1] = 0xFFFFFFFF;
-	rtlusb->disableHWSM =  true;
+	rtlusb->disablehwsm =  true;
 }
 
 static void _rtl_rx_completed(struct urb *urb);
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
index 99c4a69ba662..5b00134a6283 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.h
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.h
@@ -84,7 +84,7 @@ struct rtl_usb {
 	/* Bcn control register setting */
 	u32 reg_bcn_ctrl_val;
 	/* for 88/92cu card disable */
-	u8	disableHWSM;
+	u8	disablehwsm;
 	/*QOS & EDCA */
 	enum acm_method acm_method;
 	/* irq  . HIMR,HIMR_EX */
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 6bbb3c28e753..a24ce718e364 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -241,7 +241,7 @@ struct rtlwifi_firmware_header {
 	u8 date;
 	u8 hour;
 	u8 minute;
-	__le16 ramcodeSize;
+	__le16 ramcodesize;
 	__le16 rsvd2;
 	__le32 svnindex;
 	__le32 rsvd3;
@@ -443,11 +443,11 @@ enum hw_variables {
 	HW_VAR_MCS_RATE_AVAILABLE = 0x1f,
 	HW_VAR_AC_PARAM = 0x20,
 	HW_VAR_ACM_CTRL = 0x21,
-	HW_VAR_DIS_Req_Qsize = 0x22,
+	HW_VAR_DIS_REQ_QSIZE = 0x22,
 	HW_VAR_CCX_CHNL_LOAD = 0x23,
 	HW_VAR_CCX_NOISE_HISTOGRAM = 0x24,
 	HW_VAR_CCX_CLM_NHM = 0x25,
-	HW_VAR_TxOPLimit = 0x26,
+	HW_VAR_TXOPLIMIT = 0x26,
 	HW_VAR_TURBO_MODE = 0x27,
 	HW_VAR_RF_STATE = 0x28,
 	HW_VAR_RF_OFF_BY_HW = 0x29,
@@ -500,7 +500,7 @@ enum hw_variables {
 	HW_VAR_BCN_VALID = 0x55,
 	HW_VAR_FWLPS_RF_ON = 0x56,
 	HW_VAR_DUAL_TSF_RST = 0x57,
-	HW_VAR_SWITCH_EPHY_WoWLAN = 0x58,
+	HW_VAR_SWITCH_EPHY_WOWLAN = 0x58,
 	HW_VAR_INT_MIGRATION = 0x59,
 	HW_VAR_INT_AC = 0x5a,
 	HW_VAR_RF_TIMING = 0x5b,
@@ -792,8 +792,8 @@ enum _fw_ps_mode {
 	FW_PS_UAPSD_MODE = 6,
 	FW_PS_IBSS_MODE = 7,
 	FW_PS_WWLAN_MODE = 8,
-	FW_PS_PM_Radio_Off = 9,
-	FW_PS_PM_Card_Disable = 10,
+	FW_PS_PM_RADIO_OFF = 9,
+	FW_PS_PM_CARD_DISABLE = 10,
 };
 
 enum rt_psmode {
@@ -827,8 +827,8 @@ enum rtl_led_pin {
 /*QoS related.*/
 /*acm implementation method.*/
 enum acm_method {
-	eAcmWay0_SwAndHw = 0,
-	eAcmWay1_HW = 1,
+	EACMWAY0_SWANDHW = 0,
+	EACMWAY1_HW = 1,
 	EACMWAY2_SW = 2,
 };
 
@@ -1459,7 +1459,7 @@ struct rtl_io {
 	void (*write8_async) (struct rtl_priv *rtlpriv, u32 addr, u8 val);
 	void (*write16_async) (struct rtl_priv *rtlpriv, u32 addr, u16 val);
 	void (*write32_async) (struct rtl_priv *rtlpriv, u32 addr, u32 val);
-	void (*writeN_sync) (struct rtl_priv *rtlpriv, u32 addr, void *buf,
+	void (*writen_sync)(struct rtl_priv *rtlpriv, u32 addr, void *buf,
 			     u16 len);
 
 	u8(*read8_sync) (struct rtl_priv *rtlpriv, u32 addr);
@@ -1876,7 +1876,7 @@ struct rtl_dm {
 
 struct rtl_efuse {
 	const struct rtl_efuse_ops *efuse_ops;
-	bool autoLoad_ok;
+	bool autoload_ok;
 	bool bootfromefuse;
 	u16 max_physical_size;
 
@@ -2103,7 +2103,7 @@ struct rtl_stats {
 	u8 rx_bufshift;
 	bool isampdu;
 	bool isfirst_ampdu;
-	bool rx_is40Mhzpacket;
+	bool rx_is40mhzpacket;
 	u8 rx_packet_bw;
 	u32 rx_pwdb_all;
 	u8 rx_mimo_signalstrength[4];	/*in 0~100 index */
@@ -2254,8 +2254,8 @@ struct rtl_hal_ops {
 			      struct ieee80211_sta *sta,
 			      struct sk_buff *skb, u8 hw_queue,
 			      struct rtl_tcb_desc *ptcb_desc);
-	void (*fill_fake_txdesc) (struct ieee80211_hw *hw, u8 *pDesc,
-				  u32 buffer_len, bool bIsPsPoll);
+	void (*fill_fake_txdesc)(struct ieee80211_hw *hw, u8 *pdesc,
+				 u32 buffer_len, bool bsspspoll);
 	void (*fill_tx_cmddesc) (struct ieee80211_hw *hw, u8 *pdesc,
 				 bool firstseg, bool lastseg,
 				 struct sk_buff *skb);
-- 
2.20.1

