Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C7E6C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24D3F2077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GNr3wdmb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbfBUTba (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:30 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:33062 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfBUTb3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:29 -0500
Received: by mail-ot1-f67.google.com with SMTP id q24so1958711otk.0
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Xb1p7dHqYY2Nr5NjHDrLBbY7LIv1HIHKHBwdkjX5xHo=;
        b=GNr3wdmbKb7bT7RGQlZskYJCBiy4FAfuBrRoMV7MZtrwVa7blnQxjCdQY3S+DQoyMy
         +dGKdcCBn0/laKyAKRIoDt+IjXRLUIdBWXD5teEAY33LAgWQpDuAI2fwAuzWZatsyjc5
         Z+RBcSrHHrsymFc0P0Ah0GEbV0BYG37SDgp4iOUpAdZywcGzsyKyf+niU1WQjeCiCm/E
         cBLsKzdBYlDRoBpDS66UDkDYU3wb1Al4RKyXgI8I1Lqv0Ijt1hmWpbZ0+mDWza7/lXd0
         6+5IV7VrUOV0L91oVMFso0/G2096wlBln7DTN3Ab6rFtY/oSxrgkCsYeixKOlG5vUKNx
         XmLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Xb1p7dHqYY2Nr5NjHDrLBbY7LIv1HIHKHBwdkjX5xHo=;
        b=e/u68W5PyqnWJE8ZCtDGJ1NjNB79N/XQD3JiUAgi9jJEtQ9XBjuW1H2qN2e0nEtCiM
         e3KCeyQQmeDFbWjAXON5Aj3Ylxa4myXfpDmXKZPiUjAXtIrxz0C6JS01rsGUnOmYsZBS
         g304OO2niAI07JLih616dLXIxvW4fv+J/LcSmMPp9UKzNxmYwXss8Gkg3eSfoSFuqIgz
         DjbJY41B+vCsaVDfsS0acCn8Is4pW9NGvz7tj7RHtW/hvBal17mnpZKZ2u+8V1X/WakD
         5a4tZJ7igMHmeXHerHTFP6kFjdJoykrJXmFfDvhvMFpy7peAhKLPnAuDUW5UoOo+ydJv
         InaA==
X-Gm-Message-State: AHQUAuaKU+2EI2X+UTgBfWyavMOQA+jKuw17qs2GhYvkpWPf5+Sdu9Jg
        95KmarToiTT+8zoD/fvcWfE=
X-Google-Smtp-Source: AHgI3IYLAZPCTSez0MG3mpav4plFAb8rEbGsBflXjDIo1TeBP07D83sS5WpIMfLwfpEaVdxInvUDTw==
X-Received: by 2002:a05:6830:193:: with SMTP id q19mr128011ota.278.1550777488576;
        Thu, 21 Feb 2019 11:31:28 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:27 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 7/8] rtlwifi: rtl8192cu: Fix problems with blank lines
Date:   Thu, 21 Feb 2019 13:31:14 -0600
Message-Id: <20190221193115.30848-8-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following problems were found:

WARNING: Missing a blank line after declarations
CHECK: Please don't use multiple blank lines
CHECK: Please use a blank line after function/struct/union/enum declarations

There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c  | 9 ++++++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h  | 4 ----
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c | 8 +++++++-
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h | 3 ---
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c | 7 +++++++
 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h | 2 --
 6 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
index 52ee713d50f5..56cc3bc30860 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c
@@ -747,6 +747,7 @@ static void _rtl92cu_init_queue_priority(struct ieee80211_hw *hw,
 						u8 queue_sel)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
 	if (IS_NORMAL_CHIP(rtlhal->version))
 		_rtl92cu_init_chipn_queue_priority(hw, wmm_enable, out_ep_num,
 						   queue_sel);
@@ -813,6 +814,7 @@ static int _rtl92cu_init_mac(struct ieee80211_hw *hw)
 	u8 wmm_enable = false; /* TODO */
 	u8 out_ep_nums = rtlusb->out_ep_nums;
 	u8 queue_sel = rtlusb->out_queue_sel;
+
 	err = _rtl92cu_init_power_on(hw);
 
 	if (err) {
@@ -1013,6 +1015,7 @@ d.	SYS_FUNC_EN 0x02[7:0] = 0x16	reset BB state machine
 e.	SYS_FUNC_EN 0x02[7:0] = 0x14	reset BB state machine
 ***************************************/
 	u8 erfpath = 0, value8 = 0;
+
 	rtl_write_byte(rtlpriv, REG_TXPAUSE, 0xFF);
 	rtl_set_rfreg(hw, (enum radio_path)erfpath, 0x0, MASKBYTE0, 0x0);
 
@@ -1204,6 +1207,7 @@ static void _rtl92cu_stop_tx_beacon(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u8 tmp1byte = 0;
+
 	if (IS_NORMAL_CHIP(rtlhal->version)) {
 		tmp1byte = rtl_read_byte(rtlpriv, REG_FWHW_TXQ_CTRL + 2);
 		rtl_write_byte(rtlpriv, REG_FWHW_TXQ_CTRL + 2,
@@ -1353,6 +1357,7 @@ void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 
 	if (check_bssid) {
 		u8 tmp;
+
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
 			reg_rcr |= (RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 			tmp = BIT(4);
@@ -1365,6 +1370,7 @@ void rtl92cu_set_check_bssid(struct ieee80211_hw *hw, bool check_bssid)
 		_rtl92cu_set_bcn_ctrl_reg(hw, 0, tmp);
 	} else {
 		u8 tmp;
+
 		if (IS_NORMAL_CHIP(rtlhal->version)) {
 			reg_rcr &= ~(RCR_CBSSID_DATA | RCR_CBSSID_BCN);
 			tmp = BIT(4);
@@ -1631,6 +1637,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	case HW_VAR_ACK_PREAMBLE:{
 			u8 reg_tmp;
 			u8 short_preamble = (bool)*val;
+
 			reg_tmp = 0;
 			if (short_preamble)
 				reg_tmp |= 0x80;
@@ -1881,6 +1888,7 @@ void rtl92cu_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		break;
 	case HW_VAR_KEEP_ALIVE:{
 			u8 array[2];
+
 			array[0] = 0xff;
 			array[1] = *((u8 *)val);
 			rtl92c_fill_h2c_cmd(hw, H2C_92C_KEEP_ALIVE_CTRL, 2,
@@ -1963,7 +1971,6 @@ static void rtl92cu_update_hal_rate_table(struct ieee80211_hw *hw,
 	if (nmode && ((curtxbw_40mhz &&
 			 curshortgi_40mhz) || (!curtxbw_40mhz &&
 					       curshortgi_20mhz))) {
-
 		ratr_value |= 0x10000000;
 		tmp_ratr_value = (ratr_value >> 12);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
index 0ccc47e36652..5c48c3fd45e4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.h
@@ -14,14 +14,12 @@
 #define TX_TOTAL_PAGE_NUMBER			0xF8
 #define TX_PAGE_BOUNDARY			(TX_TOTAL_PAGE_NUMBER + 1)
 
-
 #define CHIP_B_PAGE_NUM_PUBQ			0xE7
 
 /* For Test Chip Setting
  * (HPQ + LPQ + PUBQ) shall be TX_TOTAL_PAGE_NUMBER */
 #define CHIP_A_PAGE_NUM_PUBQ			0x7E
 
-
 /* For Chip A Setting */
 #define WMM_CHIP_A_TX_TOTAL_PAGE_NUMBER		0xF5
 #define WMM_CHIP_A_TX_PAGE_BOUNDARY		\
@@ -31,8 +29,6 @@
 #define WMM_CHIP_A_PAGE_NUM_HPQ			0x29
 #define WMM_CHIP_A_PAGE_NUM_LPQ			0x29
 
-
-
 /* Note: For Chip B Setting ,modify later */
 #define WMM_CHIP_B_TX_TOTAL_PAGE_NUMBER		0xF5
 #define WMM_CHIP_B_TX_PAGE_BOUNDARY		\
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
index cc2ba74bff81..b3ce8000d52d 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.c
@@ -24,7 +24,6 @@
 #define RX_EVM	rx_evm_percentage
 #define RX_SIGQ	rx_mimo_sig_qual
 
-
 void rtl92c_read_chip_version(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
@@ -143,6 +142,7 @@ bool rtl92c_llt_write(struct ieee80211_hw *hw, u32 address, u32 data)
 	} while (++count);
 	return status;
 }
+
 /**
  * rtl92c_init_LLT_table - Init LLT table
  * @io: io callback
@@ -189,6 +189,7 @@ bool rtl92c_init_llt_table(struct ieee80211_hw *hw, u32 boundary)
 	}
 	return rst;
 }
+
 void rtl92c_set_key(struct ieee80211_hw *hw, u32 key_index,
 		     u8 *p_macaddr, bool is_group, u8 enc_algo,
 		     bool is_wepkey, bool clear_all)
@@ -370,6 +371,7 @@ void rtl92c_set_qos(struct ieee80211_hw *hw, int aci)
 void rtl92c_init_driver_info_size(struct ieee80211_hw *hw, u8 size)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	rtl_write_byte(rtlpriv, REG_RX_DRVINFO_SZ, size);
 }
 
@@ -647,6 +649,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 	pstats->RX_SIGQ[1] = -1;
 	if (is_cck_rate) {
 		u8 report, cck_highpwr;
+
 		cck_buf = (struct phy_sts_cck_8192s_t *)p_drvinfo;
 		if (!in_powersavemode)
 			cck_highpwr = rtlphy->cck_high_power;
@@ -654,6 +657,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 			cck_highpwr = false;
 		if (!cck_highpwr) {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+
 			report = cck_buf->cck_agc_rpt & 0xc0;
 			report = report >> 6;
 			switch (report) {
@@ -672,6 +676,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 			}
 		} else {
 			u8 cck_agc_rpt = cck_buf->cck_agc_rpt;
+
 			report = p_drvinfo->cfosho[0] & 0x60;
 			report = report >> 5;
 			switch (report) {
@@ -694,6 +699,7 @@ static void _rtl92c_query_rxphystatus(struct ieee80211_hw *hw,
 		pstats->recvsignalpower = rx_pwr_all;
 		if (packet_match_bssid) {
 			u8 sq;
+
 			if (pstats->rx_pwdb_all > 40)
 				sq = 100;
 			else {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
index 62eb3c5adec1..dd76a05829d5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/mac.h
@@ -18,7 +18,6 @@ void rtl92c_enable_interrupt(struct ieee80211_hw *hw);
 void rtl92c_disable_interrupt(struct ieee80211_hw *hw);
 void rtl92c_set_qos(struct ieee80211_hw *hw, int aci);
 
-
 /*---------------------------------------------------------------
  *	Hardware init functions
  *---------------------------------------------------------------*/
@@ -130,6 +129,4 @@ void rtl92c_translate_rx_signal_stuff(struct ieee80211_hw *hw,
  *	Card disable functions
  *---------------------------------------------------------------*/
 
-
-
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
index 4293d0640310..0020adc004a5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.c
@@ -108,6 +108,7 @@ static void threeoutepmapping(struct ieee80211_hw *hw, bool  bwificfg,
 			       struct rtl_ep_map *ep_map)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	if (bwificfg) { /* for WMM */
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_DMESG,
 			 "USB 3EP Setting for WMM.....\n");
@@ -141,6 +142,7 @@ static void oneoutepmapping(struct ieee80211_hw *hw, struct rtl_ep_map *ep_map)
 	ep_map->ep_mapping[RTL_TXQ_BCN] = 2;
 	ep_map->ep_mapping[RTL_TXQ_HI]	= 2;
 }
+
 static int _out_ep_mapping(struct ieee80211_hw *hw)
 {
 	int err = 0;
@@ -174,11 +176,13 @@ static int _out_ep_mapping(struct ieee80211_hw *hw)
 	return err;
 
 }
+
 /* endpoint mapping */
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw)
 {
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
 	int error = 0;
+
 	if (likely(IS_NORMAL_CHIP(rtlhal->version)))
 		error = configvernoutep(hw);
 	else
@@ -442,6 +446,7 @@ static void _rtl_fill_usb_tx_desc(u8 *txdesc)
 	SET_TX_DESC_LAST_SEG(txdesc, 1);
 	SET_TX_DESC_FIRST_SEG(txdesc, 1);
 }
+
 /**
  *	For HW recovery information
  */
@@ -531,11 +536,13 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	sta = ieee80211_find_sta(mac->vif, mac->bssid);
 	if (sta) {
 		u8 ampdu_density = sta->ht_cap.ampdu_density;
+
 		SET_TX_DESC_AMPDU_DENSITY(txdesc, ampdu_density);
 	}
 	rcu_read_unlock();
 	if (info->control.hw_key) {
 		struct ieee80211_key_conf *keyconf = info->control.hw_key;
+
 		switch (keyconf->cipher) {
 		case WLAN_CIPHER_SUITE_WEP40:
 		case WLAN_CIPHER_SUITE_WEP104:
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
index 439ced0e18fa..ae2e8aa212de 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192cu/trx.h
@@ -198,7 +198,6 @@ struct rx_drv_info_92c {
 #define SET_TX_DESC_OWN(__txdesc, __value)		\
 	SET_BITS_TO_LE_4BYTE(__txdesc, 31, 1, __value)
 
-
 /* Dword 1 */
 #define SET_TX_DESC_MACID(__txdesc, __value)		\
 	SET_BITS_TO_LE_4BYTE(__txdesc + 4, 0, 5, __value)
@@ -355,7 +354,6 @@ struct rx_drv_info_92c {
 #define SET_TX_DESC_MCSG15_MAX_LEN(__txdesc, __value)	\
 	SET_BITS_TO_LE_4BYTE(__txdesc + 28, 28, 4, __value)
 
-
 int  rtl8192cu_endpoint_mapping(struct ieee80211_hw *hw);
 u16 rtl8192cu_mq_to_hwq(__le16 fc, u16 mac80211_queue_index);
 bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
-- 
2.20.1

