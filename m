Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35553 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761983Ab2EQOt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 10:49:56 -0400
Received: by dady13 with SMTP id y13so2512935dad.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 07:49:56 -0700 (PDT)
Date: Thu, 17 May 2012 07:49:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
	linux-bluetooth@vger.kernel.org,
	gigaset307x-common@lists.sourceforge.net, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	libertas-dev@lists.infradead.org, users@rt2x00.serialmonkey.com
Subject: Re: [RFC 13/13] USB: Disable hub-initiated LPM for comms devices.
Message-ID: <20120517144951.GB27597@kroah.com> (sfid-20120517_165004_648594_286245AD)
References: <cover.1337203535.git.sarah.a.sharp@linux.intel.com>
 <20120516224528.GA25936@xanatos>
 <20120516232019.GA960@kroah.com>
 <20120517045220.GA4772@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120517045220.GA4772@xanatos>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 09:52:20PM -0700, Sarah Sharp wrote:
> On Wed, May 16, 2012 at 04:20:19PM -0700, Greg Kroah-Hartman wrote:
> > On Wed, May 16, 2012 at 03:45:28PM -0700, Sarah Sharp wrote:
> > > [Resending with a smaller Cc list]
> > > 
> > > Hub-initiated LPM is not good for USB communications devices.  Comms
> > > devices should be able to tell when their link can go into a lower power
> > > state, because they know when an incoming transmission is finished.
> > > Ideally, these devices would slam their links into a lower power state,
> > > using the device-initiated LPM, after finishing the last packet of their
> > > data transfer.
> > > 
> > > If we enable the idle timeouts for the parent hubs to enable
> > > hub-initiated LPM, we will get a lot of useless LPM packets on the bus
> > > as the devices reject LPM transitions when they're in the middle of
> > > receiving data.  Worse, some devices might blindly accept the
> > > hub-initiated LPM and power down their radios while they're in the
> > > middle of receiving a transmission.
> > > 
> > > The Intel Windows folks are disabling hub-initiated LPM for all USB
> > > communications devices under a xHCI USB 3.0 host.  In order to keep
> > > the Linux behavior as close as possible to Windows, we need to do the
> > > same in Linux.
> > 
> > How is the USB core on Windows determining that LPM should be turned off
> > for these devices?  Surely they aren't modifying each individual driver
> > like this is, right?  Any way we also can do this in the core?
> 
> No, I don't think they're modifying individual drivers.  Maybe they
> placed a shim/filter driver below other drivers?

They can do this in their driver by just watching the device class type.

> Basically, I don't know the exact details of what the Windows folks are
> doing.  The recommendation from the Intel Windows team was simply to
> turn hub-initiated LPM off for "all communications devices".  Perhaps
> the Windows USB core is looking for specific USB class codes?  Or maybe
> it has some older API that lets the core know it's a communications
> device?
> 
> I'm not really sure we can do it in the USB core with out basically
> duplicating all the class/PID/VID matching in the communications driver.
> I think just adding a flag might be the best way.  I'm open to
> suggestions though.

You can detect something as "simple" as a class type, which I bet is all
that Windows is going to be able to do as well.

> > Or, turn it around the other way, and only enable it if we know it's
> > safe to do so, in each driver, but I guess that would be even messier.
> 
> Yeah, I think it would be messier.

Ok, this is probably the best solution for us as well, sorry for the
noise.

greg k-h
