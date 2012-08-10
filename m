Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:53437 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267Ab2HJNg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 09:36:28 -0400
Received: by wgbfm10 with SMTP id fm10so1183704wgb.1
        for <linux-wireless@vger.kernel.org>; Fri, 10 Aug 2012 06:36:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120810132054.GA2229@tuxdriver.com>
References: <1344544690-11280-1-git-send-email-zajec5@gmail.com>
	<5024CE29.5030500@broadcom.com>
	<CACna6rzxb4jtFWOQcRvPxPE0KhTXP5P8fckaN-KaZMCyvq0Lhw@mail.gmail.com>
	<5024FD42.6070307@hauke-m.de>
	<CACna6rxLe6PKqdfG7XVb4f7XH5nk_dKZX-sC1-KS19AManD1+Q@mail.gmail.com>
	<20120810132054.GA2229@tuxdriver.com>
Date: Fri, 10 Aug 2012 15:36:26 +0200
Message-ID: <CACna6rzt8T4JLQWg2Nxw+_jf7u4B-534YF+7yjafNegm9_kBLA@mail.gmail.com> (sfid-20120810_153730_903430_886DD2BB)
Subject: Re: [PATCH wireless?] bcma: keep info about parallel flash presentence
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2012/8/10 John W. Linville <linville@tuxdriver.com>:
> On Fri, Aug 10, 2012 at 02:25:48PM +0200, Rafał Miłecki wrote:
>> 2012/8/10 Hauke Mehrtens <hauke@hauke-m.de>:
>> > On 08/10/2012 11:32 AM, Rafał Miłecki wrote:
>> >> 2012/8/10 Arend van Spriel <arend@broadcom.com>:
>> >>> On 08/09/2012 10:38 PM, Rafał Miłecki wrote:
>> >>>> This allows drivers to access flash conditionally and stop crashing some
>> >>>> devices.
>> >>>>
>> >>>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> >>>> Acked-by: Hauke Mehrtens <hauke@hauke-m.de>
>> >>>> ---
>> >>>> John: I suggest taking it for wirelesss, AKA fix
>> >>>
>> >>> Maybe you could mentioned devices and/or drivers crashes without this patch?
>> >>
>> >> Yes, sure! The problematic one for me is arch/mips/bcm47xx/nvram.c.
>> >> Right now it assumes every BCMA board has pflash. I'll submit fix for
>> >> mips tree when this patch hits it.
>> >
>> > Letting this patches get merged into the wireless tree and an other
>> > patches which depends on this one into the mips tree will cause
>> > problems, because the wireless tree only gets merged into the mips tree
>> > indirectly round about the rc1 release in form of the rc1 release done
>> > by Linus.
>> >
>> > The patch to arch/mips/bcm47xx/nvram.c will depend on this one and you
>> > should submit them to the same tree.
>>
>> I'm planning to wait until rc2 (or rc3 if needed). I know the dependency :)
>
> Which rc2?  Because Ralf probably won't have it in his tree until
> the 3.7-rc1 timeframe...

Ouch, I hoped bcma fix will go into 3.6-rc2 or 3.6-rc3 and Ralf will
rebase his tree against Linus at some point...

OK, I'll try to send additional bcm47xx fix through yours tree (after
Ralf accepts it).

-- 
Rafał
