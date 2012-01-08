Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:46664 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2AHGBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jan 2012 01:01:16 -0500
Received: by wibhm6 with SMTP id hm6so1897850wib.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 Jan 2012 22:01:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120107214724.GA7746@tuxdriver.com>
References: <201201071127.06717.toralf.foerster@gmx.de>
	<CANUX_P22vWv+XenOLs7Smf2P7CpPCVperF5JagS2JyCCpHXKOQ@mail.gmail.com>
	<20120107214724.GA7746@tuxdriver.com>
Date: Sun, 8 Jan 2012 08:01:15 +0200
Message-ID: <CANUX_P2Sb9TBCzKeTfTvO0tnJDOgq+6PNCgKngTwbaGJg_ZjFQ@mail.gmail.com> (sfid-20120108_070128_968829_6C74A463)
Subject: Re: suggestion for a reasonable value for /sys/module/iwlwifi/parameters/debug
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 7, 2012 at 23:47, John W. Linville <linville@tuxdriver.com> wrote:
> On Sat, Jan 07, 2012 at 10:55:30PM +0200, Emmanuel Grumbach wrote:
>> > If I choosed 0x43ff my syslog message files exploded - and I'd like to trouble
>> > shoot a problem with my wlan at a ThinkPad T400 (iwlwifi, 5100 AGN controler).
>> > The symptoms are that 1-2 times in a hour the network stops working without
>> > any message in /var/log/messages (kernel 3.0.x, 3.1.x, 3.2.0 tested).
>> >
>> > Thanks for any advice
>> > --
>>
>> For this kind of issues I added the TX_QUEUES debug flags, but I just
>> checked and it is not in 3.2. It is in John's wireless tree though. It
>> is bit 31: debug=0x80000000
>>
>> BTW - John, I have tried many times to understand all this, but stupid
>> me, couldn't ever make it. How come a patch is in wireless which in my
>> understanding (probably wrong) is supposed to feed the current rc
>> cycle (meaning the 3.2-rcX which just ended) and not be in 3.2 stable
>> release ? Sorry for the ignorance...
>
> We are betwen the release and the next -rc1.  Right now everything
> in wireless is the stuff that was in wireless-next last week.
>
> Hth!
>
yup, it does. Thanks

Toralf, back to you. There are quite a few fixes that will be included
in the next stable release (3.3) in about 3 months. I really believe
these fixes can help you. You can also try to disable 11n to see if it
helps. To do so, add 11n_disable as a module parameter.
