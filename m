Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web33507.mail.mud.yahoo.com ([68.142.206.156]:21910 "HELO
	web33507.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750893AbXJFV1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 17:27:49 -0400
Date: Sat, 6 Oct 2007 14:27:48 -0700 (PDT)
From: Greg Johnson <gregfjohnson@yahoo.com>
Subject: Re: usb wifi ad-hoc mode suggestions?
To: linux-wireless@vger.kernel.org
In-Reply-To: <200710062008.37245.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Message-ID: <394976.55099.qm@web33507.mail.mud.yahoo.com> (sfid-20071006_222758_184406_363B3E80)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--- Michael Buesch <mb@bu3sch.de> wrote:

> On Saturday 06 October 2007 19:48:47 Daniel Drake wrote:
> > Greg Johnson wrote:
> > > We're trying the zd1211 with the zd1211rw driver and the mac80211 stack,
> > > which doesn't seem to have ad-hoc support currently, but their web site
> says
> > > it should be easy to add.
> > 
> > If you have coding resources on your hands, all that needs to be done is 
> > for someone to look at the ad-hoc handling code in the vendor driver and 
> > port it over the mac80211 driver. Diving into the vendor driver is a bit 
> > of a challenge though.
> 
> btw: Does the device also support AP mode?

At this point we would be happy with any USB wifi chipset, any driver,
and either AP mode or ad-hoc mode.  Do I sound desperate?  ;-)

We would be OK with 802.11B for now, but would need to be able to get
a reasonably reliable supply of wifi chips.

The Linux processor we are running on is an XSCALE, rather than a vanilla
X86, which is another contraint.  (In retrospect, I think we should have
gone with a vanilla x86, because then we could have gone with ndiswrapper
or similar.)

We had tried the driver zd1211-driver-r83, and that seems to work OK on our
xscale box in client mode talking to an access point.  And, it would allow
itself to be configured in ad-hoc mode.  But, it dropped 90+% of ping
packets in ad-hoc mode, to say nothing of trying to transfer actual data.

I downloaded and built ZD1211LnxDrv_2_21_0_0.tar.gz, and that seems to work
OK on my x86 laptop, but it failed miserably on our xscale.  (We are running
the xscale in big-endian, and the driver seems to have lots of byte-ordering
assumptions wired into it.)  (I have only tested it in client mode on my
laptop; don't even know if it works in ad-hoc mode yet.)  If
ZD1211LnxDrv_2_21_0_0.tar.gz works ok in ad-hoc mode on an x86 laptop,
we could possibly try fixing the byte-ordering problems with ntohs() etc.
and get it working on the xscale processor.  Another somewhat daunting
possibility would be to try to build a little-endian xscale linux kernel,
play with redboot to get little-endian bootloader etc. ;-(

If we can port ad-mode into zd1211rc/mac80211, that would be ideal from
our standpoint.  But that seems like a really large and difficult and
time-consuming task.

At this point we are getting desperate and are sorta trying to explore
the whole space and see if we can come up with any solution at all.

Greg


> 
> -- 
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



      ____________________________________________________________________________________
Catch up on fall's hot new shows on Yahoo! TV. Watch previews, get listings, and more!
http://tv.yahoo.com/collections/3658 
