Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:60362 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755803AbZBTAPc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Feb 2009 19:15:32 -0500
Message-ID: <44177.82.152.175.172.1235088928.squirrel@www.phantomjinx.co.uk> (sfid-20090220_011536_200862_B908881A)
In-Reply-To: <499B4526.1030705@lwfinger.net>
References: <35879.82.152.175.172.1234904444.squirrel@www.phantomjinx.co.uk>
    <499B27A4.30708@lwfinger.net>
    <42781.82.152.175.172.1234911183.squirrel@www.phantomjinx.co.uk>
    <499B4526.1030705@lwfinger.net>
Date: Fri, 20 Feb 2009 00:15:28 -0000 (UTC)
Subject: Re: rtl8187 cannot fix rate
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> P.G. Richardson wrote:
>>> P.G. Richardson wrote:
>>>> Hi guys,
>>>>
>>>> More experimentation with my rtl8187. With some playing around wit=
h
>>>> the
>>>> access point location, I think I may have stumbled on a good posit=
ion.
>>>>
>>>> Anyway ...
>>>>
>>>> I noticed that the rate reported by iwconfig only ever gets to 11M=
b/s
>>>> despite the fact that I now have a signal level of 90/100 - 100/10=
0. I
>>>> found that I can do
>>>>
>>>> iwconfig wlan0 rate 54M
>>>>
>>>> but it seems that although the card is still associated networking
>>>> doesnt
>>>> work (pings fail). If I change it back to auto
>>>>
>>>> iwconfig wlan0 rate auto
>>>>
>>>> then iwconfig reports 11Mb/s again and pinging resumes fine.
>>>>
>>>> Is there any chance that the driver is incorrectly reporting its m=
ode
>>>> or
>>>> something in that the rates it displays bear the hallmarks of a b =
card
>>>> rather than g?
>>>>
>>>> Using the compat-wireless snapshot from 9/2/2009
>>>> Mandriva 2.6.27.10-desktop586-1mnb
>>> What rate-adjustment method are you using? The output of dmesg will
>>> tell.
>>> If you
>>> are using minstrel, then you should post the contents from the
>>> following
>>> commands:
>>>
>>> STATS=3D$(find /sys -name rc_stats)
>>> echo $STATS
>>> sudo cat $STATS
>>>
>>> Larry
>>>
>>
>> phy0: Selected rate control algorithm 'minstrel'
>>
>> find /sys -name rc_stats produces no results whatsoever. These is no
>> rc_stats in /sys.
>
> You need to set "CONFIG_MAC80211_DEBUGFS=3Dy" in your configuration.
>
Hi Larry,

Been experimenting over last couple of days to enable this. Have
successfully recompiled the kernel and installed with above config opti=
on
enabled. This may have been unnecessary but could not compile without
doing it.

Anyway, now running the custom kernel and installed compart-wireless
snapshot from 09/02/2009 and still nothing has appeared using
find /sys -name rc_stats

I must be missing some vital step. Any thoughts please.

Cheers

PGR


--=20
Laws are partly formed for the sake of good men, in order to instruct t=
hem
how they may live on friendly terms with one another, and partly for th=
e
sake of those who refuse to be instructed, whose spirit cannot be subdu=
ed,
or softened, or hindered from plunging into evil. [The Laws, Plato]

You fiend! Never have I encountered such corrupt and foul-minded
perversity=85 Have you ever considered a career in the church?
Bishop of Bath and Wells (Blackadder II)

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
