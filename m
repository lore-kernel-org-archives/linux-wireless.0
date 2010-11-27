Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43780 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939Ab0K0HgM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Nov 2010 02:36:12 -0500
Received: by qyk12 with SMTP id 12so4283161qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 23:36:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201011270257.09456.8an@praha12.net>
References: <20101123191533.GP4303@makis.mantri> <AANLkTi=QquDgSAYn4HS+vupdNUTNSngt03ZKuakYu6Fd@mail.gmail.com>
 <AANLkTinC4-N7ACt4_ijTi2rs8TtQkARR1-vcaiSSaH3O@mail.gmail.com> <201011270257.09456.8an@praha12.net>
From: Jonathan Guerin <jonathan@guerin.id.au>
Date: Sat, 27 Nov 2010 17:35:55 +1000
Message-ID: <AANLkTimj1dS98Mo_pFdJ47JDXDYN7xtW11k=ZPLNuHuY@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 16/30] ath5k: Set all IFS intervals, not
 just slot time
To: =?UTF-8?B?THVrw6HFoSBUdXJlaw==?= <8an@praha12.net>
Cc: ath5k-devel@lists.ath5k.org, Nick Kossifidis <mickflemm@gmail.com>,
	jirislaby@gmail.com, br1@einfach.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 27, 2010 at 11:57 AM, Lukáš Turek <8an@praha12.net> wrote:
> On Saturday 27 November 2010 02:31:53 Nick Kossifidis wrote:
>> When we convert to core clock units it's what we should do, all
>> timings should change the same way. I don't know what this
>> aPHY-RX-START-Delay is but if it changes that way we can use absolute
>> values as we do for slot time and sifs.
>
> Although aPHY-RX-START-Delay is specified in the standard, it's not needed on
> Atheros hardware, probably the hardware starts the timeout countdown after it
> switches to RX mode (so aPHY-RX-START-Delay is added implicitly). See my
> discussion with Felix Fietkau a year ago, starting here:
> http://www.mail-archive.com/ath5k-devel@lists.ath5k.org/msg02810.html
>
> The calculation used in set_coverage_class is also the same as the one in
> Madwifi driver. When I wrote that code, I intentionally kept the old initvals
> when no coverage class was set to prevent regressions (the ACK timeout in
> initivals is larger than the one for coverage class 0, so a long distance link
> that worked before would break). Maybe I was too careful.

I'm going to be ashamed to admit that this is going way beyond my
understanding. You guys understand the hardware way more than I can.
Once registers don't exactly map to an 802.11 value, I'm honestly out
of my league. I hope I've helped find the correct values for
parameters that are lifted straight out of the standard, but I'm don't
want to make any comments when I don't know the full picture.

Cheers,

Jonathan
>
> Lukas Turek
>
