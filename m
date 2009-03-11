Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:58367 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbZCKUfW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 16:35:22 -0400
Message-ID: <41788.82.152.175.172.1236803718.squirrel@www.phantomjinx.co.uk> (sfid-20090311_213525_914735_ACA332A2)
In-Reply-To: <49B813E9.8050108@lwfinger.net>
References: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk>
    <49B813E9.8050108@lwfinger.net>
Date: Wed, 11 Mar 2009 20:35:18 -0000 (UTC)
Subject: Re: rtl8187 - nice work!
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Installed the compat-wireless-2009-03-10 and the speed has greatly
>> improved. Thanks very much.
>>
>> I do have some observations that might be a bug or just configuratio=
n.
>>
>> When powering up, the wireless decided on 54M as its bit rate.
>> Consequently, tcp was patchy at best - losing packets whilst pinging=
,
>> ssh
>> failing to connect. Setting the rate back to a fixed 11M solves this=
 and
>> gives good speed. Interestingly, performance declines as I up the bi=
t
>> rate
>> from 11 to 18 etc...
>
> It is probably a bug. My Netgear WG111V2 with an RTL8187L chip is
> perfectly
> happy running at 48 or 54 Mb/s with a transmit throughput of 21-23 Mb=
/s -
> close
> to the maximum for an 802.11g network. There are, however, other repo=
rts
> like
> yours where the OFDM rates (6, 9, 18, 24, 36, 48, and 54 Mb/s) don't =
work
> very
> well. It seems that not all 8187's are the same.
>
> What rate-setting algorithm are you using? Use 'dmesg | grep rate' to=
 see
> that.
> I would have expected it to have settled into 11 Mb/s. Perhaps the au=
to
> retry
> hasn't really been turned off.

dmesg says ->
phy0: Selected rate control algorithm 'pid'

which is a first as it has always been 'mistral'. The only difference w=
ith
compiling last night was I was not running the kernel I compiled agains=
t.
I used 'make KLIB=3D/usr/src/{my new kernel} KLIB_BUILD=3D/usr/src/{my =
new
kernel}' instead.

Just recompiled while running {my new kernel} and mistral correctly
selected as rate control algorithm. Once installed, it does correctly a=
uto
select rate as expected.

iperf shows Mb performance has dropped though but gets improved by agai=
n
fixing the rate at 11Mb.

So cheers for the info.

Regards

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
