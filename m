Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33075 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757AbaJYS50 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 14:57:26 -0400
Received: by mail-ob0-f173.google.com with SMTP id wp4so1736619obc.4
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 11:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <544AA2F9.6050806@gmail.com>
References: <544AA2F9.6050806@gmail.com>
Date: Sat, 25 Oct 2014 19:10:02 +0300
Message-ID: <CANUX_P1eHKLa4JQ9zx8D_mXr84__raCH0NrzGkxxB5CxTsGGAQ@mail.gmail.com> (sfid-20141025_205729_946287_6D0CB4C3)
Subject: Re: Channel Estimation Question
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: jeremy.lansman@gmail.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 24, 2014 at 10:05 PM, jeremy lansman
<jeremy.lansman@gmail.com> wrote:
> Hi.
>
> I beg your pardon for asking a newbe question...but..here goes anyway.
>
> My problem is with an Intel Advanced 6230.  I have noted over the year + I
> have used it under Ubuntu that it seems to have a problem when I move the
> laptop.  This is consistent with a channel estimation (tap equalizer) issue
> under COFDM modulation.
> No, I do not know about wi-fi, and I do not relish digging into driver
> stuff.  But I do know digital RF in general.
> If it is going to take more hoursout of my life , maybe I should buy an
> external wi-fi for the lap top and put up with the resultant klutz.

Please try this:

https://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=a0855054e59b0c5b2b00237fdb5147f7bcc18efb

It is on its way upstream.

>
> This is ping to my AP after I move about:
> 64 bytes from 10.5.50.1: icmp_seq=509 ttl=64 time=1057 ms
> 64 bytes from 10.5.50.1: icmp_seq=510 ttl=64 time=5382 ms
> 64 bytes from 10.5.50.1: icmp_seq=511 ttl=64 time=4386 ms
> 64 bytes from 10.5.50.1: icmp_seq=512 ttl=64 time=3383 ms
> 64 bytes from 10.5.50.1: icmp_seq=513 ttl=64 time=2376 ms
> 64 bytes from 10.5.50.1: icmp_seq=514 ttl=64 time=1438 ms
> 64 bytes from 10.5.50.1: icmp_seq=515 ttl=64 time=433 ms
> 64 bytes from 10.5.50.1: icmp_seq=516 ttl=64 time=823 ms
> 64 bytes from 10.5.50.1: icmp_seq=517 ttl=64 time=1533 ms
>
>
> This is if I sit still a while:
> 64 bytes from 10.5.50.1: icmp_seq=583 ttl=64 time=1.18 ms
> 64 bytes from 10.5.50.1: icmp_seq=584 ttl=64 time=1.79 ms
> 64 bytes from 10.5.50.1: icmp_seq=585 ttl=64 time=0.871 ms
> 64 bytes from 10.5.50.1: icmp_seq=586 ttl=64 time=2.96 ms
> 64 bytes from 10.5.50.1: icmp_seq=587 ttl=64 time=1.28 ms
> 64 bytes from 10.5.50.1: icmp_seq=588 ttl=64 time=1.57 ms
> 64 bytes from 10.5.50.1: icmp_seq=589 ttl=64 time=1.03 ms
>
> WIFI worked after I installed Unbuntu Trusty, but an update seems to have
> broken it, sending performance back to what it was under 12.04.
>
> So.. do you think it might be a simple fix related to channel estimation?
>
> Thank you.
>
>
>
>
>
>
> --
> Jeremy Lansman
> New York City USA, +1 347 696 0120
> Western Cape RSA, +27 21 300 2105
> Anchorage AK USA,+1 907 339 3800
> Skype Lansmankyes
> Fax 27862460713
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
