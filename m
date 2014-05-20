Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:14686 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaETJeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2014 05:34:18 -0400
Message-ID: <537B2198.5020807@broadcom.com> (sfid-20140520_113422_152628_58E66798)
Date: Tue, 20 May 2014 11:34:16 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Robert P. J. Day" <rpjday@crashcourse.ca>,
	<linux-wireless@vger.kernel.org>
Subject: Re: if i deselect PCIEPORTBUS, why are iwlwifi PCIE modules still
 being compiled?
References: <alpine.LFD.2.11.1405200342050.10462@localhost>	 (sfid-20140520_101149_157876_1874D563) <1400574452.4474.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1400574452.4474.2.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/20/14 10:27, Johannes Berg wrote:
> On Tue, 2014-05-20 at 03:49 -0400, Robert P. J. Day wrote:
>>    quite possibly a silly question (which has never stopped me before),
>> but in perusing the PCIE code in the kernel source, i was looking for
>> sample code to demo in a classroom setting and picked on
>> drivers/net/wireless/iwlwifi/pcie, which i was *assuming* was
>> PCIE-dependent -- specifically, i was going to demo the Advanced-N
>> 6235 PCIE wifi card on an intel galileo board.
>>
>>    but i thought it was a bit strange that the pcie/ subdirectory there
>> doesn't seem to depend on PCIEPORTBUS. as a test, i deselected
>> PCIEPORTBUS in a configuration and did a rebuild, and the source in
>> the pcie/ directory was recompiled.
>>
>>    am i misunderstanding the function of the kernel config variable
>> PCIEPORTBUS? i notice that .../iwlwifi/Makefile includes the line:
>>
>>    iwlwifi-objs  += pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
>>
>> which simply compiles those files with no regard to dependency. can
>> someone clarify this? thanks.
>
> The whole driver depends on CONFIG_PCI, maybe it should depend on
> something more PCIe specific, but that wasn't easy to sort out, and the
> APIs it needs aren't PCIe specific afaict.

Correct. A number of PCIe specific calls are under CONFIG_PCI, ie. 
pcie_capability_*() et al.

Regards,
Arend

> johannes
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

