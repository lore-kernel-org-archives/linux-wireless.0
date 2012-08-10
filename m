Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38576 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab2HJMZt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 08:25:49 -0400
Received: by wgbdr13 with SMTP id dr13so1438841wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 05:25:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5024FD42.6070307@hauke-m.de>
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
	<5024CE29.5030500@broadcom.com>
	<CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
	<5024FD42.6070307@hauke-m.de>
Date: Fri, 10 Aug 2012 14:25:48 +0200
Message-ID: <CACna6rxLe6PKqdfG7XVb4f7XH5nk_dKZX-sC1-KS19AManD1+Q@mail.gmail.com> (sfid-20120810_142553_031354_4D1CE547)
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash presentence
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/10 Hauke Mehrtens <hauke@hauke-m.de>:
> On 08/10/2012 11:32 AM, Rafał Miłecki wrote:
>> 2012/8/10 Arend van Spriel <arend@broadcom.com>:
>>> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
>>>> This allows drivers to access flash conditionally and stop crashing some
>>>> devices.
>>>>
>>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>>>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> ---
>>>> John: I suggest taking it for wirelesss, AKA fix
>>>
>>> Maybe you could mentioned devices and/or drivers crashes without this patch?
>>
>> Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
>> Right now it assumes every BCMA board has pflash. I'll submit fix for
>> mips tree when this patch hits it.
>
> Letting this patches get merged into the wireless tree and an other
> patches which depends on this one into the mips tree will cause
> problems, because the wireless tree only gets merged into the mips tree
> indirectly round about the rc1 release in form of the rc1 release done
> by Linus.
>
> The patch to arch/mips/bcm47xx/nvram.c will depend on this one and you
> should submit them to the same tree.

I'm planning to wait until rc2 (or rc3 if needed). I know the dependency :)

-- 
Rafał
