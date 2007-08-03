Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.riseup.net ([204.13.164.18]:42599 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760316AbXHCOzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2007 10:55:40 -0400
Date: Fri, 3 Aug 2007 16:30:44 +0200
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/10] Port of bcm43xx from softmac to mac80211
Message-ID: <20070803163044.3d0fff1b@morte>
In-Reply-To: <46b1fde7.JR5zA75dJy7VnTEq%Larry.Finger@lwfinger.net>
References: <46b1fde7.JR5zA75dJy7VnTEq%Larry.Finger@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Just a quick review, mostly about coding style. If it works, I ACK this.]

On Thu, 02 Aug 2007 10:53:11 -0500
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> +#define BCM43xx_RX_MAX_SSI		60

A comment here wouldn't hurt.

>  /* MMIO offsets */
>  #define BCM43xx_MMIO_DMA0_REASON	0x20
> @@ -45,6 +39,7 @@
>  #define BCM43xx_MMIO_DMA4_IRQ_MASK	0x44
>  #define BCM43xx_MMIO_DMA5_REASON	0x48
>  #define BCM43xx_MMIO_DMA5_IRQ_MASK	0x4C
> +#define BCM43xx_MMIO_MACCTL		0x120
>  #define BCM43xx_MMIO_STATUS_BITFIELD	0x120
>  #define BCM43xx_MMIO_STATUS2_BITFIELD	0x124
>  #define BCM43xx_MMIO_GEN_IRQ_REASON	0x128
> @@ -83,6 +78,7 @@
>  
>  #define BCM43xx_MMIO_PHY_VER		0x3E0
>  #define BCM43xx_MMIO_PHY_RADIO		0x3E2
> +#define BCM43xx_MMIO_PHY0		0x3E6
>  #define BCM43xx_MMIO_ANTENNA		0x3E8
>  #define BCM43xx_MMIO_CHANNEL		0x3F0
>  #define BCM43xx_MMIO_CHANNEL_EXT	0x3F4
> @@ -93,6 +89,7 @@
>  #define BCM43xx_MMIO_PHY_DATA		0x3FE
>  #define BCM43xx_MMIO_MACFILTER_CONTROL	0x420
>  #define BCM43xx_MMIO_MACFILTER_DATA	0x422
> +#define BCM43xx_MMIO_RCMTA_COUNT	0x43C

Ditto, the meaning of RCMTA isn't obvious.

>  /* PHYVersioning */
> -#define BCM43xx_PHYTYPE_A		0x00

So OK, let's remove support for A PHYs. I never got done with it and maybe it
had to be rewritten from scratch anyway.

> +#define BCM43xx_IRQ_TBTT_INDI		0x00000004

A comment here would be nice.

>  #define BCM43xx_INTERFSTACK_SIZE	26
> -	u32 interfstack[BCM43xx_INTERFSTACK_SIZE];
> +	u32 interfstack[BCM43xx_INTERFSTACK_SIZE];/* FIXME: use a data
> struct */

Why?

> +/* Data structure for the WLAN parts (802.11 cores) of the bcm43xx chip.
> */ +struct bcm43xx_wl {
> +	/* Pointer to the active wireless device on this chip */
> +	struct bcm43xx_wldev *current_dev;
> +	/* Pointer to the ieee80211 hardware data structure */
> +	struct ieee80211_hw *hw;
> +
> +	spinlock_t irq_lock;		/* locks IRQ */
> +	struct mutex mutex;		/* locks ? */

What?

> -		atomic_set(&(bcm)->init_status, (stat));	\
> +	BCM43xx_STAT_UNINIT		= 0, /* Uninitialized. */
> +	BCM43xx_STAT_INITIALIZED	= 1, /* Initialized, not yet
> started */

"Initialized, not yet started."

> -/*    *** THEORY OF LOCKING ***
> +/* XXX---   HOW LOCKING WORKS IN BCM43xx   ---XXX

I'd prefer "***" but this isn't relevant. :)

> +struct bcm43xx_wldev {
> +	struct ssb_device *dev;
> +	struct bcm43xx_wl *wl;
> +
> +	/* The device initialization status.
> +	 * Use bcm43xx_status() to query. */
> +	atomic_t __init_status;
> +	/* Saved init status for handling suspend. */
> +	int suspend_init_status;
> +
> +	bool __using_pio;		/* iUse bcm43xx_using_pio(). */

An evolution of the iRack? :P

> +	bool bad_frames_preempt;	/* Use "Bad Frames Preemption" */

Dot at the end.

> +	bool reg124_set_0x4;		/* Variable to keep track of
> IRQ */

Ditto.

> +	bool short_preamble;		/* TRUE if short preamble
> enabled. */

"True".

> +	bool short_slot;		/* TRUE if short slot timing
> enabled. */

Ditto.

> +	bool radio_hw_enable;		/* state of radio hardware
> enable bit */

"State of the radio hardware enable bit."

> +/* Macros for printing a value in Q5.2 format */
> +#define Q52_FMT		"%u.%u"
> +#define Q52_ARG(q52)	((q52) / 4), ((((q52) & 3) * 100) / 4)

#define Q52_ARG(q52) ((q52) / 4), (((q52) & 3) * 100 / 4)


--
Ciao
Stefano


-- 
Ciao
Stefano
