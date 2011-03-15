Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58788 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab1CONf2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 09:35:28 -0400
Received: by wwa36 with SMTP id 36so728790wwa.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Mar 2011 06:35:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110315131907.6f06a221@toddler>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<20110314164812.4c0cfc29@toddler>
	<AANLkTimSZrGCzBaB9K=WVO7faGNM-+qeKEE2qzjkPnSD@mail.gmail.com>
	<20110315131907.6f06a221@toddler>
Date: Tue, 15 Mar 2011 19:05:27 +0530
Message-ID: <AANLkTi=Gub1JAO21qtRjxVWrtc6Masp1siF3NHntgcvp@mail.gmail.com>
Subject: Re: Could ath9k and rt2800pci bugs be related?
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Tony Houghton <h@realh.co.uk>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 15, 2011 at 6:49 PM, Tony Houghton <h@realh.co.uk> wrote:
> On Tue, 15 Mar 2011 13:17:40 +0530
> Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>> On Mon, Mar 14, 2011 at 10:18 PM, Tony Houghton <h@realh.co.uk> wrote:
>> >
>> > I've just bought an Acer Aspire Revo 3700 and this had very similar
>> > symptoms with a different adapter. Luckily another customer had
>> > posted about it on the vendor's website and his fix works for me.
>> > The fix is to blacklist the rt2800pci module and the rt2860sta
>> > driver seems to work quite happily without it.
>>
>> can you please check by disabling the supicious rt modules and see
>> whether this problems happens.
>
> Yes, I did blacklist rt2800pci and the system works correctly without
> the module loaded. Even the wireless connection still works.

Ok still there is also one or two guys reporting this locking issue,
so we need to be very sure.

>
>> for quick check please try with the latest compat wireless.
>
> How do I do that?
>
> I would also be willing to add extra debugging messages to ath9k to help
> track down the AR9285 problem. I'm a C programmer, but not a kernel
> hacker so I think I would need some advice about which functions to
> examine.
>

No its nothing to do with kernel hacking, its just a wireless package.
instead of compiling the whole kernel or wireless testing, we can
install a wireless package within our linux distribution in few
minutes. This package is called compat-wireless which includes latest
fixes in wireless testing.
more information in:
http://wireless.kernel.org/en/users/Download

1.now download the compat wireless package in
http://linuxwireless.org/download/compat-wireless-2.6/
2. cd compat-wireless-...
3. As you are suspicious about rt modules remove them in config.mk
4.now do ./scripts/driver-select ath9k
5.make
6.make install
7.make unload
8.sudo modprobe ath9k

thanks,
shafi
