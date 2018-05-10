Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:40704 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934517AbeEJKbA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 May 2018 06:31:00 -0400
Received: by mail-it0-f67.google.com with SMTP id j186-v6so2502496ita.5
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2018 03:30:59 -0700 (PDT)
Message-ID: <5AF41F55.4060606@sra-tohoku.co.jp> (sfid-20180510_123104_600602_A76EA0DA)
Date: Thu, 10 May 2018 19:30:45 +0900
From: Taketo Kabe <kabe@sra-tohoku.co.jp>
MIME-Version: 1.0
To: b43-dev@lists.infradead.org
CC: kabe@sra-tohoku.co.jp, linux-wireless@vger.kernel.org,
        kvalo@codeaurora.org
Subject: [PATCH v2] drivers/net/wireless/broadcom/b43: fix transmit failure
 when VT is switched
References: <5AF2DE73.20608@sra-tohoku.co.jp> <20180509185101.0888bd7a@wiggum>
In-Reply-To: <20180509185101.0888bd7a@wiggum>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


From: Taketo Kabe <kabe@sra-tohoku.co.jp>

Fix for b43 wireless card stopping transmission when switching VTs.

Setup:
Using BCM4306 rev.03 chip based CardBus wireless card.
IRQ is shared with yenta (cardbus bridge) and i915 (display) driver.
For firmware, installed latest but dated openfwwf 5.2
(http://netweb.ing.unibs.it/~openfwwf/)

How-to-reproduce:
Do "ssh <NetBSD-remotehost>", then "ls -lR /" to generate traffic, then
repeatedly switch VTs by Alt-F1<>Alt-F2.
Eventually (within a minute) the card stops working.
You can receive traffic but no transmission.
For unknown reason it doesn't occur when just generating traffic by
"ssh <remotehost> ls -lR /".

With CONFIG_B43_DEBUG=y kernel config, when it stops,
the debug message shows
     kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 148, but got 180
The slot offset I observed so far was always 32.

When err_out2 is not set to make error messages successive,
the debug output will be like this:
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 148
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 150
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 120
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 152
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 122
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 154
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 124
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 156
kernel: b43-phy1 debug: Out of order TX status report on DMA ring 1. Expected 116, but got 126
The TX ring alternates between 2 sequences; the ring seems
to be completely confused. Controller restart is needed.

Workaround(1):
This problem doesn't occur when using propriatory firmware
you will extract by b43-fwcutter, so it may be a bug in
openfwwf firmware, as the comment in the b43_dma_handle_txstatus() suggests.
I wasn't able to find a bug in the terse openfwwf code though.

Workaround(2):
Using "pio=1" option to not use DMA makes this problem to
not occur.

Description of the patch:
This patch will forcibly reset the controller to make it
work again. Very kludgy and doesn't look right, but
the traffic will continue to flow.

Changes since last edition:
- Remove now unused err_out2 variable.

Signed-off-by: Taketo Kabe <kabe@sra-tohoku.co.jp>
---
diff -up ./drivers/net/wireless/broadcom/b43/dma.c.b43 ./drivers/net/wireless/broadcom/b43/dma.c
--- ./drivers/net/wireless/broadcom/b43/dma.c.b43	2018-05-04 15:18:12.000000000 +0900
+++ ./drivers/net/wireless/broadcom/b43/dma.c	2018-05-10 18:46:36.000000000 +0900
@@ -1484,7 +1484,7 @@ void b43_dma_handle_txstatus(struct b43_
  	int slot, firstused;
  	bool frame_succeed;
  	int skip;
-	static u8 err_out1, err_out2;
+	static u8 err_out1;

  	ring = parse_cookie(dev, status->cookie, &slot);
  	if (unlikely(!ring))
@@ -1518,13 +1518,13 @@ void b43_dma_handle_txstatus(struct b43_
  			}
  		} else {
  			/* More than a single header/data pair were missed.
-			 * Report this error once.
+			 * Report this error, and reset the controller to
+			 * revive operation.
  			 */
-			if (!err_out2)
-				b43dbg(dev->wl,
-				       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
-				       ring->index, firstused, slot);
-			err_out2 = 1;
+			b43dbg(dev->wl,
+			       "Out of order TX status report on DMA ring %d. Expected %d, but got %d\n",
+			       ring->index, firstused, slot);
+			b43_controller_restart(dev, "Out of order TX");
  			return;
  		}
  	}

-- 
kabe
