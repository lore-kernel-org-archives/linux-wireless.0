Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:40254 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752653Ab1KUWLT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 17:11:19 -0500
Subject: Re: pci: Rework ASPM disable code patch
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Greg KH <gregkh@suse.de>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"mjg@redhat.com" <mjg@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20111121205139.GA11055@suse.de>
References: <1321896029.11647.50.camel@wwguy-huron>
	 <20111121182634.GA7037@suse.de> <1321897113.11647.52.camel@wwguy-huron>
	 <20111121205139.GA11055@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 13:15:28 -0800
Message-ID: <1321910128.11647.56.camel@wwguy-huron> (sfid-20111121_231123_297155_8E89906C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-21 at 12:51 -0800, Greg KH wrote:
> On Mon, Nov 21, 2011 at 09:38:33AM -0800, Guy, Wey-Yi wrote:
> > On Mon, 2011-11-21 at 10:26 -0800, Greg KH wrote:
> > > On Mon, Nov 21, 2011 at 09:20:29AM -0800, Guy, Wey-Yi wrote:
> > > > Hi John/Garrett/Greg,
> > > > 
> > > > We test the ASPM patch with the Intel WiFi devices on number of
> > > > platforms and the improvement is huge.
> > > 
> > > What "ASPM patch"?
> > 
> > https://lkml.org/lkml/2011/11/11/212
> 
> Ok, yet you feel that my statement there is not sufficient right now?

oh, I am just want to let you know we test this patch and the result is
very good, it make huge improvement with our devices.

> 
> > > > In the "idle associated" mode, the power consumption number for our new
> > > > devices down to ~40mW range from over 120mW.
> > > > 
> > > > We will do more testing but I will suggest to apply this patch to the
> > > > stable release.
> > > 
> > > What is the git commit id of this patch?  Have you read
> > > Documentation/stable_kernel_rules.txt for how to properly submit a patch
> > > to the stable kernel trees?
> 
> You failed to answer this :(

oh here is the patch already in linux-next tree

commit 7f92c4f7d92a7558ed7eb29fa59e1c98402dc3c2
Author: Matthew Garrett <mjg@redhat.com>
Date:   Thu Nov 10 16:38:33 2011 -0500

    PCI: Rework ASPM disable code
    
    Right now we forcibly clear ASPM state on all devices if the BIOS
indicates
    that the feature isn't supported. Based on the Microsoft
presentation
    "PCI Express In Depth for Windows Vista and Beyond", I'm starting to
think
    that this may be an error. The implication is that unless the
platform
    grants full control via _OSC, Windows will not touch any PCIe
features -
    including ASPM. In that case clearing ASPM state would be an error
unless
    the platform has granted us that control.
    
    This patch reworks the ASPM disabling code such that the actual
clearing
    of state is triggered by a successful handoff of PCIe control to the
OS.
    The general ASPM code undergoes some changes in order to ensure that
the
    ability to clear the bits isn't overridden by ASPM having already
been
    disabled. Further, this theoretically now allows for situations
where
    only a subset of PCIe roots hand over control, leaving the others in
the
    BIOS state.
    
    It's difficult to know for sure that this is the right thing to do -
    there's zero public documentation on the interaction between all of
these
    components. But enough vendors enable ASPM on platforms and then set
this
    bit that it seems likely that they're expecting the OS to leave them
alone.
    
    Measured to save around 5W on an idle Thinkpad X220.
    
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>


Thanks
Wey


