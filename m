Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50622 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1033044AbeCAR3X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 12:29:23 -0500
Date: Thu, 1 Mar 2018 17:29:20 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180301172920.GV14069@wotan.suse.de> (sfid-20180301_182927_037005_FDA967F2)
References: <20180226182859.03184215@cakuba.netronome.com>
 <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
 <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
 <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com>
 <20180228184820.GL14069@wotan.suse.de>
 <ba4c6079-ca45-2048-1e7d-3cb4e1a80cdb@gmail.com>
 <20180301002813.GQ14069@wotan.suse.de>
 <9088ab38-5a88-f479-1225-5988f9890aaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <9088ab38-5a88-f479-1225-5988f9890aaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 01, 2018 at 04:05:29PM +0200, cantabile wrote:
> On 01/03/18 02:28, Luis R. Rodriguez wrote:
> > On Wed, Feb 28, 2018 at 11:18:59PM +0200, cantabile wrote:
> > 
> > > Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Firmware Version: 0.1.00 Build: 7640 Build time: 201302052146____
> > > Feb 28 22:46:19 home kernel: ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd c6/00:01:00:00:00:a0 (SET MULTIPLE MODE) succeeded
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: supports DRM functions and may not be fully accessible
> > > Feb 28 22:46:19 home kernel: ata1.00: disabling queued TRIM support
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE LOCK) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd b1/c1:00:00:00:00:a0 (DEVICE CONFIGURATION OVERLAY) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd c6/00:01:00:00:00:a0 (SET MULTIPLE MODE) succeeded
> > > Feb 28 22:46:19 home kernel: ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES) filtered out
> > > Feb 28 22:46:19 home kernel: ata1.00: supports DRM functions and may not be fully accessible
> > > Feb 28 22:46:19 home kernel: ata1.00: disabling queued TRIM support
> > > Feb 28 22:46:19 home kernel: ata1.00: configured for UDMA/133
> > > Feb 28 22:46:19 home kernel: usb 4-2: reset full-speed USB device number 2 using uhci_hcd
> > > Feb 28 22:46:19 home kernel: mt7601u 2-3:1.0: Error: MCU response pre-completed!
> > 
> > An issue immediately. So it should mean the firmware load didn't likely work
> > correctly.
> 
> This particular error message appears pretty often after resuming from
> hibernation and loading the firmware, but the device works anyway. 

OK.

> To be
> clear, I'm talking about hibernation attempts from before I made it upload
> the firmware unconditionally.

So you mean to say this happens with the stock kernel (except the debug prints
you added)?

That is, you didn't force to upload the firmware on the above log.

Also, the above log is not from a kernel with the patches I posted to fix the
issue and issue a cache request when the device already has a firmware already
loaded?

Correct?

> > > Feb 28 22:46:19 home systemd[1]: Started Suspend.
> > 
> > Oh another suspend? Or is this just noise from systemd?
> 
> It's just noise. This whole excerpt from journalctl includes only one
> suspend/resume.

Ah, so you really are kicking into high gear suspend/resume or hibernation/resume.
Note that there may be some fun races there with the driver perhaps. Who knows.

> > > Feb 28 22:46:20 home kernel: mt7601u 2-3:1.0: Error: MCU response pre-completed!
> > 
> > Either way the 802.11 device is barfing.
> > 
> > > Feb 28 22:46:20 home kernel: ------------[ cut here ]------------
> > > Feb 28 22:46:20 home kernel: Kernel BUG at 000000009312bc4c [verbose debug info unavailable]
> > 
> > And since no debug info is available we ca't do much more to look at this
> > issue. You can recompile with debugging symbols enabled (look online), and
> > it may help further.
> > 
> 
> If I must... :/

To get clear logs you must.

But if the patches I posted help, I guess we already have a solution, The rest of
these email exchanges are all just hypothetical exercises.

  Luis
