Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 049C8C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B87292077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TmwjCog4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfBUTbY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:24 -0500
Received: from mail-ot1-f68.google.com ([209.85.210.68]:39218 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfBUTbX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:23 -0500
Received: by mail-ot1-f68.google.com with SMTP id n8so45932060otl.6
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I1WY+KWw/8wp+M4SBY01YsbKWBtra1kTSH/W/Mw/reo=;
        b=TmwjCog4QrNMuF+gIYLfb8vKEbAStvnnYJbN+W10NDtN/vYIlrNogwRA4aos+RM+bT
         tqtu7OC5kAO3EAtNMlXWJOM7oty7F2+bB/ozIW+CmB3XYnaOasK7keQr0Wcz8jUUJC5C
         pSh+zPrinIZ5PtMz/cpgR9RaRur4W+oE6q2Jw6pNRh279bYDgM4G+J75a4hrp4kBiI7u
         yHwZm3OloBnd8hQLkfDWnnNrzWQZ1+SL1dIxONAho9Yo2JAnGxwIi3zecJvHrrjR6vX4
         RJVOi2xJR9Y30cN7vhnUQ+UQT6PIOAO6x/TRp5fJoaceMbOlZChwxe014N8WuM+F2/Th
         zSFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=I1WY+KWw/8wp+M4SBY01YsbKWBtra1kTSH/W/Mw/reo=;
        b=l+ktihHEt/DaS0H225Jyc4qNAmnpYkGPxB62RVuuJ7glIyU/aQuYJuxQhfOoH6MEL3
         4t4oj2GeDt/nm3GWy1B6+io/YwQyZ0XRUVQGZiUAnVnsM0qGJyR2hIGXYLdD9LAQ5Ant
         mVyen9df9hiRHr6FHE2dyxxyReFqK4bXKkrrBbFIoQPAcYR0+gmMEc6sQdeOjI6N89r+
         /Y2uP0rnHjYSSvSwEujAc/9YKKmbjbjJC60LHyd3hLcii8fz/Y0Kex8MpQfNm7D0dMr9
         tjL5FUkzTV7fTbk4a+WK444+BonSkf+l4CZnPIci9HI07kBdx49sjwpPkvDFvDDKiwW5
         WuKQ==
X-Gm-Message-State: AHQUAua91iBO+D6WFchyTqk4w5ZlrO7r3UavYSjvDvWIIr0g42rF4kSg
        Ek8nyL4uoRJIDL1GGQNm54A=
X-Google-Smtp-Source: AHgI3IYXAARMgJJeVQC6trQDSx3fGBeRXaeA34uaPPFx9JlZodO0gp065Q3n4jLLMIierY3jtojZyQ==
X-Received: by 2002:a05:6830:20da:: with SMTP id z26mr132755otq.204.1550777482640;
        Thu, 21 Feb 2019 11:31:22 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:21 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/8] rtlwifi: Fix problems with block comments in wifi.h
Date:   Thu, 21 Feb 2019 13:31:09 -0600
Message-Id: <20190221193115.30848-3-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Checkpatch.pl reports a number of problems with block comments.

These changes do not affect the generated code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 93 +++++++++++----------
 1 file changed, 50 insertions(+), 43 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 858cd798d5cb..9fe137fa5ead 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -598,7 +598,8 @@ enum ht_channel_width {
 };
 
 /* Ref: 802.11i sepc D10.0 7.3.2.25.1
-Cipher Suites Encryption Algorithms */
+ * Cipher Suites Encryption Algorithms
+ */
 enum rt_enc_alg {
 	NO_ENCRYPTION = 0,
 	WEP40_ENCRYPTION = 1,
@@ -748,7 +749,8 @@ enum rtl_var_map {
 	RTL_IMR_ROK,		/*Receive DMA OK Interrupt */
 	RTL_IMR_HSISR_IND,	/*HSISR Interrupt*/
 	RTL_IBSS_INT_MASKS,	/*(RTL_IMR_BCNINT | RTL_IMR_TBDOK |
-				 * RTL_IMR_TBDER) */
+				 * RTL_IMR_TBDER)
+				 */
 	RTL_IMR_C2HCMD,		/*fw interrupt*/
 
 	/*CCK Rates, TxHT = 0 */
@@ -845,8 +847,9 @@ enum band_type {
 	BANDMAX
 };
 
-/*aci/aifsn Field.
-Ref: WMM spec 2.2.2: WME Parameter Element, p.12.*/
+/* aci/aifsn Field.
+ * Ref: WMM spec 2.2.2: WME Parameter Element, p.12.
+ */
 union aci_aifsn {
 	u8 char_data;
 
@@ -1062,7 +1065,8 @@ struct rtl_probe_rsp {
 	__le16 beacon_interval;
 	__le16 capability;
 	/*SSID, supported rates, FH params, DS params,
-	   CF params, IBSS params, TIM (if beacon), RSN */
+	 * CF params, IBSS params, TIM (if beacon), RSN
+	 */
 	struct rtl_info_element info_element[0];
 } __packed;
 
@@ -1136,7 +1140,8 @@ struct wireless_stats {
 
 	long rx_snr_db[4];
 	/*Correct smoothed ss in Dbm, only used
-	   in driver to report real power now. */
+	 * in driver to report real power now.
+	 */
 	long recv_signal_power;
 	long signal_quality;
 	long last_sigstrength_inpercent;
@@ -1144,8 +1149,9 @@ struct wireless_stats {
 	u32 rssi_calculate_cnt;
 	u32 pwdb_all_cnt;
 
-	/*Transformed, in dbm. Beautified signal
-	   strength for UI, not correct. */
+	/* Transformed, in dbm. Beautified signal
+	 * strength for UI, not correct.
+	 */
 	long signal_strength;
 
 	u8 rx_rssi_percentage[4];
@@ -1689,7 +1695,8 @@ struct rtl_hal {
 	bool during_mac1init_radioa;
 	bool reloadtxpowerindex;
 	/* True if IMR or IQK  have done
-	for 2.4G in scan progress */
+	 * for 2.4G in scan progress
+	 */
 	bool load_imrandiqk_setting_for2g;
 
 	bool disable_amsdu_8k;
@@ -1728,12 +1735,14 @@ struct rtl_security {
 	u32 hwsec_cam_bitmap;
 	u8 hwsec_cam_sta_addr[TOTAL_CAM_ENTRY][ETH_ALEN];
 	/*local Key buffer, indx 0 is for
-	   pairwise key 1-4 is for agoup key. */
+	 * pairwise key 1-4 is for agoup key.
+	 */
 	u8 key_buf[KEY_BUF_SIZE][MAX_KEY_LEN];
 	u8 key_len[KEY_BUF_SIZE];
 
 	/*The pointer of Pairwise Key,
-	   it always points to KeyBuf[4] */
+	 * it always points to KeyBuf[4]
+	 */
 	u8 *pairwise_key;
 };
 
@@ -1997,11 +2006,10 @@ struct rtl_ps_ctl {
 	bool rfchange_inprogress;
 	bool swrf_processing;
 	bool hwradiooff;
-	/*
-	 * just for PCIE ASPM
+	/* just for PCIE ASPM
 	 * If it supports ASPM, Offset[560h] = 0x40,
 	 * otherwise Offset[560h] = 0x00.
-	 * */
+	 */
 	bool support_aspm;
 	bool support_backdoor;
 
@@ -2081,10 +2089,9 @@ struct rtl_stats {
 	u8 nic_type;
 	u16 length;
 	u8 signalquality;	/*in 0-100 index. */
-	/*
-	 * Real power in dBm for this packet,
+	/* Real power in dBm for this packet,
 	 * no beautification and aggregation.
-	 * */
+	 */
 	s32 recvsignalpower;
 	s8 rxpower;		/*in dBm Translate from PWdB */
 	u8 signalstrength;	/*in 0-100 index. */
@@ -2425,7 +2432,8 @@ struct rtl_hal_cfg {
 	enum rtl_spec_ver spec_ver;
 
 	/*this map used for some registers or vars
-	   defined int HAL but used in MAIN */
+	 * defined int HAL but used in MAIN
+	 */
 	u32 maps[RTL_VAR_MAP_MAX];
 
 };
@@ -2587,7 +2595,8 @@ struct dig_t {
 
 struct rtl_global_var {
 	/* from this list we can get
-	 * other adapter's rtl_priv */
+	 * other adapter's rtl_priv
+	 */
 	struct list_head glb_priv_list;
 	spinlock_t glb_list_lock;
 };
@@ -2775,16 +2784,16 @@ struct rtl_priv {
 	struct rtl_debug dbg;
 	int max_fw_size;
 
-	/*
-	 *hal_cfg : for diff cards
-	 *intf_ops : for diff interrface usb/pcie
+	/* hal_cfg : for diff cards
+	 * intf_ops : for diff interrface usb/pcie
 	 */
 	struct rtl_hal_cfg *cfg;
 	const struct rtl_intf_ops *intf_ops;
 
-	/*this var will be set by set_bit,
-	   and was used to indicate status of
-	   interface or hardware */
+	/* this var will be set by set_bit,
+	 * and was used to indicate status of
+	 * interface or hardware
+	 */
 	unsigned long status;
 
 	/* tables for dm */
@@ -2820,10 +2829,11 @@ struct rtl_priv {
 #ifdef CONFIG_PM
 	struct wiphy_wowlan_support wowlan;
 #endif
-	/*This must be the last item so
-	   that it points to the data allocated
-	   beyond  this structure like:
-	   rtl_pci_priv or rtl_usb_priv */
+	/* This must be the last item so
+	 * that it points to the data allocated
+	 * beyond  this structure like:
+	 * rtl_pci_priv or rtl_usb_priv
+	 */
 	u8 priv[0] __aligned(sizeof(void *));
 };
 
@@ -2834,9 +2844,7 @@ struct rtl_priv {
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
 
-/***************************************
-    Bluetooth Co-existence Related
-****************************************/
+/* Bluetooth Co-existence Related */
 
 enum bt_ant_num {
 	ANT_X2 = 0,
@@ -2887,12 +2895,12 @@ enum bt_radio_shared {
 
 
 /****************************************
-	mem access macro define start
-	Call endian free function when
-	1. Read/write packet content.
-	2. Before write integer to IO.
-	3. After read integer from IO.
-****************************************/
+ *	mem access macro define start
+ *	Call endian free function when
+ *	1. Read/write packet content.
+ *	2. Before write integer to IO.
+ *	3. After read integer from IO.
+ ****************************************/
 /* Convert little data endian to host ordering */
 #define EF1BYTE(_val)		\
 	((u8)(_val))
@@ -2948,8 +2956,9 @@ enum bt_radio_shared {
 	(EF1BYTE(*((u8 *)(__pstart))))
 
 /*Description:
-Translate subfield (continuous bits in little-endian) of 4-byte
-value to host byte ordering.*/
+ * Translate subfield (continuous bits in little-endian) of 4-byte
+ * value to host byte ordering.
+ */
 #define LE_BITS_TO_4BYTE(__pstart, __bitoffset, __bitlen) \
 	( \
 		(LE_P4BYTE_TO_HOST_4BYTE(__pstart) >> (__bitoffset))  & \
@@ -3011,9 +3020,7 @@ value to host byte ordering.*/
 #define	N_BYTE_ALIGMENT(__value, __aligment) ((__aligment == 1) ? \
 	(__value) : (((__value + __aligment - 1) / __aligment) * __aligment))
 
-/****************************************
-	mem access macro define end
-****************************************/
+/* mem access macro define end */
 
 #define byte(x, n) ((x >> (8 * n)) & 0xff)
 
-- 
2.20.1

