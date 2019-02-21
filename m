Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A1D7C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 309D32077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T8ItSBi9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfBUTb3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:29 -0500
Received: from mail-oi1-f195.google.com ([209.85.167.195]:34086 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfBUTb2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:28 -0500
Received: by mail-oi1-f195.google.com with SMTP id g16so2355464oib.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2iID4z2rRwZibp5uQgxemNo4aZWiWVSc90gVJLoh0iw=;
        b=T8ItSBi9pTUSmUCVJG7+bVt7a7vnWAVsKfdz32VIbzF+4dVBwiKoj6iQhcZflQCnuZ
         xqnxyoPSdcjg0YNslM23D5wuxS1qJ2N8z1gL1SjMrlZW2zbosj8zM79lH//uzbUtn3/L
         wt0IIWzFD8CZusKJAxBrifhVqqCJunAEkOzU4gunlhLC0WOwyy4Vtabt7431jOSZdyHz
         G5pKxYoapkL38cjOm3zkYXPaEcmqVHbbugYGUz71WdWDAtOS2gBGdiHbXYEulBKDSJFF
         YLx3fIMOfPEBmTDFGx1ugJjwRhrTU1NL2/RqQczhl5p+cHW4S0DUJrRFZm8fQIuUs2Z0
         j2nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=2iID4z2rRwZibp5uQgxemNo4aZWiWVSc90gVJLoh0iw=;
        b=klg7IcNq4bNcy7tv/0d8NgHkYIdEuabTSYQel4OHnitjUXL4Z3/Z+efzZeRqFwc/Xq
         bmFe5wN+cUCyH0WLdc8TfbBZA4cU09TkOITr0nP8nfblPrv7dTJQik5vNvSOJd66YMF4
         9Zm0rmTGzQfMUMKauThUvXeaBKzxHeymvI6v87UhQXy2GOou3ob0GOmBqTN891sSOp5z
         JJxdyjg/gNgShBGzllZhLh83nuX2zCwhSQB7y3fcjWipMqxRHnV3Vstn+n+IrAA5ONxg
         vJDMDdEbN0zEH8Kswnzvr7HkfC0abi3j6kIu5SSn6FiNLLPniGo712OEWDqvDpP/9XDF
         5eeQ==
X-Gm-Message-State: AHQUAuY9FV5Frh5yYroX98PCav4faTwIwdITpLrhP8W+3wcPMqc8Mcs4
        m6N47SvLT39XpH/ASEaZsvs=
X-Google-Smtp-Source: AHgI3IbmtJOtZmDQrV9jzj+WzOQWcPJ7rL9VaNkRCq0zzwM9PIPL0C1569Ib5UIba4YTExSv98KLGA==
X-Received: by 2002:aca:da83:: with SMTP id r125mr126422oig.8.1550777487489;
        Thu, 21 Feb 2019 11:31:27 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:26 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/8] rtlwifi: rtl8192ce: Fix missing blank lines
Date:   Thu, 21 Feb 2019 13:31:13 -0600
Message-Id: <20190221193115.30848-7-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The problems filed include the following:

WARNING: Missing a blank line after declarations
CHECK: Please don't use multiple blank lines

There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c    | 7 ++++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c   | 1 +
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c   | 8 ++++++++
 4 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
index 7c94cabc19a6..10d85c2c7867 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/hw.c
@@ -144,6 +144,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_BASIC_RATE:{
 			u16 rate_cfg = ((u16 *) val)[0];
 			u8 rate_index = 0;
+
 			rate_cfg &= 0x15f;
 			rate_cfg |= 0x01;
 			rtl_write_byte(rtlpriv, REG_RRSR, rate_cfg & 0xff);
@@ -197,6 +198,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_ACK_PREAMBLE:{
 			u8 reg_tmp;
 			u8 short_preamble = (bool)*val;
+
 			reg_tmp = (mac->cur_40_prime_sc) << 5;
 			if (short_preamble)
 				reg_tmp |= 0x80;
@@ -293,6 +295,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		}
 	case HW_VAR_AC_PARAM:{
 			u8 e_aci = *(val);
+
 			rtl92c_dm_init_edca_turbo(hw);
 
 			if (rtlpci->acm_method != EACMWAY2_SW)
@@ -456,6 +459,7 @@ void rtl92ce_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		break;
 	case HW_VAR_AID:{
 			u16 u2btmp;
+
 			u2btmp = rtl_read_word(rtlpriv, REG_BCN_PSR_RPT);
 			u2btmp &= 0xC000;
 			rtl_write_word(rtlpriv, REG_BCN_PSR_RPT, (u2btmp |
@@ -661,6 +665,7 @@ static bool _rtl92ce_init_mac(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_RSV_CTRL, 0x00);
 	if (rtlpriv->btcoexist.bt_coexistence) {
 		u32 value32;
+
 		value32 = rtl_read_dword(rtlpriv, REG_APS_FSMCO);
 		value32 |= (SOP_ABG | SOP_AMB | XOP_BTCK);
 		rtl_write_dword(rtlpriv, REG_APS_FSMCO, value32);
@@ -1245,6 +1250,7 @@ int rtl92ce_set_network_type(struct ieee80211_hw *hw, enum nl80211_iftype type)
 void rtl92ce_set_qos(struct ieee80211_hw *hw, int aci)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	rtl92c_dm_init_edca_turbo(hw);
 	switch (aci) {
 	case AC1_BK:
@@ -2279,7 +2285,6 @@ void rtl8192ce_bt_reg_init(struct ieee80211_hw *hw)
 	rtlpriv->btcoexist.reg_bt_sco = 0;
 }
 
-
 void rtl8192ce_bt_hw_init(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
index 8d18210dd5c8..f6574f31fa3b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/phy.c
@@ -443,6 +443,7 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 			    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
 				bool rtstatus;
 				u32 initializecount = 0;
+
 				do {
 					initializecount++;
 					RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
index e258b0803699..58878db404ed 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/table.c
@@ -3,7 +3,6 @@
 
 #include "table.h"
 
-
 u32 RTL8192CEPHY_REG_2TARRAY[PHY_REG_2TARRAY_LENGTH] = {
 	0x024, 0x0011800f,
 	0x028, 0x00ffdb83,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
index b08fb1bf6709..18a0ab59631a 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ce/trx.c
@@ -36,6 +36,7 @@ static u8 _rtl92c_query_rxpwrpercentage(s8 antpower)
 static u8 _rtl92c_evm_db_to_percentage(s8 value)
 {
 	s8 ret_val;
+
 	ret_val = value;
 
 	if (ret_val >= 0)
@@ -109,6 +110,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 
 	if (is_cck_rate) {
 		u8 report, cck_highpwr;
+
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 
 		if (ppsc->rfpwr_state == ERFON)
@@ -120,6 +122,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 
 		if (!cck_highpwr) {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+
 			report = cck_buf->cck_agc_rpt & 0xc0;
 			report = report >> 6;
 			switch (report) {
@@ -138,6 +141,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 			}
 		} else {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+
 			report = p_drvinfo->cfosho[0] & 0x60;
 			report = report >> 5;
 			switch (report) {
@@ -182,6 +186,7 @@ static void _rtl92ce_query_rxphystatus(struct ieee80211_hw *hw,
 		/* (3) Get Signal Quality (EVM) */
 		if (packet_match_bssid) {
 			u8 sq;
+
 			if (pstats->rx_pwdb_all > 40)
 				sq = 100;
 			else {
@@ -318,6 +323,7 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	struct rx_desc_92c *pdesc = (struct rx_desc_92c *)p_desc;
 	struct ieee80211_hdr *hdr;
 	u32 phystatus = GET_RX_DESC_PHYST(pdesc);
+
 	stats->length = (u16) GET_RX_DESC_PKT_LEN(pdesc);
 	stats->rx_drvinfo_size = (u8) GET_RX_DESC_DRV_INFO_SIZE(pdesc) *
 	    RX_DRV_INFO_SIZE_UNIT;
@@ -497,6 +503,7 @@ void rtl92ce_tx_fill_desc(struct ieee80211_hw *hw,
 
 		if (sta) {
 			u8 ampdu_density = sta->ht_cap.ampdu_density;
+
 			SET_TX_DESC_AMPDU_DENSITY(pdesc, ampdu_density);
 		}
 
@@ -733,6 +740,7 @@ bool rtl92ce_is_tx_desc_closed(struct ieee80211_hw *hw,
 void rtl92ce_tx_polling(struct ieee80211_hw *hw, u8 hw_queue)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (hw_queue == BEACON_QUEUE) {
 		rtl_write_word(rtlpriv, REG_PCIE_CTRL_REG, BIT(4));
 	} else {
-- 
2.20.1

