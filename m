Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:48635 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab3CDO5s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 09:57:48 -0500
MIME-Version: 1.0
In-Reply-To: <20130304134949.GB3021@redhat.com>
References: <CANUX_P3F5YhbZX3WGU-j1AGpbXb_T9Bis2ErhvKkFMtDvzatVQ@mail.gmail.com>
	<20130304134949.GB3021@redhat.com>
Date: Mon, 4 Mar 2013 16:57:46 +0200
Message-ID: <CANUX_P0JhuVWcQjTckYzG8eBb2MtT_=prKqV38mCpVjfLmGtCA@mail.gmail.com> (sfid-20130304_155753_042777_39EBEB7A)
Subject: Re: is L1 really disabled in iwlwifi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-pci@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>
>>       /* W/A - seems to solve weird behavior. We need to remove this if we
>>        * don't want to stay in L1 all the time. This wastes a lot of power */
>>       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
>>                              PCIE_LINK_STATE_CLKPM);
>>
>> Now, I took a laptop with 3.7.9 (that supports L1) and measured power.
>> I would expect to see that as long as the driver isn't loaded, the
>> power consumption is low (L1 enabled), and when I load the driver, the
>> power consumption rises because L1 gets disabled.
>> But this is not what I see. I see more the less the same numbers
>> before and after driver load.
>> I don't remember exactly the numbers, but I do remember they were low
>> (around 1mA or so) - but I really need to check.
>> I also removed the code above, and it didn't change anything.
>> Can it be that this code doesn't have any effect?
>
> Depend on BIOS settings ASPM can be enabled or disabled on the whole
> system. I think kernel can change settings globally as well.

Obviously kernel can change things here. I have 3.1 (!) and 3.7 on the
same machines, on the first, ASPM is disabled, on the latter it is
enabled.

> Reloading driver can not be enough to check that, try to reboot the
> system with iwlwifi module blacklisted and check lspci -vvv to see
> LnkCtl ASPM settings.
>

This is what I did. On 3.7, lspci tells me that ASPM is enabled before
I load the module. And same after I load the module.

> Additionally despite above code, iwlwifi try to enable L0S in
> iwl_pcie_apm_config(), what is basically wrong.
>

Right, good point. The thing is that the device doesn't know how to do
both L0S and L1. This is the origin of this code. But obviously, we
first need to make sure that L0S is supported in the LnkCtl. Will
check.
Thanks!

So - what about just removing this code?
