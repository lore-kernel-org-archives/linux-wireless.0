Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f51.google.com ([209.85.219.51]:45064 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3C3V0t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Mar 2013 17:26:49 -0400
Received: by mail-oa0-f51.google.com with SMTP id g12so1170722oah.10
        for <linux-wireless@vger.kernel.org>; Sat, 30 Mar 2013 14:26:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
 <20130304134949.GB3021@redhat.com> <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com>
 <20130304154832.GD3021@redhat.com> <CANUX_P22AkqeOROP1QHzp20wGWgDbRzy+9FZy2KvHLXCQ5AVnA@mail.gmail.com>
 <CAErSpo5gVsUxB6ebQGAN-7jsZiRYZ+SyJn5gKZrSuOzzkJ-QjQ@mail.gmail.com> <CANUX_P2-V0-=sfofxYwAYCRvqPPf5Z2wy6CUNQmGQQ2NqjZJ_A@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 30 Mar 2013 15:26:28 -0600
Message-ID: <CAErSpo4xmDU2O35ge342nMuiVyDkzSGNRaz2O7-w6jDz_eBgyg@mail.gmail.com> (sfid-20130330_222704_186151_3045CAFE)
Subject: Re: is L1 really disabled in iwlwifi
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Roman Yepishev <roman.yepishev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 30, 2013 at 12:38 PM, Emmanuel Grumbach <egrumbach@gmail.com> wrote:
>>>
>>> Anyway - I think I will just remove this pci_disable_link_state call
>>> and hopefully, it will stay long enough in linux-next so that people
>>> will report issues before it get into linux.
>>> I don't like leaving that code if it doesn't do anything.
>>
>> I think we broke at least some cases of pci_disable_link_state() a
>> while back.  I'd like to fix it rather than just removing calls to it.
>>
>> Can someone collect a complete dmesg log and "lspci -vv" output?
>>
>
> I will. But I am on vacation right now and my linux box is not
> accessible right now...
> In any case, what you'll see is that ASPM is enabled (L1 enabled with
> or without driver).
> We are also seeing some really weird stuff (which I can't reproduce of
> course) like HW becoming not accessible, I guess it would be worth
> trying to *really* disable L1. I can tweak that in the code of the
> driver and tell the NIC that L1 is disabled.
>
>         /* Disable L1-Active */
>         iwl_set_bits_prph(trans, APMG_PCIDEV_STT_REG,
>                           APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
>
> Do you have an idea about *when* did pci_disable_link_state() break?

No, not yet.  After we figure out exactly what the problem is, we
should be able to determine when it broke.

If I understand correctly, you have CONFIG_PCIEASPM=y, the iwlwifi
driver uses pci_disable_link_state() to disable L1, but the link state
stays in L0 all the time.  So I think we should look at the dmesg log,
"lspci -vv" output before loading iwlwifi, and "lspci -vv" output
after loading iwlwifi.

Bjorn
