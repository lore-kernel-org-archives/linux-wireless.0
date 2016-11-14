Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42004 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752249AbcKNIoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 03:44:25 -0500
Date: Mon, 14 Nov 2016 09:42:38 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Mathias Kresin <dev@kresin.me>
Cc: linux-wireless@vger.kernel.org,
        Helmut Schaa <helmut.schaa@googlemail.com>
Subject: Re: [PATCH 04/10] rt2800: do not overwrite
 WPDMA_GLO_CFG_WP_DMA_BURST_SIZE
Message-ID: <20161114084238.GA12372@redhat.com> (sfid-20161114_094429_231059_FB7C3EAB)
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
 <1478095865-8651-5-git-send-email-sgruszka@redhat.com>
 <48e4790b-7cb3-170e-eda1-11bce9934141@kresin.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48e4790b-7cb3-170e-eda1-11bce9934141@kresin.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 05, 2016 at 01:55:14PM +0100, Mathias Kresin wrote:
> 02.11.2016 15:10, Stanislaw Gruszka:
> >We already initlized WPDMA_GLO_CFG_WP_DMA_BURST_SIZE to 3 on
> >rt2800_init_registers().
> >
> >Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> >---
> > drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    1 -
> > 1 files changed, 0 insertions(+), 1 deletions(-)
> >
> >diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >index feceb13..9ecdc4c 100644
> >--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> >@@ -6756,7 +6756,6 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
> > 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
> > 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_TX_DMA, 1);
> > 	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_ENABLE_RX_DMA, 1);
> >-	rt2x00_set_field32(&reg, WPDMA_GLO_CFG_WP_DMA_BURST_SIZE, 2);
> 
> More a notice than a potential issue since I don't have much
> knowledge about the driver/chip internals.
> 
> But WPDMA_GLO_CFG_WP_DMA_BURST_SIZE in rt2800_init_registers() is
> set conditionally for rt2x00_is_usb(rt2x00dev), where this one is
> set unconditionally. Not sure if this change has side effects.

Default HW setting of WP_DMA_BURTS_SIZE is 2, hence patch does not
change behaviour on PCI devices. However I looked at RT3290 and
RT5592 PCI vendor drivers and there this value is initialized to 3.
So I think we can remove is_usb condition in rt2800_init_registers().

Stanislaw
