Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:34507 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab3EARNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 13:13:36 -0400
Received: by mail-ob0-f175.google.com with SMTP id wp18so1437158obc.20
        for <linux-wireless@vger.kernel.org>; Wed, 01 May 2013 10:13:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1sS8+3s-8-TyovHEwpa5qgQDj4W8P_hvfQjE2MKcTNEA@mail.gmail.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com> <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
 <20130304154832.GD3021@redhat.com> <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
 <CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com>
 <CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
 <CAErSpo4xmDU2O35ge342nMuiVyDkzSGNRaz2O7-w6jDz_eBgyg@mail.gmail.com>
 <CANUX_P2Hy02SnyYS24dyUGLv3wB3L5xkXt8Y1s+8_RG9d5ReAw@mail.gmail.com>
 <CANUX_P3znXgMN5aBZbEVx_zKpTQ98my1C_cBG5+mERFWrrrLEw@mail.gmail.com>
 <CANUX_P3Mt3X8JXq5siSijrWGkjeWbTCcdmJ-Fuv6U8jUqrFouQ@mail.gmail.com>
 <CAErSpo66=UngrHNcEDeh4gXnt5c0qJHwbxum0mBz-rSWGduLhg@mail.gmail.com>
 <CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com>
 <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com>
 <CAErSpo5WbdCx0iyt14bJxCiNBtUWjT2rMeg5YwNQaRt=M+_v8Q@mail.gmail.com>
 <1367362536.9976.9.camel@x230> <CANUX_P1sS8+3s-8-TyovHEwpa5qgQDj4W8P_hvfQjE2MKcTNEA@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 1 May 2013 11:13:15 -0600
Message-ID: <CAErSpo6OCyTy19u6Xaf=xr0TSDriwCD3n-oMc7eJyLzuJ9d60g@mail.gmail.com> (sfid-20130501_191341_791230_2D264B9E)
Subject: Re: is L1 really disabled in iwlwifi
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 1, 2013 at 2:31 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
> [from Bjorn's mail]
>> In Emmanuel's case, we don't get _OSC control, so
>> pci_disable_link_state() does nothing.
>
> Right, but this is true with the specific log I sent to you. Is it
> possible that another platform  / BIOS, we *will* get _OSC control and
> that pci_disable_link_state() will actually do something?  In that case
> I would prefer not to remove the call to pcie_disable_link_state().

Yes, absolutely, on many platforms we will get _OSC control, and
pci_disable_link_state() will work as expected.  The problem is that
the driver doesn't have a good way to know whether pci_disable_link()
did anything or not.

Today I think we have:

1) If the BIOS grants the OS permission to control PCIe services via
_OSC, pci_disable_link_state() works and L1 will be disabled.

2) If the BIOS does not grant permission, pci_disable_link_state()
does nothing and L1 may be enabled or not depending on what
configuration the BIOS did.

If the device really doesn't work reliably when L1 is enabled, we're
currently at the mercy of the BIOS -- if the BIOS enables L1 but
doesn't grant us permission via _OSC, L1 will remain enabled (as it is
on your system).

> Also - in the log I sent you, we don't get _OSC control, but I can see
> 'disabling PCIe ASPM" ... and it *is* enabled (since L1 works). So I
> am kinda scratching my head here...

The code is a bit convoluted, but I *think* the "disabling PCIe ASPM"
message basically means "Linux is not going to touch ASPM
configuration," so we just use whatever the BIOS set up.

>> The general issue here is that Windows will (as far as we've been able
>> to determine) never touch ASPM registers unless given PCIe control via
>> _OSC. Drivers are presumably able to override this by hitting
>> configuration registers themselves. The pci_disable_link_state()
>> functions are currently broadly equivalent to the helper functions
>> provided in the Windows .inf files, and if drivers really want to
>> disable the control themselves then they can do so.

The Windows mechanism (described in "PCI Express in Depth for Windows
Vista and Beyond" [1]) is to put a "Needs=PciASPMOptOut" statement in
the .inf file.

My impression is that if the BIOS enables ASPM but doesn't grant
control to the OS, Vista will generally leave the ASPM config alone.
I guess the question is what happens when a driver .inf specifies
PciASPMOptOut in this case.

I don't think it makes sense to provide this mechanism to driver
writers, but make it only work if the BIOS grants control.  The doc
doesn't mention anything about drivers needing to do anything extra to
cover the case when the BIOS didn't grant control.  So my guess is
that when PciASPMOptOut is specified, Vista will turn off ASPM for
that device in either case.  But maybe you've tested this and
determined otherwise?

>> The only time this should be relevant is if (a) the BIOS has enabled L1
>> on iwlwifi, (b) the BIOS has disabled ASPM control, and (c) the hardware
>> doesn't work with L1 enabled. Are there really cases where that's true?
>
> After having read (a bit) about _OSC I can say the following:
> L1 is a must for the Windows driver - so that it doesn't sounds
> reasonable that the .inf of the Windows driver for Intel Wireless NICs
> disables ASPM through _OSC or through any other mechanism.
> (a) - this is really platform / BIOS dependent, and I can't test all
> the platform out there
> (b) - ditto
> (c) - the HW *should* work with L1 enabled but we may very well have a
> bug in the driver. I have tried to check the way we initialize the HW
> and it seems fine, but one never knows.

Do you know if the Windows driver for these iwlwifi devices specifies
PciASPMOptOut?  If it doesn't, that's a pretty good clue that the
Linux driver shouldn't need to use pci_disable_link_state().

Bjorn

[1] http://download.microsoft.com/download/5/b/9/5b97017b-e28a-4bae-ba48-174cf47d23cd/cpa070_wh06.ppt
