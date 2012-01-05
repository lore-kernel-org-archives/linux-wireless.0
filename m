Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51089 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab2AECut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Jan 2012 21:50:49 -0500
Date: Wed, 04 Jan 2012 20:50:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [PATCH] rtl8192se: Fix BUG caused by failure to check skb
 allocation
Message-ID: <4f051007.f9kZR+Kc8uuRLpnd%Larry.Finger@lwfinger.net> (sfid-20120105_035053_079670_6080C1B5)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When downloading firmware into the device, the driver fails to check the
return when allocating an skb. When the allocation fails, a BUG can be
generated, as seen in https://bugzilla.redhat.com/show_bug.cgi?id=771656.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/fw.c
@@ -196,6 +196,8 @@ static bool _rtl92s_firmware_downloadcod
 		/* Allocate skb buffer to contain firmware */
 		/* info and tx descriptor info. */
 		skb = dev_alloc_skb(frag_length);
+		if (!skb)
+			return false;
 		skb_reserve(skb, extra_descoffset);
 		seg_ptr = (u8 *)skb_put(skb, (u32)(frag_length -
 					extra_descoffset));
@@ -573,6 +575,8 @@ static bool _rtl92s_firmware_set_h2c_cmd
 
 	len = _rtl92s_get_h2c_cmdlen(MAX_TRANSMIT_BUFFER_SIZE, 1, &cmd_len);
 	skb = dev_alloc_skb(len);
+	if (!skb)
+		return false;
 	cb_desc = (struct rtl_tcb_desc *)(skb->cb);
 	cb_desc->queue_index = TXCMD_QUEUE;
 	cb_desc->cmd_or_init = DESC_PACKET_TYPE_NORMAL;
