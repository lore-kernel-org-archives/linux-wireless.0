Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:54818 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750891AbdL3Tah (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Dec 2017 14:30:37 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arvind Yadav <arvind.yadav.cs@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Hans Liljestrand <ishkamiel@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Maksim Salau <maksim.salau@gmail.com>,
        Tobias Klauser <tklauser@distanz.ch>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] orinoco: Delete an error message for a failed memory
 allocation in three functions
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <aae8e17c-805e-f167-ced8-3436d6dcfbfc@users.sourceforge.net> (sfid-20171230_203100_409411_0CA6742E)
Date: Sat, 30 Dec 2017 20:30:03 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 30 Dec 2017 20:20:56 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/intersil/orinoco/main.c        | 10 ++--------
 drivers/net/wireless/intersil/orinoco/orinoco_usb.c |  5 ++---
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intersil/orinoco/main.c b/drivers/net/wireless/intersil/orinoco/main.c
index 28dac36d7c4c..0b214f92a503 100644
--- a/drivers/net/wireless/intersil/orinoco/main.c
+++ b/drivers/net/wireless/intersil/orinoco/main.c
@@ -785,11 +785,8 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	}
 
 	skb = dev_alloc_skb(hdrlen + datalen);
-	if (!skb) {
-		printk(KERN_WARNING "%s: Cannot allocate skb for monitor frame\n",
-		       dev->name);
+	if (!skb)
 		goto update_stats;
-	}
 
 	/* Copy the 802.11 header to the skb */
 	skb_put_data(skb, &(desc->frame_ctl), hdrlen);
@@ -900,11 +897,8 @@ void __orinoco_ev_rx(struct net_device *dev, struct hermes *hw)
 	   packets from the card, which has an IO granularity of 16
 	   bits */
 	skb = dev_alloc_skb(length + ETH_HLEN + 2 + 1);
-	if (!skb) {
-		printk(KERN_WARNING "%s: Can't allocate skb for Rx\n",
-		       dev->name);
+	if (!skb)
 		goto update_stats;
-	}
 
 	/* We'll prepend the header, so reserve space for it.  The worst
 	   case is no decapsulation, when 802.3 header is prepended and
diff --git a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
index 501180584b4b..8ef96a1c231f 100644
--- a/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
+++ b/drivers/net/wireless/intersil/orinoco/orinoco_usb.c
@@ -805,10 +805,9 @@ static int ezusb_firmware_download(struct ezusb_priv *upriv,
 	int variant_offset;
 
 	fw_buffer = kmalloc(FW_BUF_SIZE, GFP_KERNEL);
-	if (!fw_buffer) {
-		printk(KERN_ERR PFX "Out of memory for firmware buffer.\n");
+	if (!fw_buffer)
 		return -ENOMEM;
-	}
+
 	/*
 	 * This byte is 1 and should be replaced with 0.  The offset is
 	 * 0x10AD in version 0.0.6.  The byte in question should follow
-- 
2.15.1
