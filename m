Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47715 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934324AbeB1Ull (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 15:41:41 -0500
Date: Wed, 28 Feb 2018 20:41:38 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        cantabile <cantabile.desu@gmail.com>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180228204138.GN14069@wotan.suse.de> (sfid-20180228_214145_398618_DE95254A)
References: <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
 <20180225175425.GL14069@wotan.suse.de>
 <20180226182859.03184215@cakuba.netronome.com>
 <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
 <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
 <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com>
 <20180228184820.GL14069@wotan.suse.de>
 <5A970089.6030805@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5A970089.6030805@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 28, 2018 at 08:18:33PM +0100, Arend van Spriel wrote:
> On 2/28/2018 7:48 PM, Luis R. Rodriguez wrote:
> > On Wed, Feb 28, 2018 at 08:02:59PM +0200, cantabile wrote:
> > > On 27/02/18 22:42, Luis R. Rodriguez wrote:
> > > > I'd be curious if someone who can trigger the situation can test what
> > > > happens if you use:
> > > > 
> > > > diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> > > > index 65a8004418ea..04cbffd225a1 100644
> > > > --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> > > > +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> > > > @@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
> > > >    					 MT_USB_DMA_CFG_TX_BULK_EN));
> > > >    	if (firmware_running(dev))
> > > > -		return 0;
> > > > +		pr_info("Firmware already loaded but going to reload...");
> > > >    	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
> > > >    	if (ret)
> > > > 
> > > > 
> > > > Curious, will it really fail?
> > > 
> > > This change brings no new messages from mt7601u in dmesg (other than this
> > > pr_info), and the device works fine, as far as I can tell.
> > 
> > OK so we know that the optimization is optional, not a requirement.
> > That may be worth extending in documentation on the driver.
> > 
> > > > Note that I see mt7601u_stop() just calls mt7601u_mac_stop(). The big cleanup
> > > > happens via mt7601u_cleanup(), but I see mt7601u_disconnect() calls it.
> > > > 
> > > > Just curious, does that not get called on shutdown?
> > > > 
> > > > diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
> > > > index b9e4f6793138..126ef2ba77c2 100644
> > > > --- a/drivers/net/wireless/mediatek/mt7601u/usb.c
> > > > +++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
> > > > @@ -311,6 +311,7 @@ static void mt7601u_disconnect(struct usb_interface *usb_intf)
> > > >    {
> > > >    	struct mt7601u_dev *dev = usb_get_intfdata(usb_intf);
> > > > +	pr_info("Calling mt7601u_disconnect()...");
> > > >    	ieee80211_unregister_hw(dev->hw);
> > > >    	mt7601u_cleanup(dev);
> > > > 
> > > > If it does, one option is mt7601u_cleanup() can use some love to really shut down
> > > > the device more... But its not clear to me what else could be done and I'm very
> > > > inclined to believe its not sensible.
> > > > 
> > > "Calling mt7601u_disconnect" does not appear in journalctl after a reboot.
> > 
> > Oh, I didn't expect it to come up during startup, I was wondering if it did
> > trigger while going down on reboot.
> 
> Hi Luis,
> This driver does not implement a .shutdown() callback so that might be one
> reason and the usb subsystem does not call the disconnect for whatever
> reason.

Ah, that's one missing callback then. Hrm, well I suppose its optional and
without it, its just an optimization given there is no issue in keeping the
power on on the device and it retaining the firmware upon boot.

Note that the on interface stop all the DMA and MAC is stopped so I suppose
that is sufficient from an 802.11 perspective.

Thanks for chiming in!

  Luis

-- 
Luis Rodriguez, SUSE LINUX GmbH
Maxfeldstrasse 5; D-90409 Nuernberg
