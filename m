Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758076AbZACSpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 13:45:20 -0500
Date: Sat, 03 Jan 2009 12:45:12 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org
Subject: [PATCH] p54usb: Fix to prevent SKB memory allocation errors with
 4K page size
Message-ID: <495fb238.kC8CbNo0tj1DoE+U%Larry.Finger@lwfinger.net> (sfid-20090103_194523_629748_BA623909)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On x86_64 architecture with 4K page size and SLUB debugging enabled, stress
testing on p54usb has resulted in skb allocation failures of O(1) and extreme
page fragmentation. Reducing rx_mtu fixes this problem by reducing the size of
all receive skb allocations to be of O(0). This change does not impact
performance in any way.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,
If possible, please include this in 2.6.29.

Larry
---

Index: wireless-testing/drivers/net/wireless/p54/p54common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/p54/p54common.c
+++ wireless-testing/drivers/net/wireless/p54/p54common.c
@@ -138,6 +138,7 @@ int p54_parse_firmware(struct ieee80211_
 	u8 *fw_version = NULL;
 	size_t len;
 	int i;
+	int maxlen;
 
 	if (priv->rx_start)
 		return 0;
@@ -195,6 +196,16 @@ int p54_parse_firmware(struct ieee80211_
 			else
 				priv->rx_mtu = (size_t)
 					0x620 - priv->tx_hdr_len;
+			maxlen = priv->tx_hdr_len + /* USB devices */
+				 sizeof(struct p54_rx_data) +
+				 4 + /* rx alignment */
+				 IEEE80211_MAX_FRAG_THRESHOLD;
+			if (priv->rx_mtu > maxlen && PAGE_SIZE == 4096) {
+				printk(KERN_INFO "p54: rx_mtu reduced from %d "
+					         "to %d\n", priv->rx_mtu,
+						 maxlen);
+				priv->rx_mtu = maxlen;
+			}
 			break;
 			}
 		case BR_CODE_EXPOSED_IF:

---

