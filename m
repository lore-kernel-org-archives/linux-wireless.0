Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C85BC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C9D92077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OgfzSAV5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbfBUTbb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:31 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:38751 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfBUTba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:30 -0500
Received: by mail-oi1-f193.google.com with SMTP id q81so2351357oic.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FdVj9AHt4tEhrqbqbgYbrRJ0XYXFwyBtIAQ6XOsztIg=;
        b=OgfzSAV5v7fAxyQeL19cxstJG7DlhOvQbCeW3SpDBxfff2gn88bzKO+XovDuicGMlK
         7ySrJqweOygNhAqtiljQnPUZakOXHrfHmnW4FAyZeROHgCUDfGNB0xG5ngLXTfn203iG
         hk1Hvw1Vv2mKCCmIbgh3GKRcZow3KWbhNwlOTnPbUez/jfr/ZWhum5bGynTv2zwwNKRl
         962Is+i+bGOTpevKAIixFwTOvUq5TXbu6lhjKXu05zxXm4OHHfR3J7GcB/cvGWKk9ONF
         lZXt9A3py+1aJjKvb96GuOn8Xm58x73421QgO3CMOUHrkmLxWXimwo8r46D6fsNBXlwf
         f23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=FdVj9AHt4tEhrqbqbgYbrRJ0XYXFwyBtIAQ6XOsztIg=;
        b=TBC24OvAdcfCiXOJ1UmrjUYoUhrcbNi3x8rlzcJj52Evgwrruviqz6w/cRckGpwOBM
         sQ05okPRq5SCESNDL7DyfJfxvUdeQ2yOL5YcAT0thSkTCBO17wRUNltEz2aTUSM3My7W
         O9vrEGzRK7mhODyXirIgULBLf//ZhzaDPThlZFEbRtdDUbrdbHiJuYwWzYW97302k6Tw
         b82cki6PWQ8QfZ+4/Gg2l12BEy6SSg59ZKCGE+8muE4dzqgAy/Y4gZCIJuTOGbCUJw/b
         u/AiAWYXNavjWguzGHueeAiyyFalqeImAt5LB2QI4QtazWpWl9zpDM7Mnd5RB9n0Eoj+
         nzHw==
X-Gm-Message-State: AHQUAuYukleZPkWCt7ZsCAt464CKGeeq4vneUa/UEjzhZxMsCxrLK06Q
        0A5yxCFoT1wGySSvETHVogiawFZo
X-Google-Smtp-Source: AHgI3IZE4p9jUXMsTtBrYr7h/l3Mjg6AzcJrKPNEf1TCQLzDWq+C1FvRKPRQHfoV41ALXjhCyUqqig==
X-Received: by 2002:aca:d509:: with SMTP id m9mr119336oig.64.1550777489602;
        Thu, 21 Feb 2019 11:31:29 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:28 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 8/8] rtlwifi: rtl8192com: Fix blank line problems
Date:   Thu, 21 Feb 2019 13:31:15 -0600
Message-Id: <20190221193115.30848-9-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The following types of blank line problems are reported:

WARNING: Missing a blank line after declarations
CHECK: Please don't use multiple blank lines

There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c  | 6 ++----
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c  | 5 ++---
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c       | 1 -
 drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c | 1 +
 4 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
index 2d5664ab011e..00d3b7015f82 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/dm_common.c
@@ -425,7 +425,6 @@ static void rtl92c_dm_initial_gain_sta(struct ieee80211_hw *hw)
 	if (dm_digtable->presta_cstate == dm_digtable->cursta_cstate ||
 	    dm_digtable->cursta_cstate == DIG_STA_BEFORE_CONNECT ||
 	    dm_digtable->cursta_cstate == DIG_STA_CONNECT) {
-
 		if (dm_digtable->cursta_cstate != DIG_STA_DISCONNECT) {
 			dm_digtable->rssi_val_min =
 			    rtl92c_dm_initial_gain_min_pwdb(hw);
@@ -504,7 +503,6 @@ static void rtl92c_dm_ctrl_initgain_by_twoport(struct ieee80211_hw *hw)
 	rtl92c_dm_cck_packet_detection_thresh(hw);
 
 	dm_digtable->presta_cstate = dm_digtable->cursta_cstate;
-
 }
 
 static void rtl92c_dm_dig(struct ieee80211_hw *hw)
@@ -607,6 +605,7 @@ static void rtl92c_dm_pwdb_monitor(struct ieee80211_hw *hw)
 void rtl92c_dm_init_edca_turbo(struct ieee80211_hw *hw)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	rtlpriv->dm.current_turbo_edca = false;
 	rtlpriv->dm.is_any_nonbepkts = false;
 	rtlpriv->dm.is_cur_rdlstate = false;
@@ -660,7 +659,6 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 
 	if ((bt_change_edca) || ((!rtlpriv->dm.is_any_nonbepkts) &&
 	     (!rtlpriv->dm.disable_framebursting))) {
-
 		cur_txok_cnt = rtlpriv->stats.txbytesunicast - last_txok_cnt;
 		cur_rxok_cnt = rtlpriv->stats.rxbytesunicast - last_rxok_cnt;
 
@@ -685,6 +683,7 @@ static void rtl92c_dm_check_edca_turbo(struct ieee80211_hw *hw)
 	} else {
 		if (rtlpriv->dm.current_turbo_edca) {
 			u8 tmp = AC0_BE;
+
 			rtlpriv->cfg->ops->set_hw_reg(hw, HW_VAR_AC_PARAM,
 						      &tmp);
 			rtlpriv->dm.current_turbo_edca = false;
@@ -1634,7 +1633,6 @@ static void rtl92c_bt_ant_isolation(struct ieee80211_hw *hw, u8 tmp1byte)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 
-
 	/* Only enable HW BT coexist when BT in "Busy" state. */
 	if (rtlpriv->mac80211.vendor == PEER_CISCO &&
 	    rtlpriv->btcoexist.bt_service == BT_OTHER_ACTION) {
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 6af72799e09c..18c76990a089 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -18,6 +18,7 @@ static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CU) {
 		u32 value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
+
 		if (enable)
 			value32 |= MCUFWDL_EN;
 		else
@@ -25,8 +26,8 @@ static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 		rtl_write_dword(rtlpriv, REG_MCUFWDL, value32);
 	} else if (rtlhal->hw_type == HARDWARE_TYPE_RTL8192CE) {
 		u8 tmp;
-		if (enable) {
 
+		if (enable) {
 			tmp = rtl_read_byte(rtlpriv, REG_SYS_FUNC_EN + 1);
 			rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN + 1,
 				       tmp | 0x04);
@@ -37,7 +38,6 @@ static void _rtl92c_enable_fw_download(struct ieee80211_hw *hw, bool enable)
 			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL + 2);
 			rtl_write_byte(rtlpriv, REG_MCUFWDL + 2, tmp & 0xf7);
 		} else {
-
 			tmp = rtl_read_byte(rtlpriv, REG_MCUFWDL);
 			rtl_write_byte(rtlpriv, REG_MCUFWDL, tmp & 0xfe);
 
@@ -622,7 +622,6 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw,
 		      "rtl92c_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL\n",
 		      u1rsvdpageloc, 3);
 
-
 	skb = dev_alloc_skb(totalpacketlen);
 	skb_put_data(skb, &reserved_page_packet, totalpacketlen);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
index e8af1952d243..97ad21c3964f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/main.c
@@ -4,7 +4,6 @@
 #include "../wifi.h"
 #include <linux/module.h>
 
-
 MODULE_AUTHOR("lizhaoming	<chaoming_li@realsil.com.cn>");
 MODULE_AUTHOR("Realtek WlanFAE	<wlanfae@realtek.com>");
 MODULE_AUTHOR("Georgia		<georgia@realtek.com>");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
index c6a3ed441c3f..0efd19aa4fe5 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/phy_common.c
@@ -747,6 +747,7 @@ static void _rtl92c_phy_sw_rf_seting(struct ieee80211_hw *hw, u8 channel)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &(rtlpriv->phy);
 	struct rtl_hal *rtlhal = rtl_hal(rtl_priv(hw));
+
 	if (IS_81XXC_VENDOR_UMC_B_CUT(rtlhal->version)) {
 		if (channel == 6 &&
 		    rtlphy->current_chan_bw == HT_CHANNEL_WIDTH_20) {
-- 
2.20.1

