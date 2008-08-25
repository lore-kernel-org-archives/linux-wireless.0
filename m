Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:53927 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117AbYHYTgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 15:36:22 -0400
Received: by gxk9 with SMTP id 9so2645687gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 12:36:21 -0700 (PDT)
Message-ID: <40f31dec0808251236qad2118dv2b781b147d366415@mail.gmail.com> (sfid-20080825_213638_772735_43FD4988)
Date: Mon, 25 Aug 2008 22:36:20 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath5k-devel] ath5k: bad udelay call, build failure on ARM
Cc: "Martin Michlmayr" <tbm@cyrius.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080825190811.GC17297@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080825115715.GA13506@deprecation.cyrius.com>
	 <20080825190811.GC17297@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/8/25 John W. Linville <linville@tuxdriver.com>:
> On Mon, Aug 25, 2008 at 02:57:15PM +0300, Martin Michlmayr wrote:
>> ath5k fails to build on ARM with:
>>
>> __bad_udelay is specifically designed on ARM to fail when udelay is
>> called in a bad way.  arch/arm/include/asm/delay.h has this to say
>> about __bad_udelay:
>>
>> /*
>>  * This function intentionally does not exist; if you see references to
>>  * it, it means that you're calling udelay() with an out of range value.
>>  *
>>  * With currently imposed limits, this means that we support a max delay
>>  * of 2000us. Further limits: HZ<=1000 and bogomips<=3355
>>  */
>> extern void __bad_udelay(void);
>>
>> Can you check why your driver is calling udelay() with a value > 2000?
>
> There are "udelay(2300)" calls in phy.c and hw.c.  How important is
> that exact number?  Could those be replaced by mdelay(3) instead?
>
> Of course, looking in include/linux/delay.h, mdelay(3) may still
> translate to __bad_udelay on arm.  It would be nice if the ARM guys
> and delay.h could at least agree on the maximum value allowed to be
> passed to udelay...
>
> John

Sorry for that i just haven't tested 5210 code much (these are older
chips that need more delay). I'll do some tests asap and tweak this
value to be in range.



-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
