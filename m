Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59788 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755759Ab1CRCxD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2011 22:53:03 -0400
Date: Thu, 17 Mar 2011 21:53:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192c{e,u}: Remove some extraneous casts on
 memcpy commands
Message-ID: <4d82c90d.bQjVNQLMrAA1Q+K1%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
@@ -532,9 +532,9 @@
 #define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)	\
 do {							\
 	if (_size > TX_DESC_NEXT_DESC_OFFSET)		\
-		memset((void *)__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
+		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
 	else						\
-		memset((void *)__pdesc, 0, _size);	\
+		memset(__pdesc, 0, _size);	\
 } while (0);
 
 #define RX_HAL_IS_CCK_RATE(_pdesc)\
Index: wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ wireless-testing/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -656,7 +656,7 @@ void rtl92cu_tx_fill_cmddesc(struct ieee
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
 
-	memset((void *)pdesc, 0, RTL_TX_HEADER_SIZE);
+	memset(pdesc, 0, RTL_TX_HEADER_SIZE);
 	if (firstseg)
 		SET_TX_DESC_OFFSET(pdesc, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_TX_RATE(pdesc, DESC92C_RATE1M);
