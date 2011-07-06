Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40575 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab1GFMbD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 08:31:03 -0400
Received: by iwn6 with SMTP id 6so6027949iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jul 2011 05:31:01 -0700 (PDT)
Message-ID: <4E145581.4040806@lwfinger.net> (sfid-20110706_143108_189346_6ECC6B89)
Date: Wed, 06 Jul 2011 07:30:57 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Carsten Rietzschel <cr7@darav.de>
CC: Julian Calaby <julian.calaby@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>, IvDoorn@gmail.com,
	gwingerde@gmail.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com
Subject: Re: RALINK rt2800pci , Patch for Device [1814:539f]
References: <4E143FCF.8030201@darav.de> <CAGXE3d-nsc3qS1pyayUqZg9AB-572FFhoB+r_ZWP9B6n=xhYHA@mail.gmail.com> <CAGRGNgUPOEFwpeuy4ASv8wYOa9_9ZzUGokpF-CvwNXpBZ0AS8Q@mail.gmail.com> <4E144581.6000708@darav.de>
In-Reply-To: <4E144581.6000708@darav.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2011 06:22 AM, Carsten Rietzschel wrote:
> Thanks,
>
> here we go with a changed Signed-off-by-Line.
> In case it's usefull even it's already in the git-tree.
>
> Signed-off-by: Carsten Rietzschel<cr7@darav.de>

There is bit more to proper patch submission. The subject of the Email should be 
"[PATCH] rt2800pci: Add device ID [1814:539f]".

Inside the patch, the Signed-off-by line should be followed by a line with 3 
dashes. Anything above those 3 dashes will be in the commit message for the 
patch. The stuff shown above is not appropriate. That kind of message can be 
added after the 3 dashes as instructions to the maintainer, etc. If you do that, 
then another line of 3 dashes goes after that.

I don't think it causes any problems, but I usually get rid of any quoted 
material after the patch.

To learn the whole business of patching, see the file at 
Documentation/SubmittingPatches in any source tree.

Larry

>
> diff -ur linux-3.0_rc2/drivers/net/wireless/rt2x00/rt2800pci.c
> linux-3.0_rc2_patched/drivers/net/wireless/rt2x00/rt2800pci.c
> --- linux-3.0_rc2/drivers/net/wireless/rt2x00/rt2800pci.c    2011-07-06
> 12:46:13.251676122 +0200
> +++ linux-3.0_rc2_patched/drivers/net/wireless/rt2x00/rt2800pci.c
> 2011-07-06 12:44:38.381673254 +0200
> @@ -1158,6 +1158,7 @@
>   #endif
>   #ifdef CONFIG_RT2800PCI_RT53XX
>       { PCI_DEVICE(0x1814, 0x5390) },
> +    { PCI_DEVICE(0x1814, 0x539f) },
>   #endif
>       { 0, }
>   };
>
> cya.
> Carsten
>
> Am 06.07.2011 13:02, schrieb Helmut Schaa:
>> Nice.
>>
>> On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel<cr7@darav.de>  wrote:
>>> Hello together,
>>>
>>> attached find a small patch for the RALINK wireless driver.
>>> It's just adding one PCI-ID for:
>>>
>>> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>>>     Subsystem: Hewlett-Packard Company Device [103c:1637]
>>>     Flags: bus master, fast devsel, latency 0, IRQ 17
>>>     Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>>>     Capabilities: [40] Power Management version 3
>>>     Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>>>     Capabilities: [70] Express Endpoint, MSI 00
>>>     Capabilities: [100] Advanced Error Reporting
>>>     Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>>>     Kernel driver in use: rt2800pci
>>>     Kernel modules: rt2800pci
>>>
>>> It's for instance used in the HP DM1Z (Fusion) Netbook.
>>> I use this patch now for several weeks - starting with 2.3.29 up to
>>> 3.0-rc2 kernel. No problems so far.
>>>
>>> *Signed*-*off*-by: Carsten Rietzschel<cr7 [at] darav [dot] de>
>> That should be "Signed-off-by:". Mind to resubmit?
>>
>> Otherwise no objections from my side :)
>> Helmut
>
>
> Am 06.07.2011 13:15, schrieb Julian Calaby:
>> On Wed, Jul 6, 2011 at 21:02, Helmut Schaa<helmut.schaa@googlemail.com>  wrote:
>>> Nice.
>>>
>>> On Wed, Jul 6, 2011 at 12:58 PM, Carsten Rietzschel<cr7@darav.de>  wrote:
>>>> Hello together,
>>>>
>>>> attached find a small patch for the RALINK wireless driver.
>>>> It's just adding one PCI-ID for:
>>>>
>>>> 02:00.0 Network controller [0280]: Ralink corp. Device [1814:539f]
>>>>     Subsystem: Hewlett-Packard Company Device [103c:1637]
>>>>     Flags: bus master, fast devsel, latency 0, IRQ 17
>>>>     Memory at f0100000 (32-bit, non-prefetchable) [size=64K]
>>>>     Capabilities: [40] Power Management version 3
>>>>     Capabilities: [50] MSI: Enable- Count=1/32 Maskable- 64bit+
>>>>     Capabilities: [70] Express Endpoint, MSI 00
>>>>     Capabilities: [100] Advanced Error Reporting
>>>>     Capabilities: [140] Device Serial Number 00-00-b2-7f-05-da-f8-c0
>>>>     Kernel driver in use: rt2800pci
>>>>     Kernel modules: rt2800pci
>>>>
>>>> It's for instance used in the HP DM1Z (Fusion) Netbook.
>>>> I use this patch now for several weeks - starting with 2.3.29 up to
>>>> 3.0-rc2 kernel. No problems so far.
>>>>
>>>> *Signed*-*off*-by: Carsten Rietzschel<cr7 [at] darav [dot] de>
>>> That should be "Signed-off-by:". Mind to resubmit?
>> And, IIRC, you shouldn't censor your email address.
>>
>> Thanks,
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

