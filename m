Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:44782 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab3EAIb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 May 2013 04:31:26 -0400
MIME-Version: 1.0
In-Reply-To: <1367362536.9976.9.camel@x230>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
	<20130304134949.GB3021@redhat.com>
	<CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
	<20130304154832.GD3021@redhat.com>
	<CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
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
	<1367362536.9976.9.camel@x230>
Date: Wed, 1 May 2013 11:31:25 +0300
Message-ID: <CANUX_P1sS8+3s-8-TyovHEwpa5qgQDj4W8P_hvfQjE2MKcTNEA@mail.gmail.com> (sfid-20130501_103146_203595_D2AF555D)
Subject: Re: is L1 really disabled in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[from Bjorn's mail]
> In Emmanuel's case, we don't get _OSC control, so
> pci_disable_link_state() does nothing.

Right, but this is true with the specific log I sent to you. Is it
possible that another platform  / BIOS, we *will* get _OSC control and
that pci_disable_link_state() will actually do something? In that case
I would prefer not to remove the call to pcie_disable_link_state().
Also - in the log I sent you, we don't get _OSC control, but I can see
'disabling PCIe ASPM" ... and it *is* enabled (since L1 works). So I
am kinda scratching my head here...

>
>> I'm not convinced iwlwifi really needs to disable the link power
>> management states in the first place -- the 1a7123cdd9 changelog isn't
>> very convincing, and I'm not aware of any reported issues even though
>> we're actually leaving them enabled in many cases.
>>
>> More generally, I don't think the pci_disable_link_state() interface
>> is very useful because it often doesn't do what it claims, and the
>> caller has no indication.
>
> The general issue here is that Windows will (as far as we've been able
> to determine) never touch ASPM registers unless given PCIe control via
> _OSC. Drivers are presumably able to override this by hitting
> configuration registers themselves. The pci_disable_link_state()
> functions are currently broadly equivalent to the helper functions
> provided in the Windows .inf files, and if drivers really want to
> disable the control themselves then they can do so. Renaming the
> functions to make that clearer, and possibly adding some additional
> functions to force the case, may be worthwhile.
>
> The only time this should be relevant is if (a) the BIOS has enabled L1
> on iwlwifi, (b) the BIOS has disabled ASPM control, and (c) the hardware
> doesn't work with L1 enabled. Are there really cases where that's true?
>

After having read (a bit) about _OSC I can say the following:
L1 is a must for the Windows driver - so that it doesn't sounds
reasonable that the .inf of the Windows driver for Intel Wireless NICs
disables ASPM through _OSC or through any other mechanism.
(a) - this is really platform / BIOS dependent, and I can't test all
the platform out there
(b) - ditto
(c) - the HW *should* work with L1 enabled but we may very well have a
bug in the driver. I have tried to check the way we initialize the HW
and it seems fine, but one never knows.


thanks for your time!
