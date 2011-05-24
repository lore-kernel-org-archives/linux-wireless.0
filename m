Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59057 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab1EXBhe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2011 21:37:34 -0400
Date: Mon, 23 May 2011 20:37:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: rtl8192se: Use write barrier when assigning
 ownership
Message-ID: <4ddb0bdb.qErEkJae92tliW/d%Larry.Finger@lwfinger.net> (sfid-20110524_033738_104953_1D806E73)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As noted by Mike McCormack <mikem@ring3k.org> for rtl8192ce, make sure
all updates to a descriptor are flushed to memory before assigning ownship
to hardware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -873,6 +873,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee
 		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
 		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
 
+		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
 	} else { /* H2C Command Desc format (Host TXCMD) */
 		/* 92SE must set as 1 for firmware download HW DMA error */
@@ -891,6 +892,7 @@ void rtl92se_tx_fill_cmddesc(struct ieee
 		SET_TX_DESC_TX_BUFFER_SIZE(pdesc, (u16)(skb->len));
 		SET_TX_DESC_TX_BUFFER_ADDRESS(pdesc, cpu_to_le32(mapping));
 
+		wmb();
 		SET_TX_DESC_OWN(pdesc, 1);
 
 	}
@@ -901,6 +903,7 @@ void rtl92se_set_desc(u8 *pdesc, bool is
 	if (istx == true) {
 		switch (desc_name) {
 		case HW_DESC_OWN:
+			wmb();
 			SET_TX_DESC_OWN(pdesc, 1);
 			break;
 		case HW_DESC_TX_NEXTDESC_ADDR:
@@ -914,6 +917,7 @@ void rtl92se_set_desc(u8 *pdesc, bool is
 	} else {
 		switch (desc_name) {
 		case HW_DESC_RXOWN:
+			wmb();
 			SET_RX_STATUS_DESC_OWN(pdesc, 1);
 			break;
 		case HW_DESC_RXBUFF_ADDR:
