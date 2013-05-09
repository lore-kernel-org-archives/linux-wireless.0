Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:33712 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab3EIF5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 May 2013 01:57:48 -0400
Received: by mail-wi0-f182.google.com with SMTP id m6so2687691wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 22:57:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1368062883.17674.24.camel@bigdick-desktop>
References: <1368015905.17674.11.camel@bigdick-desktop>
	<CAJ-Vmonq1YN2NoWFMXtqVYr16eTD=mZ0n74CCEhMHK=05M1xyQ@mail.gmail.com>
	<1368062883.17674.24.camel@bigdick-desktop>
Date: Wed, 8 May 2013 22:57:46 -0700
Message-ID: <CAJ-Vmom2UZOtzMphRYJtH0NyLiQYy5PqibvZ0orAWhxTEud8bA@mail.gmail.com> (sfid-20130509_075752_601528_F829ED1C)
Subject: Re: atheros AR5B22, using ath9k, can't switch between inscure and WEP/WPA
From: Adrian Chadd <adrian@freebsd.org>
To: Wally <wally.yeh@a-trust.com.tw>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=Big5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ah, right. An AR9462.

Odd. It should be fine. I wonder if the same behaviour exists for
other NICs in that general family (AR9380, AR9485.)

Some code has shown up recently in the reference driver that does
funny things with the keycache as a work-around for some bug. I don't
know what the bug is yet though.
I'll go check it out and get back to the list.




Adrian


On 8 May 2013 18:28, Wally <wally.yeh@a-trust.com.tw> wrote:
> Hi, Adrian:
>     Here is it's wiki:http://wikidevi.com/wiki/Atheros_AR5B22
>
>     As I modprobe ath9k. dmesg give these messages:
> ----------------------------------------------------------------------
> [49603.281250] compat-drivers backport release:
> compat-drivers-2013-03-28
> [49603.281250] Backport based on linux-next.git next-20130328
> [49603.281250] compat.git: linux-next.git
> [49603.367187] cfg80211: Calling CRDA to update world regulatory domain
> [49603.609375] ath: EEPROM regdomain: 0x60
> [49603.609375] ath: EEPROM indicates we should expect a direct regpair
> map
> [49603.609375] ath: Country alpha2 being used: 00
> [49603.609375] ath: Regpair used: 0x60
> [49603.609375] ieee80211 phy0: Selected rate control algorithm
> 'ath9k_rate_control'
> [49603.609375] Registered led device: ath9k-phy0
> [49603.609375] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xe1300000,
> irq=48
> -----------------------------------------------------------------------
>     so it seems ath9k probe this chip as Atheros AR9462. do you have
> some idea?
>
> Wally
>
>
>
> 於 三，2013-05-08 於 15:46 -0700，Adrian Chadd 提到：
>> .. AR5B22? Which chip does that probe as?
>>
>>
>>
>> Adrian
>>
>>
>> On 8 May 2013 05:25, Wally <wally.yeh@a-trust.com.tw> wrote:
>> > Hi, guys:
>> >     Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
>> > the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
>> > and build it for armel on my arm board, it works great but with one
>> > little problem:
>> >
>> > If I connect to an inscure AP then change to a WEP/WPA AP, I can't
>> > connect the inscure one again, I have to run "modprobe -r ath9k;
>> > modprobe ath9k" to connect the inscure AP.
>> >
>> >     I think this may be a bug in the ath9k driver, I also search this
>> > bug on web but without an answer, so I send this letter for help.
>> >
>> >     Any advice would be grateful, thanks.
>> >
>> > Wally
>> >
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
