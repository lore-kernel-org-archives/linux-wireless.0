Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:12206 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755570Ab3FQRpi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 13:45:38 -0400
Date: Mon, 17 Jun 2013 13:45:36 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Franky Lin <frankyl@broadcom.com>
Cc: rvossen@broadcom.com, arend@broadcom.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] net: brcmfmac: add sdio chip id 0x4319
Message-ID: <20130617174536.GQ31667@titan.lakedaemon.net> (sfid-20130617_194554_088453_A4C8D131)
References: <20130612222123.GB31667@titan.lakedaemon.net>
 <20130617161903.GN31667@titan.lakedaemon.net>
 <51BF498F.1010007@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51BF498F.1010007@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 17, 2013 at 10:38:23AM -0700, Franky Lin wrote:
> On 06/17/2013 09:19 AM, Jason Cooper wrote:
> >Added Franky...
> >
> >On Wed, Jun 12, 2013 at 06:21:23PM -0400, Jason Cooper wrote:
> >>All,
> >>
> >>I have a Seagate Wireless Plus I am trying to put a vanilla kernel on
> >>(currently v3.10-rc5 for various omap DT bits).
> >>
> >>I have the board booting and running a debian rootfs on the HD.  I just
> >>got mmc to come up and I've discovered that the wireless card is vendor
> >>0x02d0, device 0x4319.
> >>
> >>My hope, once I got to this point, was that I would be able to use
> >>the mainline, open source driver.  Unfortunately, it looks like brcmfmac
> >>lost support for the 0x4319 while it was in staging.
> >>
> >>The commit in question is:
> >>
> >>   4dad253 staging: brcm80211: remove code for unsupported chip
> >>
> >>Is adding it back in a bridge too far?
> >It looks like only two things are needed, adding the chip id and then
> >setting the addresses.  Here's a preliminary patch to do just that.
> >Note, the addresses I have used are a straight copy from the 4329.  It
> >causes this:
> >
> >[   12.346466] mmcblk mmc0:0001: no of_node; not parsing pinctrl DT
> >[   12.353149] brcmfmac_sdio mmc0:0001:1: no of_node; not parsing pinctrl DT
> >[   12.360717] brcmfmac_sdio mmc0:0001:2: no of_node; not parsing pinctrl DT
> >[   12.368804] brcmfmac: brcmf_sdio_chip_drivestrengthinit: No SDIO Drive strength init done for chip 4319 rev 1 pmurev 7
> >[   12.380462] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> >[   12.391906] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> >[   12.403289] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=03, Err: -22
> >[   12.412261] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
> >[   12.418457] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> >[   12.429718] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> >[   12.441101] brcmfmac: brcmf_sdioh_request_byte: Failed to write byte F0:@0x00408=01, Err: -22
> >[   12.450073] brcmfmac: brcmf_sdio_regrw_helper: failed with -22
> >
> >I've taken a quick look at aosp, the provided GPL broadcom code, and I
> >haven't seen anything for the 4319 wrt to addresses.  How hard would it
> >be to get those addresses from you guys?
> 
> Hi Jason,
> 
> The major obstacle of adding 4319 support is the obsolete firmware.
> Since it's an EOL chip we are not planning to add the support to
> brcmfmac.

Let me guess, the firmware would have to be updated to work with
brcmfmac?  What about adding a BRMCFMAC_LEGACY option to allow
interfacing with the old firmware?

It may be EOL, but new products are still shipping with this chip
(Wireless Plus, other Azurewave products).

thx,

Jason.
