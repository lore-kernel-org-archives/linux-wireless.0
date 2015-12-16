Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39477 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbbLPSxV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 13:53:21 -0500
Subject: Re: About adding support for MT76x2U to Linux kernel
To: =?UTF-8?Q?Jakub_Kici=c5=84ski?= <moorray3@wp.pl>,
	=?UTF-8?Q?Tuomas_R=c3=a4s=c3=a4nen?= <tuomasjjrasanen@tjjr.fi>
References: <20150814081526.GC20192@hackpad.Elisa>
 <20150814143229.61440072@north>
Cc: linux-wireless@vger.kernel.org, tuomasjjrasanen@opinsys.fi,
	Linus Walleij <linus.walleij@linaro.org>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <5671B310.2080200@openwrt.org> (sfid-20151216_195327_645585_E40FA1F1)
Date: Wed, 16 Dec 2015 19:53:04 +0100
MIME-Version: 1.0
In-Reply-To: <20150814143229.61440072@north>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-08-14 14:32, Jakub Kiciński wrote:
> CC: Linus W who was hacking on mt7630e recently.
> 
> On Fri, 14 Aug 2015 11:15:26 +0300, Tuomas Räsänen wrote:
>> Hi
>> 
>> I'm very interested in adding support (especially AP mode) for MT76x2U
>> USB-dongles to Linux kernel. I'm aware of the work you both have done, Felix's
>> work on MT76x2 PCI-devices and Jakub's work to add support for MT7601U. So I
>> guess no one knows this exact problem domain better than you (perhaps excluding
>> MediaTek's subcontractors who wrote the original vendor driver), that is why I'm
>> writing specifically to you.
>> 
>> I have ASUS USB-N53_B1 adapter (0b05:180b) as a test device:
>> https://wikidevi.com/wiki/ASUS_USB-N53_B1
>> 
>> As far as I know, no one has been / is working on MT76x2U USB-dongles, please
>> correct me if I'm wrong.
>> 
>> I have a strong system programming background, some knowledge on 802.11 in
>> general, but no actual experience in Linux kernel programming. So I'm pretty
>> confident that I'll have many questions to throw at you before I have managed to
>> make anything functional.
>> 
>> So, to get started, I was wondering what would be the best way forward. I can
>> think of two reasonable approaches:
>> 
>>   #1 Base the new driver on Felix's mt76 and modify it to work on USB-bus
>>      instead of PCI.
>> 
>>   #2 Base the new driver on Jakub's mt7601u and modify it to handle mt76x2u
>>      devices by using Felix's mt76 and the vendor driver as a reference.
>> 
>> Of course there's the third option to write it from scratch based solely on the
>> vendor driver, but because you have already done such a great job in
>> interpreting the outdated and quite ugly (subjective view?) vendor driver code,
>> that would be foolish.
> 
> There is a fourth option: merge mt76 and mt7601u and add support for
> mt76x2u along the way ;)
> 
>> At first I had a hunch that #1 would be the easiest way forward, but now that I
>> skimmed through the code, I'm beginning to think that approach #2 has the least
>> resistance. However, I'm not necessarily looking for the easiest way but *the
>> best/right* way. So any ideas, opinions and thoughts are more than welcome.
> 
> Hardware wise your chipsets will be closer to the ones Felix is
> supporting and mt76 has AP support as well (which mt7601u is lacking).
> But mt76 is not upstream and I don't think USB is a priority there...
> 
> On my side, I won't be able to help you or do mentoring for next few
> months for contractual reasons :(
Hey guys,

I just wanted to let you know that I'm making good progress with mt76
support for mt7603e chips.

I think I finally have a good code structure in place to deal with with
very different chipsets.
While mt7603 has an entirely different register layout, MCU packet
format and MAC interface, I was able to share a lot of code between 76x2
and 7603 with very little indirection.

Once I'm done with mt7603 bringup (monitor mode rx already works), I
plan on submitting mt76 upstream, and then we can see about adding
support for 76x2u, or even merging the hardware support for mt7601u.

You can check out my work in the mt7603 branch here:
https://github.com/openwrt/mt76/tree/mt7603

- Felix
