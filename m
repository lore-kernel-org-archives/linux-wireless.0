Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLACK,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EA7C10F04
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2C5721B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XT8HCeiQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503410AbfBNWhF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:05 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:46443 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729482AbfBNWg4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:36:56 -0500
Received: by mail-ot1-f68.google.com with SMTP id w25so13314339otm.13
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:36:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GTuO968eQ5Cd6fcLu6964Uk6G+WOmg2V9GSHFHXVXyE=;
        b=XT8HCeiQ9COw6gDS9QBNZ1AX2BFhAby1K/wEhAr5e7FMR/5keZWAyseg+Ipu6y9L3Q
         +gxOOvuVcL1OJrWPvP8a59jNWb9WhSgq60PvNCIPaFALRo54LR/dPy+ghxdtCsvyQw5M
         u4c7M/B3sn/coNaNxl3QPE0tfghmhSQO++Dkp1Rrt8W2yF+vJnkXmVD4npKWKyffghZv
         4zANh6++pn1a9Hwg5gu3tz1jp/qkTYU2IxNgXgp94QySHCVSRewUiHrDgeVjz5Tzw99d
         6Kdp6dekXVDIbTFDPAOBmbUl1sbCOWhkqnbYmj5AMN+dEf0l7U6PTuEuaAnEpUje/Tkl
         uAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=GTuO968eQ5Cd6fcLu6964Uk6G+WOmg2V9GSHFHXVXyE=;
        b=arKgc745ptKDp7abu0gf1NsBIs6WAIlTIWqGb6URWV6FtCI46/zku63aqN59ySNG46
         fpcaNaaB1x0tBXq1Gl2DwlVSpdhKdgD2eu4VhFnexPGS6H+w6kBg2t8BlQ45SG9WousF
         VBL9YNmTZjubsnetCUA59509wAM3dvIOqVFiXIk4aIc70ky8h5K3K6siCHAHwP3MjugG
         iTJG+EwAc2zZU71f5jYGlb1fISJH0wa4z9g3ae1QkrULj/T28mlb3vGHdIu8/lwjgqLs
         b7nMp/jwj9paPYkoK7ZX5hnn2sdW5YJmwuz/Qd3JDov5OeAOzvkgl9I6BBacS790KTJf
         oKgw==
X-Gm-Message-State: AHQUAuYLS02CM9tFs2/1k2CumleNAP/RkcCQ/75Jc7hs1SlYNY6YDVs5
        wzHIfmToE5BZtWRpcnM4bpdhrOZl
X-Google-Smtp-Source: AHgI3IZRVCvX27SXidQx5jbuWCi34lKRPVZI/oEcGL5WLv2R5zcUkpEZst99734lcwfxPLo8IUjyqw==
X-Received: by 2002:a9d:7505:: with SMTP id r5mr4044685otk.323.1550183813615;
        Thu, 14 Feb 2019 14:36:53 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id h1sm1463938otm.0.2019.02.14.14.36.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:53 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/8] rtlwifi: rtl8188de: Remove CamelCase variables
Date:   Thu, 14 Feb 2019 16:36:41 -0600
Message-Id: <20190214223644.8035-6-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
References: <20190214223644.8035-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If a macro is in CamelCase, it it converted to upper case. Variables
and routine names are converted to lower case.

The following checkpatch exceptions are also fixed:

CHECK: No space is necessary after a cast
#211: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:109:
+                                             (u8 *) (&rfstate));

CHECK: No space is necessary after a cast
#241: FILE: drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c:277:
+                               ptmp_byte = (u8 *) (&regtoset) + index;

Note that not all checkpatch exceptions are addressed. Those will be
handled in later patches.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 .../wireless/realtek/rtlwifi/rtl8192de/dm.c   | 24 +++----
 .../wireless/realtek/rtlwifi/rtl8192de/dm.h   |  2 +-
 .../wireless/realtek/rtlwifi/rtl8192de/fw.c   | 16 ++---
 .../wireless/realtek/rtlwifi/rtl8192de/hw.c   | 66 +++++++++---------
 .../wireless/realtek/rtlwifi/rtl8192de/phy.c  | 68 +++++++++----------
 .../wireless/realtek/rtlwifi/rtl8192de/reg.h  | 28 ++++----
 6 files changed, 102 insertions(+), 102 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
index a8b81dcf9c13..100de0344432 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.c
@@ -842,7 +842,7 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 	else
 		rf = 1;
 	if (thermalvalue) {
-		ele_d = rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
+		ele_d = rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 				      MASKDWORD) & MASKOFDM_D;
 		for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {
 			if (ele_d == (ofdmswing_table[i] & MASKOFDM_D)) {
@@ -850,13 +850,13 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 
 				RT_TRACE(rtlpriv, COMP_POWER_TRACKING, DBG_LOUD,
 					 "Initial pathA ele_d reg0x%x = 0x%lx, ofdm_index=0x%x\n",
-					 ROFDM0_XATxIQIMBALANCE,
+					 ROFDM0_XATXIQIMBALANCE,
 					 ele_d, ofdm_index_old[0]);
 				break;
 			}
 		}
 		if (is2t) {
-			ele_d = rtl_get_bbreg(hw, ROFDM0_XBTxIQIMBALANCE,
+			ele_d = rtl_get_bbreg(hw, ROFDM0_XBTXIQIMBALANCE,
 					      MASKDWORD) & MASKOFDM_D;
 			for (i = 0; i < OFDM_TABLE_SIZE_92D; i++) {
 				if (ele_d ==
@@ -865,7 +865,7 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 					RT_TRACE(rtlpriv, COMP_POWER_TRACKING,
 						 DBG_LOUD,
 						 "Initial pathB ele_d reg 0x%x = 0x%lx, ofdm_index = 0x%x\n",
-						 ROFDM0_XBTxIQIMBALANCE, ele_d,
+						 ROFDM0_XBTXIQIMBALANCE, ele_d,
 						 ofdm_index_old[1]);
 					break;
 				}
@@ -1037,11 +1037,11 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 				 * regC94, element B is always 0 */
 				value32 = (ele_d << 22) | ((ele_c & 0x3F) <<
 					  16) | ele_a;
-				rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
+				rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 					      MASKDWORD, value32);
 
 				value32 = (ele_c & 0x000003C0) >> 6;
-				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, MASKH4BITS,
+				rtl_set_bbreg(hw, ROFDM0_XCTXAFE, MASKH4BITS,
 					      value32);
 
 				value32 = ((val_x * ele_d) >> 7) & 0x01;
@@ -1049,11 +1049,11 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 					      value32);
 
 			} else {
-				rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
+				rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 					      MASKDWORD,
 					      ofdmswing_table
 					      [(u8)ofdm_index[0]]);
-				rtl_set_bbreg(hw, ROFDM0_XCTxAFE, MASKH4BITS,
+				rtl_set_bbreg(hw, ROFDM0_XCTXAFE, MASKH4BITS,
 					      0x00);
 				rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 					      BIT(24), 0x00);
@@ -1150,21 +1150,21 @@ static void rtl92d_dm_txpower_tracking_callback_thermalmeter(
 						  ((ele_c & 0x3F) << 16) |
 						  ele_a;
 					rtl_set_bbreg(hw,
-						      ROFDM0_XBTxIQIMBALANCE,
+						      ROFDM0_XBTXIQIMBALANCE,
 						      MASKDWORD, value32);
 					value32 = (ele_c & 0x000003C0) >> 6;
-					rtl_set_bbreg(hw, ROFDM0_XDTxAFE,
+					rtl_set_bbreg(hw, ROFDM0_XDTXAFE,
 						      MASKH4BITS, value32);
 					value32 = ((val_x * ele_d) >> 7) & 0x01;
 					rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 						      BIT(28), value32);
 				} else {
 					rtl_set_bbreg(hw,
-						      ROFDM0_XBTxIQIMBALANCE,
+						      ROFDM0_XBTXIQIMBALANCE,
 						      MASKDWORD,
 						      ofdmswing_table
 						      [(u8) ofdm_index[1]]);
-					rtl_set_bbreg(hw, ROFDM0_XDTxAFE,
+					rtl_set_bbreg(hw, ROFDM0_XDTXAFE,
 						      MASKH4BITS, 0x00);
 					rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD,
 						      BIT(28), 0x00);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
index fb33ab1bf511..7a0bc62f0b26 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/dm.h
@@ -22,7 +22,7 @@
 #define DM_DIG_FA_TH1				0x400
 #define DM_DIG_FA_TH2				0x600
 
-#define RXPATHSELECTION_SS_TH_lOW		30
+#define RXPATHSELECTION_SS_TH_LOW		30
 #define RXPATHSELECTION_DIFF_TH			18
 
 #define DM_RATR_STA_INIT			0
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
index 910ca7e4c5ed..bfce7d4d97e7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/fw.c
@@ -75,7 +75,7 @@ static int _rtl92d_fw_free_to_go(struct ieee80211_hw *hw)
 	do {
 		value32 = rtl_read_dword(rtlpriv, REG_MCUFWDL);
 	} while ((counter++ < FW_8192D_POLLING_TIMEOUT_COUNT) &&
-		 (!(value32 & FWDL_ChkSum_rpt)));
+		 (!(value32 & FWDL_CHKSUM_RPT)));
 	if (counter >= FW_8192D_POLLING_TIMEOUT_COUNT) {
 		pr_err("chksum report fail! REG_MCUFWDL:0x%08x\n",
 		       value32);
@@ -599,7 +599,7 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 	struct sk_buff *skb = NULL;
 	u32 totalpacketlen;
 	bool rtstatus;
-	u8 u1RsvdPageLoc[3] = { 0 };
+	u8 u1rsvdpageloc[3] = { 0 };
 	bool dlok = false;
 	u8 *beacon;
 	u8 *p_pspoll;
@@ -618,7 +618,7 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 	SET_80211_PS_POLL_AID(p_pspoll, (mac->assoc_id | 0xc000));
 	SET_80211_PS_POLL_BSSID(p_pspoll, mac->bssid);
 	SET_80211_PS_POLL_TA(p_pspoll, mac->mac_addr);
-	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1RsvdPageLoc, PSPOLL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_PSPOLL(u1rsvdpageloc, PSPOLL_PG);
 	/*--------------------------------------------------------
 						(3) null data
 	---------------------------------------------------------*/
@@ -626,7 +626,7 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 	SET_80211_HDR_ADDRESS1(nullfunc, mac->bssid);
 	SET_80211_HDR_ADDRESS2(nullfunc, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(nullfunc, mac->bssid);
-	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1RsvdPageLoc, NULL_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_NULL_DATA(u1rsvdpageloc, NULL_PG);
 	/*---------------------------------------------------------
 						(4) probe response
 	----------------------------------------------------------*/
@@ -634,14 +634,14 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 	SET_80211_HDR_ADDRESS1(p_probersp, mac->bssid);
 	SET_80211_HDR_ADDRESS2(p_probersp, mac->mac_addr);
 	SET_80211_HDR_ADDRESS3(p_probersp, mac->bssid);
-	SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(u1RsvdPageLoc, PROBERSP_PG);
+	SET_H2CCMD_RSVDPAGE_LOC_PROBE_RSP(u1rsvdpageloc, PROBERSP_PG);
 	totalpacketlen = TOTAL_RESERVED_PKT_LEN;
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_LOUD,
 		      "rtl92d_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL",
 		      &reserved_page_packet[0], totalpacketlen);
 	RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
 		      "rtl92d_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL",
-		      u1RsvdPageLoc, 3);
+		      u1rsvdpageloc, 3);
 	skb = dev_alloc_skb(totalpacketlen);
 	if (!skb) {
 		dlok = false;
@@ -656,9 +656,9 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 			 "Set RSVD page location to Fw\n");
 		RT_PRINT_DATA(rtlpriv, COMP_CMD, DBG_DMESG,
-			      "H2C_RSVDPAGE", u1RsvdPageLoc, 3);
+			      "H2C_RSVDPAGE", u1rsvdpageloc, 3);
 		rtl92d_fill_h2c_cmd(hw, H2C_RSVDPAGE,
-			sizeof(u1RsvdPageLoc), u1RsvdPageLoc);
+			sizeof(u1rsvdpageloc), u1rsvdpageloc);
 	} else
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Set RSVD page location to Fw FAIL!!!!!!\n");
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
index 9797caee4856..7791b7bad9c7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/hw.c
@@ -102,12 +102,12 @@ void rtl92de_get_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 		*((enum rf_pwrstate *)(val)) = ppsc->rfpwr_state;
 		break;
 	case HW_VAR_FWLPS_RF_ON:{
-		enum rf_pwrstate rfState;
+		enum rf_pwrstate rfstate;
 		u32 val_rcr;
 
 		rtlpriv->cfg->ops->get_hw_reg(hw, HW_VAR_RF_STATE,
-					      (u8 *) (&rfState));
-		if (rfState == ERFOFF) {
+					      (u8 *)(&rfstate));
+		if (rfstate == ERFOFF) {
 			*((bool *) (val)) = true;
 		} else {
 			val_rcr = rtl_read_dword(rtlpriv, REG_RCR);
@@ -258,23 +258,23 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 	}
 	case HW_VAR_AMPDU_FACTOR: {
 		u8 factor_toset;
-		u32 regtoSet;
+		u32 regtoset;
 		u8 *ptmp_byte = NULL;
 		u8 index;
 
 		if (rtlhal->macphymode == DUALMAC_DUALPHY)
-			regtoSet = 0xb9726641;
+			regtoset = 0xb9726641;
 		else if (rtlhal->macphymode == DUALMAC_SINGLEPHY)
-			regtoSet = 0x66626641;
+			regtoset = 0x66626641;
 		else
-			regtoSet = 0xb972a841;
+			regtoset = 0xb972a841;
 		factor_toset = *val;
 		if (factor_toset <= 3) {
 			factor_toset = (1 << (factor_toset + 2));
 			if (factor_toset > 0xf)
 				factor_toset = 0xf;
 			for (index = 0; index < 4; index++) {
-				ptmp_byte = (u8 *) (&regtoSet) + index;
+				ptmp_byte = (u8 *)(&regtoset) + index;
 				if ((*ptmp_byte & 0xf0) >
 				    (factor_toset << 4))
 					*ptmp_byte = (*ptmp_byte & 0x0f)
@@ -283,7 +283,7 @@ void rtl92de_set_hw_reg(struct ieee80211_hw *hw, u8 variable, u8 *val)
 					*ptmp_byte = (*ptmp_byte & 0xf0)
 						     | (factor_toset);
 			}
-			rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, regtoSet);
+			rtl_write_dword(rtlpriv, REG_AGGLEN_LMT, regtoset);
 			RT_TRACE(rtlpriv, COMP_MLME, DBG_LOUD,
 				 "Set HW_VAR_AMPDU_FACTOR: %#x\n",
 				 factor_toset);
@@ -509,18 +509,18 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	unsigned short i;
 	u8 txpktbuf_bndy;
-	u8 maxPage;
+	u8 maxpage;
 	bool status;
 	u32 value32; /* High+low page number */
 	u8 value8;	 /* normal page number */
 
 	if (rtlpriv->rtlhal.macphymode == SINGLEMAC_SINGLEPHY) {
-		maxPage = 255;
+		maxpage = 255;
 		txpktbuf_bndy = 246;
 		value8 = 0;
 		value32 = 0x80bf0d29;
 	} else {
-		maxPage = 127;
+		maxpage = 127;
 		txpktbuf_bndy = 123;
 		value8 = 0;
 		value32 = 0x80750005;
@@ -576,14 +576,14 @@ static bool _rtl92de_llt_table_init(struct ieee80211_hw *hw)
 	/* This ring buffer is used as beacon buffer if we */
 	/* config this MAC as two MAC transfer. */
 	/* Otherwise used as local loopback buffer.  */
-	for (i = txpktbuf_bndy; i < maxPage; i++) {
+	for (i = txpktbuf_bndy; i < maxpage; i++) {
 		status = _rtl92de_llt_write(hw, i, (i + 1));
 		if (true != status)
 			return status;
 	}
 
 	/* Let last entry point to the start entry of ring buffer */
-	status = _rtl92de_llt_write(hw, maxPage, txpktbuf_bndy);
+	status = _rtl92de_llt_write(hw, maxpage, txpktbuf_bndy);
 	if (true != status)
 		return status;
 
@@ -1393,13 +1393,13 @@ void rtl92de_update_interrupt_mask(struct ieee80211_hw *hw,
 }
 
 static void _rtl92de_readpowervalue_fromprom(struct txpower_info *pwrinfo,
-				 u8 *rom_content, bool autoLoadfail)
+				 u8 *rom_content, bool autoloadfail)
 {
 	u32 rfpath, eeaddr, group, offset1, offset2;
 	u8 i;
 
 	memset(pwrinfo, 0, sizeof(struct txpower_info));
-	if (autoLoadfail) {
+	if (autoloadfail) {
 		for (group = 0; group < CHANNEL_GROUP_MAX; group++) {
 			for (rfpath = 0; rfpath < RF6052_MAX_PATH; rfpath++) {
 				if (group < CHANNEL_GROUP_MAX_2G) {
@@ -1541,7 +1541,7 @@ static void _rtl92de_read_txpower_info(struct ieee80211_hw *hw,
 	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
 	struct txpower_info pwrinfo;
 	u8 tempval[2], i, pwr, diff;
-	u32 ch, rfPath, group;
+	u32 ch, rfpath, group;
 
 	_rtl92de_readpowervalue_fromprom(&pwrinfo, hwinfo, autoload_fail);
 	if (!autoload_fail) {
@@ -1621,25 +1621,25 @@ static void _rtl92de_read_txpower_info(struct ieee80211_hw *hw,
 		 "Delta_IQK = 0x%x Delta_LCK = 0x%x\n",
 		 rtlefuse->delta_iqk, rtlefuse->delta_lck);
 
-	for (rfPath = 0; rfPath < RF6052_MAX_PATH; rfPath++) {
+	for (rfpath = 0; rfpath < RF6052_MAX_PATH; rfpath++) {
 		for (ch = 0; ch < CHANNEL_MAX_NUMBER; ch++) {
 			group = rtl92d_get_chnlgroup_fromarray((u8) ch);
 			if (ch < CHANNEL_MAX_NUMBER_2G)
-				rtlefuse->txpwrlevel_cck[rfPath][ch] =
-				    pwrinfo.cck_index[rfPath][group];
-			rtlefuse->txpwrlevel_ht40_1s[rfPath][ch] =
-				    pwrinfo.ht40_1sindex[rfPath][group];
-			rtlefuse->txpwr_ht20diff[rfPath][ch] =
-				    pwrinfo.ht20indexdiff[rfPath][group];
-			rtlefuse->txpwr_legacyhtdiff[rfPath][ch] =
-				    pwrinfo.ofdmindexdiff[rfPath][group];
-			rtlefuse->pwrgroup_ht20[rfPath][ch] =
-				    pwrinfo.ht20maxoffset[rfPath][group];
-			rtlefuse->pwrgroup_ht40[rfPath][ch] =
-				    pwrinfo.ht40maxoffset[rfPath][group];
-			pwr = pwrinfo.ht40_1sindex[rfPath][group];
-			diff = pwrinfo.ht40_2sindexdiff[rfPath][group];
-			rtlefuse->txpwrlevel_ht40_2s[rfPath][ch] =
+				rtlefuse->txpwrlevel_cck[rfpath][ch] =
+				    pwrinfo.cck_index[rfpath][group];
+			rtlefuse->txpwrlevel_ht40_1s[rfpath][ch] =
+				    pwrinfo.ht40_1sindex[rfpath][group];
+			rtlefuse->txpwr_ht20diff[rfpath][ch] =
+				    pwrinfo.ht20indexdiff[rfpath][group];
+			rtlefuse->txpwr_legacyhtdiff[rfpath][ch] =
+				    pwrinfo.ofdmindexdiff[rfpath][group];
+			rtlefuse->pwrgroup_ht20[rfpath][ch] =
+				    pwrinfo.ht20maxoffset[rfpath][group];
+			rtlefuse->pwrgroup_ht40[rfpath][ch] =
+				    pwrinfo.ht40maxoffset[rfpath][group];
+			pwr = pwrinfo.ht40_1sindex[rfpath][group];
+			diff = pwrinfo.ht40_2sindexdiff[rfpath][group];
+			rtlefuse->txpwrlevel_ht40_2s[rfpath][ch] =
 				    (pwr > diff) ? (pwr - diff) : 0;
 		}
 	}
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
index 4849f2368c14..e46efc5e3a4e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/phy.c
@@ -484,16 +484,16 @@ static void _rtl92d_phy_init_bb_rf_register_definition(struct ieee80211_hw *hw)
 	rtlphy->phyreg_def[RF90_PATH_D].rfrx_afe = ROFDM0_XDRXAFE;
 
 	/* Tx AFE control 1 */
-	rtlphy->phyreg_def[RF90_PATH_A].rftxiq_imbal = ROFDM0_XATxIQIMBALANCE;
-	rtlphy->phyreg_def[RF90_PATH_B].rftxiq_imbal = ROFDM0_XBTxIQIMBALANCE;
-	rtlphy->phyreg_def[RF90_PATH_C].rftxiq_imbal = ROFDM0_XCTxIQIMBALANCE;
-	rtlphy->phyreg_def[RF90_PATH_D].rftxiq_imbal = ROFDM0_XDTxIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_A].rftxiq_imbal = ROFDM0_XATXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_B].rftxiq_imbal = ROFDM0_XBTXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_C].rftxiq_imbal = ROFDM0_XCTXIQIMBALANCE;
+	rtlphy->phyreg_def[RF90_PATH_D].rftxiq_imbal = ROFDM0_XDTXIQIMBALANCE;
 
 	/* Tx AFE control 2 */
-	rtlphy->phyreg_def[RF90_PATH_A].rftx_afe = ROFDM0_XATxAFE;
-	rtlphy->phyreg_def[RF90_PATH_B].rftx_afe = ROFDM0_XBTxAFE;
-	rtlphy->phyreg_def[RF90_PATH_C].rftx_afe = ROFDM0_XCTxAFE;
-	rtlphy->phyreg_def[RF90_PATH_D].rftx_afe = ROFDM0_XDTxAFE;
+	rtlphy->phyreg_def[RF90_PATH_A].rftx_afe = ROFDM0_XATXAFE;
+	rtlphy->phyreg_def[RF90_PATH_B].rftx_afe = ROFDM0_XBTXAFE;
+	rtlphy->phyreg_def[RF90_PATH_C].rftx_afe = ROFDM0_XCTXAFE;
+	rtlphy->phyreg_def[RF90_PATH_D].rftx_afe = ROFDM0_XDTXAFE;
 
 	/* Tranceiver LSSI Readback SI mode */
 	rtlphy->phyreg_def[RF90_PATH_A].rf_rb = RFPGA0_XA_LSSIREADBACK;
@@ -742,7 +742,7 @@ bool rtl92d_phy_bb_config(struct ieee80211_hw *hw)
 	rtl_write_byte(rtlpriv, REG_RF_CTRL, value | RF_EN | RF_RSTB |
 		RF_SDMRSTB);
 	rtl_write_byte(rtlpriv, REG_SYS_FUNC_EN, FEN_PPLL | FEN_PCIEA |
-		FEN_DIO_PCIE | FEN_BB_GLB_RSTn | FEN_BBRSTB);
+		FEN_DIO_PCIE | FEN_BB_GLB_RSTN | FEN_BBRSTB);
 	rtl_write_byte(rtlpriv, REG_AFE_XTAL_CTRL + 1, 0x80);
 	if (!(IS_92D_SINGLEPHY(rtlpriv->rtlhal.version))) {
 		regvaldw = rtl_read_dword(rtlpriv, REG_LEDCFG0);
@@ -1458,11 +1458,11 @@ static u8 _rtl92d_phy_patha_iqk_5g_normal(struct ieee80211_hw *hw,
 	u8 result = 0;
 	u8 i;
 	u8 retrycount = 2;
-	u32 TxOKBit = BIT(28), RxOKBit = BIT(27);
+	u32 TXOKBIT = BIT(28), RXOKBIT = BIT(27);
 
 	if (rtlhal->interfaceindex == 1) {	/* PHY1 */
-		TxOKBit = BIT(31);
-		RxOKBit = BIT(30);
+		TXOKBIT = BIT(31);
+		RXOKBIT = BIT(30);
 	}
 	RTPRINT(rtlpriv, FINIT, INIT_IQK,  "Path A IQK!\n");
 	/* path-A IQK setting */
@@ -1504,7 +1504,7 @@ static u8 _rtl92d_phy_patha_iqk_5g_normal(struct ieee80211_hw *hw,
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xe9c = 0x%x\n", rege9c);
 		regea4 = rtl_get_bbreg(hw, 0xea4, MASKDWORD);
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,  "0xea4 = 0x%x\n", regea4);
-		if (!(regeac & TxOKBit) &&
+		if (!(regeac & TXOKBIT) &&
 		     (((rege94 & 0x03FF0000) >> 16) != 0x142)) {
 			result |= 0x01;
 		} else { /* if Tx not OK, ignore Rx */
@@ -1514,7 +1514,7 @@ static u8 _rtl92d_phy_patha_iqk_5g_normal(struct ieee80211_hw *hw,
 		}
 
 		/* if Tx is OK, check whether Rx is OK */
-		if (!(regeac & RxOKBit) &&
+		if (!(regeac & RXOKBIT) &&
 		    (((regea4 & 0x03FF0000) >> 16) != 0x132)) {
 			result |= 0x02;
 			break;
@@ -2143,7 +2143,7 @@ static void _rtl92d_phy_patha_fill_iqk_matrix(struct ieee80211_hw *hw,
 	if (final_candidate == 0xFF) {
 		return;
 	} else if (iqk_ok) {
-		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
+		oldval_0 = (rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 			MASKDWORD) >> 22) & 0x3FF;	/* OFDM0_D */
 		val_x = result[final_candidate][0];
 		if ((val_x & 0x00000200) != 0)
@@ -2152,7 +2152,7 @@ static void _rtl92d_phy_patha_fill_iqk_matrix(struct ieee80211_hw *hw,
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"X = 0x%x, tx0_a = 0x%x, oldval_0 0x%x\n",
 			val_x, tx0_a, oldval_0);
-		rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, 0x3FF, tx0_a);
+		rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE, 0x3FF, tx0_a);
 		rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(24),
 			      ((val_x * oldval_0 >> 7) & 0x1));
 		val_y = result[final_candidate][1];
@@ -2166,15 +2166,15 @@ static void _rtl92d_phy_patha_fill_iqk_matrix(struct ieee80211_hw *hw,
 		RTPRINT(rtlpriv, FINIT, INIT_IQK,
 			"Y = 0x%lx, tx0_c = 0x%lx\n",
 			val_y, tx0_c);
-		rtl_set_bbreg(hw, ROFDM0_XCTxAFE, 0xF0000000,
+		rtl_set_bbreg(hw, ROFDM0_XCTXAFE, 0xF0000000,
 			      ((tx0_c & 0x3C0) >> 6));
-		rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, 0x003F0000,
+		rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE, 0x003F0000,
 			      (tx0_c & 0x3F));
 		if (is2t)
 			rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(26),
 				      ((val_y * oldval_0 >> 7) & 0x1));
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "0xC80 = 0x%x\n",
-			rtl_get_bbreg(hw, ROFDM0_XATxIQIMBALANCE,
+			rtl_get_bbreg(hw, ROFDM0_XATXIQIMBALANCE,
 				      MASKDWORD));
 		if (txonly) {
 			RTPRINT(rtlpriv, FINIT, INIT_IQK,  "only Tx OK\n");
@@ -2202,7 +2202,7 @@ static void _rtl92d_phy_pathb_fill_iqk_matrix(struct ieee80211_hw *hw,
 	if (final_candidate == 0xFF) {
 		return;
 	} else if (iqk_ok) {
-		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTxIQIMBALANCE,
+		oldval_1 = (rtl_get_bbreg(hw, ROFDM0_XBTXIQIMBALANCE,
 					  MASKDWORD) >> 22) & 0x3FF;
 		val_x = result[final_candidate][4];
 		if ((val_x & 0x00000200) != 0)
@@ -2210,7 +2210,7 @@ static void _rtl92d_phy_pathb_fill_iqk_matrix(struct ieee80211_hw *hw,
 		tx1_a = (val_x * oldval_1) >> 8;
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "X = 0x%x, tx1_a = 0x%x\n",
 			val_x, tx1_a);
-		rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, 0x3FF, tx1_a);
+		rtl_set_bbreg(hw, ROFDM0_XBTXIQIMBALANCE, 0x3FF, tx1_a);
 		rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(28),
 			      ((val_x * oldval_1 >> 7) & 0x1));
 		val_y = result[final_candidate][5];
@@ -2221,9 +2221,9 @@ static void _rtl92d_phy_pathb_fill_iqk_matrix(struct ieee80211_hw *hw,
 		tx1_c = (val_y * oldval_1) >> 8;
 		RTPRINT(rtlpriv, FINIT, INIT_IQK, "Y = 0x%lx, tx1_c = 0x%lx\n",
 			val_y, tx1_c);
-		rtl_set_bbreg(hw, ROFDM0_XDTxAFE, 0xF0000000,
+		rtl_set_bbreg(hw, ROFDM0_XDTXAFE, 0xF0000000,
 			      ((tx1_c & 0x3C0) >> 6));
-		rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, 0x003F0000,
+		rtl_set_bbreg(hw, ROFDM0_XBTXIQIMBALANCE, 0x003F0000,
 			      (tx1_c & 0x3F));
 		rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(30),
 			      ((val_y * oldval_1 >> 7) & 0x1));
@@ -3064,13 +3064,13 @@ bool rtl92d_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		if ((ppsc->rfpwr_state == ERFOFF) &&
 		    RT_IN_PS_LEVEL(ppsc, RT_RF_OFF_LEVL_HALT_NIC)) {
 			bool rtstatus;
-			u32 InitializeCount = 0;
+			u32 initializecount = 0;
 			do {
-				InitializeCount++;
+				initializecount++;
 				RT_TRACE(rtlpriv, COMP_RF, DBG_DMESG,
 					 "IPS Set eRf nic enable\n");
 				rtstatus = rtl_ps_enable_nic(hw);
-			} while (!rtstatus && (InitializeCount < 10));
+			} while (!rtstatus && (initializecount < 10));
 
 			RT_CLEAR_PS_LEVEL(ppsc,
 					  RT_RF_OFF_LEVL_HALT_NIC);
@@ -3365,9 +3365,9 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 		/* 5G LAN ON */
 		rtl_set_bbreg(hw, 0xB30, 0x00F00000, 0xa);
 		/* TX BB gain shift*1,Just for testchip,0xc80,0xc88 */
-		rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
+		rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE, MASKDWORD,
 			      0x40000100);
-		rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
+		rtl_set_bbreg(hw, ROFDM0_XBTXIQIMBALANCE, MASKDWORD,
 			      0x40000100);
 		if (rtlhal->macphymode == DUALMAC_DUALPHY) {
 			rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW,
@@ -3421,16 +3421,16 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 		rtl_set_bbreg(hw, 0xB30, 0x00F00000, 0x0);
 		/* TX BB gain shift,Just for testchip,0xc80,0xc88 */
 		if (rtlefuse->internal_pa_5g[0])
-			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE, MASKDWORD,
 				      0x2d4000b5);
 		else
-			rtl_set_bbreg(hw, ROFDM0_XATxIQIMBALANCE, MASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XATXIQIMBALANCE, MASKDWORD,
 				      0x20000080);
 		if (rtlefuse->internal_pa_5g[1])
-			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XBTXIQIMBALANCE, MASKDWORD,
 				      0x2d4000b5);
 		else
-			rtl_set_bbreg(hw, ROFDM0_XBTxIQIMBALANCE, MASKDWORD,
+			rtl_set_bbreg(hw, ROFDM0_XBTXIQIMBALANCE, MASKDWORD,
 				      0x20000080);
 		if (rtlhal->macphymode == DUALMAC_DUALPHY) {
 			rtl_set_bbreg(hw, RFPGA0_XAB_RFINTERFACESW,
@@ -3459,10 +3459,10 @@ void rtl92d_update_bbrf_configuration(struct ieee80211_hw *hw)
 	/* update IQK related settings */
 	rtl_set_bbreg(hw, ROFDM0_XARXIQIMBALANCE, MASKDWORD, 0x40000100);
 	rtl_set_bbreg(hw, ROFDM0_XBRXIQIMBALANCE, MASKDWORD, 0x40000100);
-	rtl_set_bbreg(hw, ROFDM0_XCTxAFE, 0xF0000000, 0x00);
+	rtl_set_bbreg(hw, ROFDM0_XCTXAFE, 0xF0000000, 0x00);
 	rtl_set_bbreg(hw, ROFDM0_ECCATHRESHOLD, BIT(30) | BIT(28) |
 		      BIT(26) | BIT(24), 0x00);
-	rtl_set_bbreg(hw, ROFDM0_XDTxAFE, 0xF0000000, 0x00);
+	rtl_set_bbreg(hw, ROFDM0_XDTXAFE, 0xF0000000, 0x00);
 	rtl_set_bbreg(hw, 0xca0, 0xF0000000, 0x00);
 	rtl_set_bbreg(hw, ROFDM0_AGCRSSITABLE, 0x0000F000, 0x00);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
index b040cca66041..af1d686f8785 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192de/reg.h
@@ -730,7 +730,7 @@
 
 /* SYS_FUNC_EN */
 #define FEN_BBRSTB				BIT(0)
-#define FEN_BB_GLB_RSTn				BIT(1)
+#define FEN_BB_GLB_RSTN				BIT(1)
 #define FEN_USBA				BIT(2)
 #define FEN_UPLL				BIT(3)
 #define FEN_USBD				BIT(4)
@@ -751,7 +751,7 @@
 #define PFM_ALDN				BIT(1)
 #define PFM_LDKP				BIT(2)
 #define PFM_WOWL				BIT(3)
-#define EnPDN					BIT(4)
+#define ENPDN					BIT(4)
 #define PDN_PL					BIT(5)
 #define APFM_ONMAC				BIT(8)
 #define APFM_OFF				BIT(9)
@@ -888,7 +888,7 @@
 /* MCUFWDL  */
 #define MCUFWDL_EN				BIT(0)
 #define MCUFWDL_RDY				BIT(1)
-#define FWDL_ChkSum_rpt				BIT(2)
+#define FWDL_CHKSUM_RPT				BIT(2)
 #define MACINI_RDY				BIT(3)
 #define BBINI_RDY				BIT(4)
 #define RFINI_RDY				BIT(5)
@@ -1011,7 +1011,7 @@
 #define	RFPGA0_XA_LSSIPARAMETER			0x840
 #define	RFPGA0_XB_LSSIPARAMETER			0x844
 
-#define	RFPGA0_RFWAkEUPPARAMETER		0x850
+#define	RFPGA0_RFWAKEUPPARAMETER		0x850
 #define	RFPGA0_RFSLEEPUPPARAMETER		0x854
 
 #define	RFPGA0_XAB_SWITCHCONTROL		0x858
@@ -1113,14 +1113,14 @@
 #define	ROFDM0_AGCRSSITABLE			0xc78
 #define	ROFDM0_HTSTFAGC				0xc7c
 
-#define	ROFDM0_XATxIQIMBALANCE			0xc80
-#define	ROFDM0_XATxAFE				0xc84
-#define	ROFDM0_XBTxIQIMBALANCE			0xc88
-#define	ROFDM0_XBTxAFE				0xc8c
-#define	ROFDM0_XCTxIQIMBALANCE			0xc90
-#define	ROFDM0_XCTxAFE				0xc94
-#define	ROFDM0_XDTxIQIMBALANCE			0xc98
-#define	ROFDM0_XDTxAFE				0xc9c
+#define	ROFDM0_XATXIQIMBALANCE			0xc80
+#define	ROFDM0_XATXAFE				0xc84
+#define	ROFDM0_XBTXIQIMBALANCE			0xc88
+#define	ROFDM0_XBTXAFE				0xc8c
+#define	ROFDM0_XCTXIQIMBALANCE			0xc90
+#define	ROFDM0_XCTXAFE				0xc94
+#define	ROFDM0_XDTXIQIMBALANCE			0xc98
+#define	ROFDM0_XDTXAFE				0xc9c
 
 #define	ROFDM0_RXHPPARAMETER			0xce0
 #define	ROFDM0_TXPSEUDONOISEWGT			0xce4
@@ -1164,7 +1164,7 @@
 #define	ROFDM_AGCREPORT				0xdd0
 #define	ROFDM_RXSNR				0xdd4
 #define	ROFDM_RXEVMCSI				0xdd8
-#define	ROFDM_SIGReport				0xddc
+#define	ROFDM_SIGREPORT				0xddc
 
 /* 8. PageE(0xE00) */
 #define	RTXAGC_A_RATE18_06			0xe00
@@ -1206,7 +1206,7 @@
 #define	RF_IPA					0x15
 #define	RF_POW_ABILITY				0x17
 #define	RF_MODE_AG				0x18
-#define	rRfChannel				0x18
+#define	rfchannel				0x18
 #define	RF_CHNLBW				0x18
 #define	RF_TOP					0x19
 
-- 
2.20.1

