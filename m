Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35948 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933163Ab1ESQss (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 May 2011 12:48:48 -0400
Date: Thu, 19 May 2011 11:48:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] rtlwifi: Use order 2 RX buffer allocation only if
 necessary
Message-ID: <4dd549ed.umadc9UwpyaCQkpw%Larry.Finger@lwfinger.net> (sfid-20110519_184851_183855_56E42E5A)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Although a previous fix handles the kernel panics that result from
failure to allocate a new RX buffer, memory fragmentation can be
reduced if the amsdu_8k capability is disabled as new buffers need only
be of O(0), not O(2).

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This is 2.6.40 material.

Larry
---

Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
===================================================================
--- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
+++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
@@ -1115,6 +1115,13 @@ static int _rtl_pci_init_rx_ring(struct
 
 		rtlpci->rx_ring[rx_queue_idx].idx = 0;
 
+		/* If amsdu_8k is disabled, set buffersize to 4096. This
+		 * change will reduce memory fragmentation.
+		 */
+		if (rtlpci->rxbuffersize > 4096 &&
+		    rtlpriv->rtlhal.disable_amsdu_8k)
+			rtlpci->rxbuffersize = 4096;
+
 		for (i = 0; i < rtlpci->rxringcount; i++) {
 			struct sk_buff *skb =
 			    dev_alloc_skb(rtlpci->rxbuffersize);
