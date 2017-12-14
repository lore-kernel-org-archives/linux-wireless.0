Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751863AbdLNMsF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 07:48:05 -0500
Date: Thu, 14 Dec 2017 13:47:12 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Craig McQueen <craig.mcqueen@innerrange.com.au>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rt2800usb firmware rt2870.bin 0.36 not scanning
Message-ID: <20171214124712.GA2737@redhat.com> (sfid-20171214_134808_606931_5338C3DA)
References: <f2d6e3de-826a-c7b6-ac29-16b83be758e8@gmail.com>
 <5500469A22567C4BAF673A6E86AFA3A4022D2A096849@IR-CENTRAL.corp.innerrange.com>
 <5500469A22567C4BAF673A6E86AFA3A4022D2BB5ED6C@IR-CENTRAL.corp.innerrange.com>
 <17dbd0476f1e45c7af0cb70efb15d75f@innerrange.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <17dbd0476f1e45c7af0cb70efb15d75f@innerrange.com.au>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 13, 2017 at 11:24:28PM +0000, Craig McQueen wrote:
> > Actually, I was wrong. With the 3.14.x Yocto-built kernel, this no-scan issue
> > only happens with the Edup with the 5390 chipset, and the D-Link is fine.
> > 
> > But further testing with the 4.4.12 Yocto-built kernel shows that it randomly
> > sometimes happens and sometimes doesn't with either the Edup or D-Link
> > devices. That's especially interesting, because it suggests that there may be a
> > race condition happening during the driver initialisation code (called from
> > rt2x00lib_start()). At first I thought it was a race condition between the calls
> > to rt2x00lib_load_firmware() and rt2x00lib_initialize(), but adding a time
> > delay between those calls didn't help.
> > 
> > I'm wondering what the difference is between the two chipsets, so that the
> > problem happens more on one chipset than the other. But not exclusively, as
> > I mentioned above, so again, this points to a marginal timing issue that
> > affects one more than the other.
> > 
> > > With the Ubuntu 4.4.6 kernel, both devices work fine, without this
> > > no-scan problem.
> > > ...
> 
> Now I'm using a 4.9.65 kernel, and this problem is still present. When the USB Wi-Fi dongle is plugged in, it just doesn't do anything -- doesn't scan for Wi-Fi networks, doesn't connect to anything.
> 
> My project is using ConnMan, so I've patched ConnMan so that it takes the device up, then down, then up again. Then it reliably works. But of course this is an ugly hack.
> 
> Based on my initial investigation, my hypothesis was that there's a race condition during rt2x00lib_start() in rt2x00dev.c. At first I thought it was between firmware loading and initialisation. But adding a time delay between the calls to rt2x00lib_load_firmware() and rt2x00lib_initialize() didn't help. Adding time delays at many possible points in the initialisation didn't seem to help. I thought there must be a race condition in a very specific location in the initialisation sequence, but could not confirm that hypothesis. So now I've drawn a blank.
> 
> Any advice on how to diagnose and remedy this issue?

I know the vendor driver do initialization sequence twice - after
finish first sequence the same steps are repeated second time.
I don't know why that is needed and on all my Ralink USB devices
one initialization sequence is sufficient with rt2x00 driver.

Right fix to this will be found proper initialization sequence,
so second step will not be needed, but perhaps this is firmware
problem. Anyway ConnMan patch seems to be a good solution
as well ;-) 

Cheers
Stanislaw
