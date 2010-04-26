Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:50849 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0DZMM4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 08:12:56 -0400
Received: by ewy20 with SMTP id 20so3628420ewy.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Apr 2010 05:12:54 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [WIP] p54pci: fix resume p54 cardbus
Date: Mon, 26 Apr 2010 14:12:47 +0200
Cc: linux-wireless@vger.kernel.org
References: <201004251525.19796.chunkeey@googlemail.com> <4BD55EFE.3080009@redhat.com>
In-Reply-To: <4BD55EFE.3080009@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004261412.47831.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 26 April 2010 11:38:06 Hans de Goede wrote: 
> On 04/25/2010 03:25 PM, Christian Lamparter wrote:
> > This patch tries to fix the resume freeze, which is described in
> > https://bugzilla.redhat.com/show_bug.cgi?id=583623
> >
> > Unlike (normal) PCI cards, cardbus cards are easily removable.
> > Therefore, the user might replace/remove the card while
> > the system is suspended. The pcmcia subsystem takes special
> > precautions to deal with such cases and un- and rebinds
> > all devices on the pci-bridge during the resume process.
> >
> > But here's the catch: p54pci uses request_firmware
> > which blocks until the filesystem is available.
> > This deadlocks, because the filesystem won't
> > be initialized until all pci devices are ready again.
> 
> p54pci uses request_firmware only from its probe function,
> which does not get called during a suspend resume AFAIK.
> 
> And if the card was inserted during a suspend / resume. I would
> not expect its driver to get loaded until the resume has completed
> and udev runs again.

no, all 2.6.34-rcX-wl kernels - I tried - refused to resume if
a p54pci was present in the cardslot. The culprit was found to be:

commit 88b060d6c03fcb9e4d2018b4349954c4242a5c7f               
Author: Dominik Brodowski <linux@dominikbrodowski.net>        
Date:   Sat Jan 2 14:14:23 2010 +0100                         

    pcmcia: improve check for same card in slot after resume
                                                            
    During a suspend/resume cycle, an user may change the card in the
    PCMCIA/CardBus slot. The pcmcia_core can at least look at the    
    socket state to check whether it is the same.                    
                                                                     
    For PCMCIA devices, move the detection and handling of such a    
    change to ds.c.                                                  
                                                                     
--> For CardBus devices, the PCI hotplug interface doesn't offer a "rescan"
    facility which also _removes_ devices no longer to be found behind a   
    bridge. Therefore, remove and re-add all devices unconditionally.  

> Hmm, I think while typing this message I just understood what you're
> trying to fix. The problem could occur when the driver is already loaded
> (for some reason), but not yet bound to the device as the card got
> inserted during suspend. Does the probe function get called during
> resume then ?

yes, due to "pcmcia: improve check for same card in slot after resume"
the p54p_probe function is now always called during resume. And as
you know this deadlocks, unless the firmware is included into the
kernel.

> This would seem like a driver core bug to me. It should not start
> binding drivers to "new" devices, until the resume is completed IMHO.
Well, the commit author does have a point.

what if I replace my Netgear WG511 with different Netgear WG511
(or even SMC W2835V2) while the system is suspendend?
All cards are fullmac p54pci, but they are not the same HW.

On the other hand, this patch breaks basically any cardbus
device driver which needs firmware and doesn't use the asynchronus
request interface. Also, (in case of mac80211) the unbind/bind
procedure resets mac80211/driver/etc.. to their uninitialized states
(and changes a few things, e.g.: phyX ids and friends). 
This could very well confuse the userspace, because after the
resume all configurations are gone...

> Note that the problem which I'm mostly seeing with suspend resume,
> is that the card fails shortly after resume. It seems to be come up
> and I can send / receive some packets and then it fails. The changes
> you're making to resume where you're actually calling pci enable
> on the device, and re-doing some pci config space settings might help
> here (I'm currently unloading the driver before suspend and reloading
> it after resume and then things work fine).
hm, can't say much about that... But, I have a (mini)pci system,
which hopefully won't unbind/rebind the devices upon resume.

> The one actual lockup I experienced in combination with suspend / resume
> was before the other p54pci bug we've working on together was fixed,
> as the driver was unstable at that time in general, so I'm not overly
> worried about that one lockup.
Ok, understood.

Regards,
   Chr
