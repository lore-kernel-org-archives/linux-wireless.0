Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:61592 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbXJPPKN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Oct 2007 11:10:13 -0400
Date: Tue, 16 Oct 2007 08:07:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 4/5] Add extensive documenation for the atheros
 bssid_mask
Message-Id: <20071016080751.55bf3dde.randy.dunlap@oracle.com> (sfid-20071016_161016_910260_0BF27189)
In-Reply-To: <20071012150709.GE9407@pogo>
References: <20071012150438.GC9407@pogo>
	<20071012150543.GD9407@pogo>
	<20071012150709.GE9407@pogo>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 12 Oct 2007 11:07:09 -0400 Luis R. Rodriguez wrote:

> Add extensive documenation for the atheros bssid_mask.
> Credit to David Kimdon for figuring this out. I am
> just documenting it.
> 
> Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
> ---
>  drivers/net/wireless/ath5k/base.c |    7 +--
>  drivers/net/wireless/ath5k/hw.c   |   96 +++++++++++++++++++++++++++++++++++-
>  drivers/net/wireless/ath5k/reg.h  |   17 ++++--
>  3 files changed, 107 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
> index b106ead..fc00667 100644
> --- a/drivers/net/wireless/ath5k/hw.c
> +++ b/drivers/net/wireless/ath5k/hw.c
> @@ -2323,9 +2323,99 @@ void ath5k_hw_set_associd(struct ath_hw *hal, const u8 *bssid, u16 assoc_id)
>  
>  	ath5k_hw_enable_pspoll(hal, NULL, 0);
>  }
> -
> -/*
> - * Set BSSID mask on 5212
> +/**

"/**" indicates kernel-doc notation, so I'll make a few comments here.

> + * ath5k_hw_set_bssid_mask - set common bits we should listen to

The list of parameters (@hal & @mask) need to be immediatly after
the function name/short description line, followed by a blank (" *")
line, then any other function comments/documentation that you want
to include here.

> + *
> + * The bssid_mask is a utility used by AR5212 hardware to inform the hardware
> + * which bits of the interface's MAC address should be looked at when trying
> + * to decide which packets to ACK. In station mode every bit matters. In AP
> + * mode with a single BSS every bit matters as well. In AP mode with
> + * multiple BSSes not every bit matters.
> + *
> + * @hal: the &struct ath_hw
> + * @mask: the bssid_mask, a u8 array of size ETH_ALEN
> + *
> + * Note that this is a simple filter and *does* not filter out all
> + * relevant frames. Some non-relevant frames will get through, probability
> + * jocks are welcomed to compute.
> + *
> + * When handling multiple BSSes (or VAPs) you can get the BSSID mask by
> + * computing the set of:
> + *
> + *     ~ ( MAC XOR BSSID )
> + *
> + * When you do this you are essentially computing the common bits. Later it
> + * is assumed the harware will "and" (&) the BSSID mask with the MAC address
> + * to obtain the relevant bits which should match on the destination frame.
> + *
> + * Simple example: on your card you have have two BSSes you have created with
> + * BSSID-01 and BSSID-02. Lets assume BSSID-01 will not use the MAC address.
> + * There is another BSSID-03 but you are not part of it. For simplicity's sake,
> + * assuming only 4 bits for a mac address and for BSSIDs you can then have:
> + *
> + *                  \
> + * MAC:                0001 |
> + * BSSID-01:   0100 | --> Belongs to us
> + * BSSID-02:   1001 |
> + *                  /
> + * -------------------
> + * BSSID-03:   0110  | --> External
> + * -------------------
> + *
> + * Our bssid_mask would then be:
> + *
> + *             On loop iteration for BSSID-01:
> + *             ~(0001 ^ 0100)  -> ~(0101)
> + *                             ->   1010
> + *             bssid_mask      =    1010
> + *
> + *             On loop iteration for BSSID-02:
> + *             bssid_mask &= ~(0001   ^   1001)
> + *             bssid_mask =   (1010)  & ~(0001 ^ 1001)
> + *             bssid_mask =   (1010)  & ~(1001)
> + *             bssid_mask =   (1010)  &  (0110)
> + *             bssid_mask =   0010
> + *
> + * A bssid_mask of 0010 means "only pay attention to the second least
> + * significant bit". This is because its the only bit common
> + * amongst the MAC and all BSSIDs we support. To findout what the real
> + * common bit is we can simply "&" the bssid_mask now with any BSSID we have
> + * or our MAC address (we assume the hardware uses the MAC address).
> + *
> + * Now, suppose there's an incoming frame for BSSID-03:
> + *
> + * IFRAME-01:  0110
> + *
> + * An easy eye-inspeciton of this already should tell you that this frame
> + * will not pass our check. This is beacuse the bssid_mask tells the
> + * hardware to only look at the second least significant bit and the
> + * common bit amongst the MAC and BSSIDs is 0, this frame has the 2nd LSB
> + * as 1, which does not match 0.
> + *
> + * So with IFRAME-01 we *assume* the hardware will do:
> + *
> + *     allow = (IFRAME-01 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
> + *  --> allow = (0110 & 0010) == (0010 & 0001) ? 1 : 0;
> + *  --> allow = (0010) == 0000 ? 1 : 0;
> + *  --> allow = 0
> + *
> + *  Lets now test a frame that should work:
> + *
> + * IFRAME-02:  0001 (we should allow)
> + *
> + *     allow = (0001 & 1010) == 1010
> + *
> + *     allow = (IFRAME-02 & bssid_mask) == (bssid_mask & MAC) ? 1 : 0;
> + *  --> allow = (0001 & 0010) ==  (0010 & 0001) ? 1 :0;
> + *  --> allow = (0010) == (0010)
> + *  --> allow = 1
> + *
> + * Other examples:
> + *
> + * IFRAME-03:  0100 --> allowed
> + * IFRAME-04:  1001 --> allowed
> + * IFRAME-05:  1101 --> allowed but its not for us!!!
> + *
>   */

Thanks.
---
~Randy
