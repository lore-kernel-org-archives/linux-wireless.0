Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2244 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab0DZVnv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 17:43:51 -0400
Message-ID: <4BD60914.1070200@gmail.com>
Date: Mon, 26 Apr 2010 23:43:48 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Luis Correia <luis.f.correia@gmail.com>
Subject: Re: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register
 initialization.
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com> <201004261302.14682.helmut.schaa@googlemail.com> <4BD5EEFC.6050003@gmail.com> <201004262159.34077.helmut.schaa@googlemail.com>
In-Reply-To: <201004262159.34077.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/26/10 21:59, Helmut Schaa wrote:
> Am Montag 26 April 2010 schrieb Gertjan van Wingerde:
>> On 04/26/10 13:02, Helmut Schaa wrote:
>>> Am Sonntag 11 April 2010 schrieb Gertjan van Wingerde:

<snip>

>>>
>>> This part is actually needed for getting rx to work on the SoC devices.
>>
>> Hmm, interesting, as I don't know where this code actually came from. It isn't needed for
>> PCI devices in general (at least not the PCI devices I've checked), so it may be specific to SoC.
>>
>>>
>>> Should I post a patch that adds this code again and is only executed on SoC
>>> devices with rf3020, 3021 and 3022?
>>>
>>
>> OK. I have just checked the two RT2872 based devices I have (one PCI one and one USB one),
>> and both of them act very strangely.
> 
> Strangely ;) ? The SoC device was basically able to transmit frames but
> could't receive at all (at least that was my impression). Do you have a
> different issue?

Turns out I forgot to enable the PCIe one in my AP's ACL, so it simply was refused by the AP.
This card now works perfectly without your patch. Now, the difference is that my RT2872 is actually
accompanied by an RF2720 RF chipset, so there is a difference there.

> 
>> I'll check against the Ralink SoC driver code that I've got as to how the initialization should actually
>> be.
> 
> Ok.
> 

The Ralink SoC driver code that I have follows exactly the procedure that was removed. So, I guess the original
code came from there, but it actually isn't needed for RT2860 devices. The Ralink code only runs this when an
RT2872 revision 0x0200 is accompanied with an RF3020, an RF3021 or an RF3022. For the benefit of correctness
I suggest we mimmick this in rt2x00, and only execute the sequence in those cases.
And, BTW, we can stop RF CSR initialization right after programming these static values. The Ralink driver doesn't
do anything else as well.
Finally, the Ralink driver has two more RF CSR writes in this sequence. It writes the value 0x00 to both RF CSR 30
and RF CSR 31. I suggest we add that to the sequence that will be added to rt2x00.

--
Gertjan.
