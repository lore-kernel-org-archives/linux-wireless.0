Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54275 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933920Ab3D3WqR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 18:46:17 -0400
Received: by mail-ob0-f174.google.com with SMTP id wc20so900107obb.5
        for <linux-wireless@vger.kernel.org>; Tue, 30 Apr 2013 15:46:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com>
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
 <CANUX_P0hpx8NNvX6cJXfOZMNYN8hrEF-gzf9hBN2Uz=k0WiwgA@mail.gmail.com> <CANUX_P1JnFk7yovC7kXBMDWiErGhvzDQrNCm8te39m41SonCNg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 30 Apr 2013 16:45:56 -0600
Message-ID: <CAErSpo5WbdCx0iyt14bJxCiNBtUWjT2rMeg5YwNQaRt=M+_v8Q@mail.gmail.com> (sfid-20130501_004622_099909_B2A2A273)
Subject: Re: is L1 really disabled in iwlwifi
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	Matthew Garrett <matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[+cc Wei-Yi, Matthew]

On Tue, Apr 30, 2013 at 4:57 AM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>
>>> Sorry, I haven't had a chance to look at this yet.  Can you please
>>> attach the *complete* dmesg and lspci output, not just the parts that
>>> mention iwlwifi?  Some of this depends on other PCI core stuff, like
>>> what happened with the _OSC evaluation when we discovered the PCI host
>>> bridge.
>>>
>>
>> Here is the info you wanted. Same config file as before.
>> Note that I now have two WiFi NICs connected.
>
> Any chance you'll find time for me? :-)

Thanks for reminding me again; I had forgotten all about this.  I
opened https://bugzilla.kernel.org/show_bug.cgi?id=57331 and attached
your logs there.

Synopsis for Wei-Yi and Matthew: after 1a7123cdd9, iwlwifi calls
pci_disable_link_state() to prevent the link from entering L1, which
avoided "inexplicable PCIe disconnects."  pci_disable_link_state() has
always been a no-op when aspm_disabled is set, and we set it whenever
the BIOS declines to give us _OSC control.

In Emmanuel's case, we don't get _OSC control, so
pci_disable_link_state() does nothing.

I'm not convinced iwlwifi really needs to disable the link power
management states in the first place -- the 1a7123cdd9 changelog isn't
very convincing, and I'm not aware of any reported issues even though
we're actually leaving them enabled in many cases.

More generally, I don't think the pci_disable_link_state() interface
is very useful because it often doesn't do what it claims, and the
caller has no indication.

Wei-Yi, can you tell us anything about whether iwlwifi really needs to
disable link power management?

Bjorn
