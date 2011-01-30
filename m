Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:60189 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504Ab1A3M2x convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 07:28:53 -0500
Received: by qyk12 with SMTP id 12so5165677qyk.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 04:28:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4D444F62.7040206@erley.org>
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com>
	<AANLkTinhxNK9a6E2iGdFnvQuk-j7W=Pax7WirH08E5eQ@mail.gmail.com>
	<AANLkTikqR=aX+icFSKxkMNCZdbEgPmKR--gAPePgW6vM@mail.gmail.com>
	<20110128161612.GC2452@redhat.com>
	<AANLkTimPoG2wEY-XOpfW99qpK6ohe5k3wR6XjtSYCH4L@mail.gmail.com>
	<4D444F62.7040206@erley.org>
Date: Sun, 30 Jan 2011 13:28:52 +0100
Message-ID: <AANLkTintFR97y8JN4Le2i6d+Uu-8O-dnoET8+FMdwCgt@mail.gmail.com>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Pat Erley <pat-lkml@erley.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Brian Prodoehl <bprodoehl@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 29 stycznia 2011 18:33 użytkownik Pat Erley <pat-lkml@erley.org> napisał:
> On 01/29/11 04:37, Rafał Miłecki wrote:
>>
>> W dniu 28 stycznia 2011 17:16 użytkownik Stanislaw Gruszka
>> <sgruszka@redhat.com>  napisał:
>>>
>>> On Thu, Jan 27, 2011 at 06:19:56PM +0100, Rafał Miłecki wrote:
>>>>
>>>> What I've bought is following adapter:
>>>>
>>>> http://allegro.pl/adapter-wifi-mini-pci-e-na-pci-e-3-anteny-kp13-i1429732145.html
>>>
>>> I'm using adapters form http://www.hwtools.net/ , they work pretty well
>>> for me,
>>> but they are also quite expensive.
>>
>> Yeah, they have adapters few times more expensive than my one :(
>>
>>
>> Yesterday my friend was nice (and brave :P) enough to let me open his
>> notebook and test my card in it. Card was detected just fine in his
>> Windows 7.
>>
>> Today I managed to test my adapter (with my Broadcom card inside) in
>> some other PC with PCI Express x1. It was detected again! Motherboard
>> in this PC is: Asus/Pegatron IPMTB-TK.
>>
>>
>> So:
>> 1) My Broadcom card is fine
>> 2) My adapted is fine
>>
>> There must be problem with my motherboard/BIOS/PCI Express x1 slot.
>>
>> I'm much happier now when I know I don't need to return that adapters
>> (I bought 2) :)
>>
> My experience with pci-e bridge cards like this and not being detected:
>
> If your mobo supports SLI, but you're not using SLI, disable detecting
> sli, this caused mine to not be detected.  In my bios, the setting set
> the slots into x16,x1,x1,x1 instead of x8,x1,disabled,x8.
>
> If you have a pci-e serial card using an old TI chipset, they seem to
> block enumeration and detecting in the following slots.
>
> I'm using an AR9280 in a riser that shipped with some other card I never
> tested.
>
> What I would test is re-arranging the pci-e cards (if you have more than
> one), and look into sli detection if you're not using it.
>
> Good Luck!

Thanks for your help! My motherboard has integrated VIA GPU and
possibility to add external GPU. I can set in BIOS "Primary Display
Adapter" to "PCI" or "PCI-E".

However, that was not the source of my problems. After digging more in
BIOS settings I've finally noticed:
Advanced → Onboard Device COnfiguration → Ex/SATA-PCI-E*1 Option
with two values to choose:
1) Ex-SATA
2) PCI-E*1

So... My PCI Express x1 slot was working in some Ex-SATA mode! After
switching that, my WiFi card is detected fine finally! :)

Thanks everybody for help and sorry for bothering you with problems
that came from my incorrect BIOS configuration... Ups :)

-- 
Rafał
