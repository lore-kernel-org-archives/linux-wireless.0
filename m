Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882Ab1H3Efg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 00:35:36 -0400
Date: Mon, 29 Aug 2011 21:28:02 -0700
From: Greg KH <gregkh@suse.de>
To: Henry Ptasinski <henryp@broadcom.com>
Cc: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Subject: Re: [PATCH v2] Move brcm80211 to mainline
Message-ID: <20110830042802.GA15320@suse.de> (sfid-20110830_063540_059569_2C362D1D)
References: <20110707002034.GA17885@broadcom.com>
 <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain>
 <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de>
 <20110830014257.GI15771@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110830014257.GI15771@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 29, 2011 at 06:42:57PM -0700, Henry Ptasinski wrote:
> On Sat, Aug 27, 2011 at 08:21:44AM -0700, Greg KH wrote:
> > Ok, we don't want/accept duplicate drivers for the same devices (well, I
> > sure don't want that, we had it in the past in the USB subsystem and it
> > was a nightmare).
> > 
> > So, as b43 was here first, it looks like brcmfmac is the only part that
> > should really move out of staging, right?
> > 
> > Henry, thoughts?  Have you all been tracking the b43 support for the
> > past year?
> 
> Greg,
> 
> The brcmsmac driver supports full-rate 802.11n/HT operation on 20MHz channels,
> and has from the day we released it.

The day you released it, it did not support the same devices that the
in-kernel b43 driver did, which was the only way I accepted it.

Over time, the in-kernel driver has added new device support, which I
was not aware of.

> This includes 802.11n/HT rates and
> multiple spatial streams, and a number of additional 11n features such as
> A-MPDU and RIFS.  Current iperf testing on 20MHz channels with a BCM43224
> achieves greater than 70Mbps TCP throughput, using phy rates up to about
> 130Mbps.
> 
> This contrasts with a maximum possible rate of 54Mbps/phy or 24Mbps TCP
> throughput for any driver that is legacy only and/or which doesn't support 11n
> optimizations such as aggregation of layer 2 PDUs (AMPDU).  802.11n operation
> can also achive greater range than legacy operation.
> 
> b43 doesn't currently support 802.11n at all, so performance with b43 is
> limited to legacy 11g rates at best.

Ok, then why not just help the b43 developers add 11n support to the
driver?  Surely that would have been easier than the 1 year development
effort you all have put in trying to clean up the staging driver to the
level of a "mergable" driver.

> The brcmsmac driver supports 5GHz channels, including 802.11n operation in
> 5GHz.  b43 doesn't appear to currently support 5GHz.

Surely that's a simple addition, right?

> We understand the level of effort that it's taken for b43 to get as far as it
> has, and was implemented without access to proprietary information, and it has
> been impossible to support advanced chip features. We appreciate the difficulty
> of your task and respect your accomplishments tremendously! 

Then why not try to help out here?

All other wireless companies have realized that this is the best way
forward over time.  Remember, b43 was here first, you need to play nice
with those developers.

> The brcmsmac driver has architectural alignment with our drivers for other
> operating systems, and we intend to to enhance and maintain this driver in 
> parallel with drivers for other operating systems.  Maintaining alignment
> between our Linux driver and drivers for other operating systems allows us to
> leverage feature and chip support across all platforms.

No it doesn't.

Really, it doesn't.

And even if it did, that doesn't pertain to anything here that we care
about, it's not a valid argument.

> Broadcom has made, and is continuing to make, a big investment in open source
> and is planning on supporting the brcmsmac driver fully.  The benefit to the
> community is:
> 
> *         Complete silicon support, including real calibration
> *         Full 802.11n standard support
> *         Increasing features and chips over time.
> 
> We understand and respect the goal of 1 driver for 1 piece of hardware.
> However, we released the brcmsmac driver with 802.11n support last September,
> whereas b43 still doesn't have 802.11n support, so brcmsmac is still the first
> and only driver to provide full support for these chips.

That's great, and we appreciate that.  But also realize that this
doesn't mean we owe you anything.

You really need to work with the b43 developers here.

Why can't you just do the small changes needed to the b43 driver to add
the missing functionality based on the fact that you know how the
hardware works?

Again, we can't merge a driver that works for the same device.

greg k-h
