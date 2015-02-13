Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:32898 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbBMDA4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2015 22:00:56 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21725.27048.780919.425963@gargle.gargle.HOWL> (sfid-20150213_040106_650999_8E2A105D)
Date: Fri, 13 Feb 2015 08:34:08 +0530
To: Davide Pesavento <davidepesa@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: NULL pointer dereference in ath_isr+0x27/0x250 [ath9k]
In-Reply-To: <CADfzvvYn74U73GNwkezrpqGf3w96GYbcioSZg9A9RQxwF5edug@mail.gmail.com>
References: <CADfzvvYn74U73GNwkezrpqGf3w96GYbcioSZg9A9RQxwF5edug@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Davide Pesavento wrote:
> I have no experience in debugging kernel panics, but running gdb on
> vmlinux seems to point to the test_bit() call in ath_isr, which
> dereferences the "struct ath_common *common" pointer.
> 
> I looked around a bit and noticed that in ath9k/pci.c:ath_pci_probe(),
> the interrupt handler is registered with request_irq() before invoking
> ath9k_init_device(), which takes care of allocating the ath_hw
> structure. Therefore it might happen that an interrupt fires and
> ath_isr() tries to use the structure before it's allocated.

Please try with a recent kernel that contains these fixes
IRQ handling:

  commit 56bdbe0d6ac59c3eb17c2b9d715fb2e41467e354
  Author: Felix Fietkau <nbd@openwrt.org>
  Date:   Sun Nov 30 21:58:30 2014 +0100

  ath9k: prevent early IRQs from accessing hardware

  commit ef739ab6aac38b25e473f418ecfe1fb433346fa1
  Author: Felix Fietkau <nbd@openwrt.org>
  Date:   Sun Nov 30 21:58:31 2014 +0100

  ath9k: set ATH_OP_INVALID before disabling hardware

Sujith
