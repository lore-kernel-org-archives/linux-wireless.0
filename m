Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3739 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1H3BnM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Aug 2011 21:43:12 -0400
Date: Mon, 29 Aug 2011 18:42:57 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Dan Carpenter" <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110830014257.GI15771@broadcom.com> (sfid-20110830_034318_232105_C37C17D0)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de>
MIME-Version: 1.0
In-Reply-To: <20110827152144.GA10126@suse.de>
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 27, 2011 at 08:21:44AM -0700, Greg KH wrote:
> Ok, we don't want/accept duplicate drivers for the same devices (well, I
> sure don't want that, we had it in the past in the USB subsystem and it
> was a nightmare).
> 
> So, as b43 was here first, it looks like brcmfmac is the only part that
> should really move out of staging, right?
> 
> Henry, thoughts?  Have you all been tracking the b43 support for the
> past year?

Greg,

The brcmsmac driver supports full-rate 802.11n/HT operation on 20MHz channels,
and has from the day we released it.  This includes 802.11n/HT rates and
multiple spatial streams, and a number of additional 11n features such as
A-MPDU and RIFS.  Current iperf testing on 20MHz channels with a BCM43224
achieves greater than 70Mbps TCP throughput, using phy rates up to about
130Mbps.

This contrasts with a maximum possible rate of 54Mbps/phy or 24Mbps TCP
throughput for any driver that is legacy only and/or which doesn't support 11n
optimizations such as aggregation of layer 2 PDUs (AMPDU).  802.11n operation
can also achive greater range than legacy operation.

b43 doesn't currently support 802.11n at all, so performance with b43 is
limited to legacy 11g rates at best.

The brcmsmac driver supports 5GHz channels, including 802.11n operation in
5GHz.  b43 doesn't appear to currently support 5GHz.

The brcmsmac phy code also has full support for 802.11n/HT operation on 40MHz
channels.  Some of the upper MAC layer settings (e.g. indicating 40MHz support
to the stack) need updating in order to enable 40MHz channels, but all the
critical phy support is present.

The brcmsmac phy code is a direct derivative of the phy code used in our other
drivers, which has been designed and *tested* to work properly over the full
range of chip operating temperatures and fabrication process corners.

The b43 driver uses a snapshot of the calibration values, that was obtained
with a single (or few) chips in one environment, and applies those values
across the board to all chips, regardless of process variations, in all
environments.

The b43 driver doesn't implement transmit power control for the BCM43224 or
BCM43225, and has various other unimplemented phy functions, e.g.:

> void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
> {//TODO
> }
>
> static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
> {//TODO
> }
>
> static enum b43_txpwr_result b43_nphy_op_recalc_txpower(struct b43_wldev *dev,
>                                                         bool ignore_tssi)
> {//TODO
>         return B43_TXPWR_RES_DONE;
> }
>
> ...
>	b43err(dev->wl, "enabling tx pwr ctrl not implemented yet\n"); ...
> ...

etc.

So while brcmsmac may not yet have monitor or AP mode, it is far more complete
and functional in terms of 802.11n capabilities and phy functionality for the
chips that are currently supported by the driver.  As we add new, much more
complicated chips, those chips will also get complete, full-performance,
fully-tested support.

We understand the level of effort that it's taken for b43 to get as far as it
has, and was implemented without access to proprietary information, and it has
been impossible to support advanced chip features. We appreciate the difficulty
of your task and respect your accomplishments tremendously! 

The brcmsmac driver has architectural alignment with our drivers for other
operating systems, and we intend to to enhance and maintain this driver in 
parallel with drivers for other operating systems.  Maintaining alignment
between our Linux driver and drivers for other operating systems allows us to
leverage feature and chip support across all platforms.

Broadcom has made, and is continuing to make, a big investment in open source
and is planning on supporting the brcmsmac driver fully.  The benefit to the
community is:

*         Complete silicon support, including real calibration
*         Full 802.11n standard support
*         Increasing features and chips over time.

We understand and respect the goal of 1 driver for 1 piece of hardware.
However, we released the brcmsmac driver with 802.11n support last September,
whereas b43 still doesn't have 802.11n support, so brcmsmac is still the first
and only driver to provide full support for these chips.

- Henry



