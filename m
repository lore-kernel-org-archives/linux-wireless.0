Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li59-9.members.linode.com ([97.107.129.9]:52975 "EHLO erley.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1A2RlQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jan 2011 12:41:16 -0500
Message-ID: <4D444F62.7040206@erley.org>
Date: Sat, 29 Jan 2011 12:33:22 -0500
From: Pat Erley <pat-lkml@erley.org>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	Brian Prodoehl <bprodoehl@gmail.com>,
	linux-wireless@vger.kernel.org,
	b43-dev <b43-dev@lists.infradead.org>
Subject: Re: Mini PCIeWiFi card not detected in non-mini adapter
References: <AANLkTinrAgtjz-3Mv0ik9x6sRRvnvUQZn4jQX97mG7it@mail.gmail.com> <AANLkTinhxNK9a6E2iGdFnvQuk-j7W=Pax7WirH08E5eQ@mail.gmail.com> <AANLkTikqR=aX+icFSKxkMNCZdbEgPmKR--gAPePgW6vM@mail.gmail.com> <20110128161612.GC2452@redhat.com> <AANLkTimPoG2wEY-XOpfW99qpK6ohe5k3wR6XjtSYCH4L@mail.gmail.com>
In-Reply-To: <AANLkTimPoG2wEY-XOpfW99qpK6ohe5k3wR6XjtSYCH4L@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/11 04:37, Rafał Miłecki wrote:
> W dniu 28 stycznia 2011 17:16 użytkownik Stanislaw Gruszka
> <sgruszka@redhat.com>  napisał:
>> On Thu, Jan 27, 2011 at 06:19:56PM +0100, Rafał Miłecki wrote:
>>> What I've bought is following adapter:
>>> http://allegro.pl/adapter-wifi-mini-pci-e-na-pci-e-3-anteny-kp13-i1429732145.html
>>
>> I'm using adapters form http://www.hwtools.net/ , they work pretty well for me,
>> but they are also quite expensive.
>
> Yeah, they have adapters few times more expensive than my one :(
>
>
> Yesterday my friend was nice (and brave :P) enough to let me open his
> notebook and test my card in it. Card was detected just fine in his
> Windows 7.
>
> Today I managed to test my adapter (with my Broadcom card inside) in
> some other PC with PCI Express x1. It was detected again! Motherboard
> in this PC is: Asus/Pegatron IPMTB-TK.
>
>
> So:
> 1) My Broadcom card is fine
> 2) My adapted is fine
>
> There must be problem with my motherboard/BIOS/PCI Express x1 slot.
>
> I'm much happier now when I know I don't need to return that adapters
> (I bought 2) :)
>
My experience with pci-e bridge cards like this and not being detected:

If your mobo supports SLI, but you're not using SLI, disable detecting
sli, this caused mine to not be detected.  In my bios, the setting set
the slots into x16,x1,x1,x1 instead of x8,x1,disabled,x8.

If you have a pci-e serial card using an old TI chipset, they seem to
block enumeration and detecting in the following slots.

I'm using an AR9280 in a riser that shipped with some other card I never
tested.

What I would test is re-arranging the pci-e cards (if you have more than
one), and look into sli detection if you're not using it.

Good Luck!

--
Pat Erley
