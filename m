Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5028CC4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2178E2077B
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 19:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AjfiHWlD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfBUTb0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 14:31:26 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42230 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfBUTbZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 14:31:25 -0500
Received: by mail-ot1-f66.google.com with SMTP id i5so45893741oto.9
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 11:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QhMd5PX6rdl+FzarZ7fMPetPZhgFr5ypGiRdvQHX1t4=;
        b=AjfiHWlDSlXx17pP3MqJ8RNMzO3F3Vr37lo47kwHZsFnbIvwZungNnq6KH1f6IWwnX
         jwYoZHiPVDFJSIObgkA8CJTgYjJyocUhjDVu/jsUu5Or8z8WLR4n2ImNTr3g3dPCKVXW
         Sy+FW9ad11PYMSJc95js/fEC3v+N0QDY2/qlQpKhQjWmGnMG+GwDjy01WAekuBWAiYiQ
         +AoOfgmUVqSWs2xyQCzLH6XuQoVN351Bi5LCPYwHcUTmP1P/B+x1qKUAd0ZuvnYr9xaV
         PgzygG/E5wAb8bRskMnkX4N3AEfhLeFv8uU+xjzEUQwYUjR8ylzSKKB1pITHmIC3SJqJ
         e8Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=QhMd5PX6rdl+FzarZ7fMPetPZhgFr5ypGiRdvQHX1t4=;
        b=pUGyIGlqHowxsfgPpEydzVypZkiEPfnIqYLux/2QysW9CHXkVFxRIHW8allFAx2zvR
         Q+HhjxLL5avJhWRW7ILSi87/H0YKoGgPTM32hTerGkbipRH7mTdC80JA7xN9/MWiOcMK
         KtdkzdBZkjS0o7F4bh2izd+MYhNDZzqvnoShVIka2FqSyUP0dVfeWHh6uHUiCXeC3y0Q
         DNuNpmr01IGYcfI97Rq5FITFPN7XDVDis3wsP80fn5hQHBzqmy80TEZ0pHWSGUFY4crk
         MYdeBPf8AuhwMAa0wQfyyEOfal3EDfEjE4EXo3FtldHHAWFBTmDQiVQbd2uxmdeRe7Vn
         V/AQ==
X-Gm-Message-State: AHQUAuZP5tZsYOYL4hMG5hlpIObLo7dtY2FV/ey1xLU990o5/zBiCCmV
        vGkKL2nF56HORZ2cJDkJj+pa0cOF
X-Google-Smtp-Source: AHgI3IbtiKEDF/ZHfguSBe4VGI9Ep+aunYHTnFhGq+GY8LiK09NYhdBzBGfOl8ZkVuY0rQN+9sNw5w==
X-Received: by 2002:a9d:75d6:: with SMTP id c22mr148023otl.46.1550777484573;
        Thu, 21 Feb 2019 11:31:24 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id o16sm9495500otl.22.2019.02.21.11.31.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 11:31:23 -0800 (PST)
From:   Larry Finger <Larry.Finger@lwfinger.net>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, pkshih@realtek.com,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4/8] rtlwifi: Fix blank line errors in main header files
Date:   Thu, 21 Feb 2019 13:31:11 -0600
Message-Id: <20190221193115.30848-5-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
References: <20190221193115.30848-1-Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The errors consist of multiple blank lines, and a missing blank line
after the declarations.

There are no code changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/realtek/rtlwifi/usb.h  | 5 +----
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 4 +---
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.h b/drivers/net/wireless/realtek/rtlwifi/usb.h
index 09bbcdbe0dbf..3bf85b23eec1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.h
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.h
@@ -17,7 +17,6 @@
 #define USB_HIGH_SPEED_BULK_SIZE	512
 #define USB_FULL_SPEED_BULK_SIZE	64
 
-
 #define RTL_USB_MAX_TXQ_NUM		4		/* max tx queue */
 #define RTL_USB_MAX_EP_NUM		6		/* max ep number */
 #define RTL_USB_MAX_TX_URBS_NUM		8
@@ -53,11 +52,11 @@ static inline void _rtl_install_trx_info(struct rtl_usb *rtlusb,
 					 u32 ep_num)
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
 	info->rate_driver_data[0] = rtlusb;
 	info->rate_driver_data[1] = (void *)(__kernel_size_t)ep_num;
 }
 
-
 /*  Add suspend/resume later */
 enum rtl_usb_state {
 	USB_STATE_STOP	= 0,
@@ -133,8 +132,6 @@ struct rtl_usb_priv {
 #define rtl_usbpriv(hw)	 (((struct rtl_usb_priv *)(rtl_priv(hw))->priv))
 #define rtl_usbdev(usbpriv)	(&((usbpriv)->dev))
 
-
-
 int rtl_usb_probe(struct usb_interface *intf,
 		  const struct usb_device_id *id,
 		  struct rtl_hal_cfg *rtl92cu_hal_cfg);
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index 88f94662c072..e32e9ffa3192 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2143,7 +2143,6 @@ struct rtl_stats {
 	u32 macid_valid_entry[2];
 };
 
-
 struct rt_link_detect {
 	/* count for roaming */
 	u32 bcn_rx_inperiod;
@@ -2843,7 +2842,6 @@ struct rtl_priv {
 #define rtl_efuse(rtlpriv)	(&((rtlpriv)->efuse))
 #define rtl_psc(rtlpriv)	(&((rtlpriv)->psc))
 
-
 /* Bluetooth Co-existence Related */
 
 enum bt_ant_num {
@@ -2893,7 +2891,6 @@ enum bt_radio_shared {
 	BT_RADIO_INDIVIDUAL = 1,
 };
 
-
 /****************************************
  *	mem access macro define start
  *	Call endian free function when
@@ -3229,6 +3226,7 @@ static inline struct ieee80211_sta *rtl_find_sta(struct ieee80211_hw *hw,
 						 u8 *mac_addr)
 {
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
+
 	return ieee80211_find_sta(mac->vif, mac_addr);
 }
 
-- 
2.20.1

