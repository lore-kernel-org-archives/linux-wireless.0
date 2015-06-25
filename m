Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35667 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751821AbbFYJid (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 05:38:33 -0400
Message-ID: <1435225107.2096.12.camel@sipsolutions.net> (sfid-20150625_113837_354741_E807AA05)
Subject: Re: [PATCH v3] Add new mac80211 driver mwlwifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: David Lin <dlin@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Date: Thu, 25 Jun 2015 11:38:27 +0200
In-Reply-To: <909c66d61ee943f5a5ca202040944f2d@SC-EXCH02.marvell.com>
References: <909c66d61ee943f5a5ca202040944f2d@SC-EXCH02.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-25 at 03:48 +0000, David Lin wrote:
> Signed-off-by: David Lin <dlin@marvell.com>

This really needs a commit message, like saying what chips it supports,
perhaps where to find them, and similar.

>  drivers/net/wireless/Kconfig            |    1 +
>  drivers/net/wireless/Makefile           |    2 +
>  drivers/net/wireless/mwlwifi/Kconfig    |   17 +
>  drivers/net/wireless/mwlwifi/Makefile   |    9 +
>  drivers/net/wireless/mwlwifi/dev.h      |  435 ++++++
>  drivers/net/wireless/mwlwifi/fwcmd.c    | 2328 +++++++++++++++++++++++++++++++
>  drivers/net/wireless/mwlwifi/fwcmd.h    |  175 +++
>  drivers/net/wireless/mwlwifi/fwdl.c     |  183 +++
>  drivers/net/wireless/mwlwifi/fwdl.h     |   27 +
>  drivers/net/wireless/mwlwifi/hostcmd.h  |  753 ++++++++++
>  drivers/net/wireless/mwlwifi/isr.c      |  148 ++
>  drivers/net/wireless/mwlwifi/isr.h      |   26 +
>  drivers/net/wireless/mwlwifi/mac80211.c |  743 ++++++++++
>  drivers/net/wireless/mwlwifi/mac80211.h |   25 +
>  drivers/net/wireless/mwlwifi/main.c     |  858 ++++++++++++
>  drivers/net/wireless/mwlwifi/rx.c       |  523 +++++++
>  drivers/net/wireless/mwlwifi/rx.h       |   25 +
>  drivers/net/wireless/mwlwifi/sysadpt.h  |   67 +
>  drivers/net/wireless/mwlwifi/tx.c       |  836 +++++++++++
>  drivers/net/wireless/mwlwifi/tx.h       |   28 +
>  20 files changed, 7209 insertions(+)

You're missing a MAINTAINERS entry.

> +++ b/drivers/net/wireless/mwlwifi/Kconfig
> @@ -0,0 +1,17 @@
> +config MWLWIFI
> +	tristate "Marvell Wireless WiFi driver (mwlwifi)"
> +	depends on PCI && MAC80211 && MWIFIEX_PCIE=n

Uh, what's with the exclusion of MWIFIEX_PCIE? Couldn't use a different
PCI ID? I really think you need to get rid of this, otherwise people
can't even *build-test* their wifi changes fully.

> +++ b/drivers/net/wireless/mwlwifi/Makefile
> @@ -0,0 +1,9 @@
> +obj-$(CONFIG_MWLWIFI)	+= mwlwifi.o
> +
> +mwlwifi-objs		+= main.o
> +mwlwifi-objs		+= mac80211.o
> +mwlwifi-objs		+= fwdl.o
> +mwlwifi-objs		+= fwcmd.o
> +mwlwifi-objs		+= tx.o
> +mwlwifi-objs		+= rx.o
> +mwlwifi-objs		+= isr.o

Please add

ccflags-y += -D__CHECK_ENDIAN__

to this file to always flag sparse errors. You have checked with
sparse, right?

Ok ... you clearly haven't. Please add the line above, and fix up the
results. Also, you really need to try building this driver on 64-bit,
it reports a good number of warnings.

If you're up to it, also try running smatch on it, it reports a number
of more warnings that sparse misses, like this one:


mwl_rx_ring_init() warn: variable dereferenced before check 'rx_hndl->psk_buff' (see line 108)


This is going to be only a very superficial review until the driver
builds cleanly. I do think the firmware API stuff I was concerned about
earlier looks better now though

I think you went a bit overbaord with wiphy_info(), a number of those
(like the beacon info one) surely are more debug messages than
operational messages that should be shown all the time.


> +> 	> /* Info for debugging
> +> 	> */
> +> 	> wiphy_info(hw->wiphy, "%s ...", __func__);
> +> 	> wiphy_info(hw->wiphy, "  -->pPhysTxRing[0] = %x",
> +> 	> 	>    priv->desc_data[0].pphys_tx_ring);
> +> 	> wiphy_info(hw->wiphy, "  -->pPhysTxRing[1] = %x",
> +> 	> 	>    priv->desc_data[1].pphys_tx_ring);
> +> 	> wiphy_info(hw->wiphy, "  -->pPhysTxRing[2] = %x",
> +> 	> 	>    priv->desc_data[2].pphys_tx_ring);
> +> 	> wiphy_info(hw->wiphy, "  -->pPhysTxRing[3] = %x",
> +> 	> 	>    priv->desc_data[3].pphys_tx_ring);
> +> 	> wiphy_info(hw->wiphy, "  -->pPhysRxRing    = %x",
> +> 	> 	>    priv->desc_data[0].pphys_rx_ring);
> +> 	> wiphy_info(hw->wiphy, "  -->numtxq %d wcbperq %d totalrxwcb %d",
> +> 	> 	>    SYSADPT_NUM_OF_DESC_DATA,
> +> 	> 	>    SYSADPT_MAX_NUM_TX_DESC,
> +> 	> 	>    SYSADPT_MAX_NUM_RX_DESC);

Like that ... I've even read the comment :)


> +> 	> spin_lock_irqsave(&priv->fwcmd_lock, flags)
> 

You really only need _irqsave on the stream_lock, the others aren't
used in IRQ context so don't need to disable IRQs. Perhaps BHs, haven't
checked.

johannes
