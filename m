Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:35873 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab0IYIfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Sep 2010 04:35:14 -0400
Received: by fxm3 with SMTP id 3so1119098fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 25 Sep 2010 01:35:13 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Joshua Smith <jesmith@kaon.com>
Subject: Re: Question about starting up an AP
Date: Sat, 25 Sep 2010 10:34:24 +0200
Cc: linux-wireless@vger.kernel.org,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
References: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
In-Reply-To: <DA0C92FD-F6BF-4746-9BE1-A643A0D70F7A@kaon.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201009251034.24993.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joshua,

Am Freitag 24 September 2010 schrieb Joshua Smith:
> I'm building an AP using the latest CW code with a 2.6.27.8 kernel, and a
> Linsys/Cisco WMP660N PCI adapter.  I'm having a problem with the boot-up
> sequence.  Sometimes, when I start hostapd, I get this error in the system
> log:
> 
>  kernel: phy0 -> rt2800_wait_wpdma_ready: Error - WPDMA TX/RX busy, aborting.
> 
> and hostapd craps out.  If I try to run hostapd again, the kernel dies. 

Hmm, the legacy driver waits much longer (100 * 1ms) for DMA being ready then
we do in rt2800 (5 * 1ms). Not sure if that will make a difference for you
but please try this patch:

>From d9792259cfc5253725f3855bb2cb9b4acadec103 Mon Sep 17 00:00:00 2001
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Sat, 25 Sep 2010 10:32:21 +0200
Subject: [PATCH] rt2x00: increase wait time for WPDMA being ready


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index c7076de..058de10 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -277,7 +277,7 @@ int rt2800_wait_wpdma_ready(struct rt2x00_dev *rt2x00dev)
 	unsigned int i;
 	u32 reg;
 
-	for (i = 0; i < REGISTER_BUSY_COUNT; i++) {
+	for (i = 0; i < 100; i++) {
 		rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
 		if (!rt2x00_get_field32(reg, WPDMA_GLO_CFG_TX_DMA_BUSY) &&
 		    !rt2x00_get_field32(reg, WPDMA_GLO_CFG_RX_DMA_BUSY))
-- 
1.7.1

