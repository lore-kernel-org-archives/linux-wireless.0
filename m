Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50845 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928Ab3GRIHK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jul 2013 04:07:10 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Daniel Drake <dsd@laptop.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 18 Jul 2013 01:03:51 -0700
Subject: RE: [PATCH] mwifiex: fix IRQ enable/disable
Message-ID: <477F20668A386D41ADCC57781B1F70430EA3004F38@SC-VEXCH1.marvell.com> (sfid-20130718_100723_186712_2A4D6735)
References: <20130713145710.BC47D12647A@dev.laptop.org>
In-Reply-To: <20130713145710.BC47D12647A@dev.laptop.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Daniel,

Thanks for the patch.

> During tear down (e.g. mwifiex_sdio_remove during system suspend),
> mwifiex left IRQs enabled for a significant period of time when it was unable
> to handle them correctly. This caused interrupt storms and interfered with
> the bluetooth interface on the same SDIO card.
> 
> Solve this by disabling interrupts at the point when they can no longer be
> handled correctly, which is at the start of mwifiex_remove_card().
> 
> For cleanliness, we now enable interrupts in the mwifiex_add_card() path, to
> be symmetrical with the disabling of interrupts. We also couple the
> registration of the sdio IRQ handler with the actual enable/disable of
> interrupts at the hardware level.
> 
> I also removed a write to this register in mwifiex_init_sdio which seemed
> pointless and won't cause any ill effects now that we only register the SDIO
> IRQ handler when we are ready to accept interrupts.
> 
> Includes some corrections from Amitkumar Karwar.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/init.c | 10 +---
> drivers/net/wireless/mwifiex/main.c | 13 +++++-
> drivers/net/wireless/mwifiex/main.h |  1 +
> drivers/net/wireless/mwifiex/sdio.c | 91 +++++++++++++++++----------------
> ----
>  drivers/net/wireless/mwifiex/sdio.h |  3 --
>  5 files changed, 57 insertions(+), 61 deletions(-)
> 
> Replaces the previous patch:
> 	mwifiex: don't ignore SDIO interrupts during shutdown

