Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58716 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758025Ab1FHAGM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2011 20:06:12 -0400
Received: by qwk3 with SMTP id 3so8291qwk.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jun 2011 17:06:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DEE9BCD.1030304@hauke-m.de>
References: <1307311658-15853-1-git-send-email-hauke@hauke-m.de>
	<201106061503.14852.arnd@arndb.de>
	<4DED48EA.7070001@hauke-m.de>
	<201106062353.40470.arnd@arndb.de>
	<4DEDF98C.6020905@broadcom.com>
	<4DEE9BCD.1030304@hauke-m.de>
Date: Wed, 8 Jun 2011 02:06:11 +0200
Message-ID: <BANLkTikUqj-R72XaOXnifhKv-n1ZSJMxDQ@mail.gmail.com> (sfid-20110608_020615_927939_F06F3F78)
Subject: Re: [RFC][PATCH 01/10] bcma: Use array to store cores.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	Arnd Bergmann <arnd@arndb.de>,
	George Kashperko <george@znau.edu.ua>,
	Greg KH <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"mb@bu3sch.de" <mb@bu3sch.de>,
	"b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
	"bernhardloos@googlemail.com" <bernhardloos@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/6/7 Hauke Mehrtens <hauke@hauke-m.de>:
> On 06/07/2011 12:12 PM, Arend van Spriel wrote:
>> On 06/06/2011 11:53 PM, Arnd Bergmann wrote:
>>> On Monday 06 June 2011 23:38:50 Hauke Mehrtens wrote:
>>>> Accessing chip common should be possible without scanning the hole bus
>>>> as it is at the first position and initializing most things just needs
>>>> chip common. For initializing the interrupts scanning is needed as we do
>>>> not know where the mips core is located.
>>>>
>>>> As we can not use kalloc on early boot we could use a function which
>>>> uses kalloc under normal conditions and when on early boot the
>>>> architecture code which starts the bcma code should also provide a
>>>> function which returns a pointer to some memory in its text segment to
>>>> use. We need space for 16 cores in the architecture code.
>>>>
>>>> In addition bcma_bus_register(struct bcma_bus *bus) has to be divided
>>>> into two parts. The first part will scan the bus and initialize chip
>>>> common and mips core. The second part will initialize pci core and
>>>> register the devices in the system. When using this under normal
>>>> conditions they will be called directly after each other.
>>> Just split out the minimal low-level function from the bcma_bus_scan
>>> then, to locate a single device based on some identifier. The
>>> bcma_bus_scan() function can then repeatedly allocate one device
>>> and pass it to the low-level function when doing the proper scan,
>>> while the arch code calls the low-level function directly with static
>>> data.
>>
>> If going for this we should pass struct bcma_device_id as match
>> parameter as that identifies the core appropriately although you
>> probably only want to match manufacturer and core identifiers.
>>
>> Gr. AvS
>>
>
> What is the problem with scanning the full bus?

Because full scanning needs one of the following:
1) Working alloc - not possible for SoCs
2) Hacks with wrappers, static cores info, lack of optimization (list)


> A special scan function would just skip the wrong cores so I do not see
> any advantage in that.
>
> We could build a scan function which searches for one core and uses a
> struct bcma_core stored on the stack and returns the struct bcma_core if
> it found the wanted one.

Yeah, this should be quite easy.

struct bcma_device core = bcma_early_find_core(bus, CC);
bcma_cc_init(core);


> Then we could search for chipcommon and mips
> and store then in arch code in arch/mips/bcm47xx and use them.

Not sure about this one. You have drivers for chipcommon and mips as
part of bcma. Do you need to involve arch/mips/bcm47xx to this?


> When boot
> is ready and we are searching the complete bus there is probably
> something differences in the init process from normal init as we already
> initialized chipcommon sometime earlier.

Nothing hard to handle.


> I Would prefer to scan the bus
> completely and initialize chipcommon and mips in early boot.

Really, I've nothing against scanning and splitting init into "early"
and "late". It's going back to static fields and wrappers that I don't
like :(

-- 
Rafał
