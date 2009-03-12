Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vilya.visn.co.uk ([193.254.210.161]:57073 "EHLO
	vilya.visn.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753884AbZCLWHq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 18:07:46 -0400
Message-ID: <38504.82.152.175.172.1236895661.squirrel@www.phantomjinx.co.uk> (sfid-20090312_230747_939647_98051D9E)
In-Reply-To: <49B83A53.2000902@lwfinger.net>
References: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk>
    <49B813E9.8050108@lwfinger.net>
    <41788.82.152.175.172.1236803718.squirrel@www.phantomjinx.co.uk>
    <49B83A53.2000902@lwfinger.net>
Date: Thu, 12 Mar 2009 22:07:41 -0000 (UTC)
Subject: Re: rtl8187 - nice work!
From: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> P.G. Richardson wrote:
>> phy0: Selected rate control algorithm 'pid'
>>
>> which is a first as it has always been 'mistral'. The only differenc=
e
>> with
>> compiling last night was I was not running the kernel I compiled
>> against.
>> I used 'make KLIB=3D/usr/src/{my new kernel} KLIB_BUILD=3D/usr/src/{=
my new
>> kernel}' instead.
>>
>> Just recompiled while running {my new kernel} and mistral correctly
>> selected as rate control algorithm. Once installed, it does correctl=
y
>> auto
>> select rate as expected.
>>
>> iperf shows Mb performance has dropped though but gets improved by a=
gain
>> fixing the rate at 11Mb.
>>
>> So cheers for the info.
>
> Minstrel is definitely a better choice than pid.
>
> There is one thing that might make your interface work better. For
> performance
> reasons, I chose not to pause the mac80211 queues at one point in the
> driver.
> For my device, it did not make a difference, but it might for you. Pl=
ease
> try
> the attached patch.
>

Hi Larry,

Applied this patch, this morning. Run with it rest of the day yet seems=
 to
make little or no difference so far.

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
