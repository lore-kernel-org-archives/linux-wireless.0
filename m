Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:54315 "EHLO
        mx2.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727584AbeGSNWn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jul 2018 09:22:43 -0400
Subject: Re: Setting tx retry count in ath10k
To: Jean-Pierre TOSONI <jp.tosoni@acksys.fr>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Ben Greear <greearb@candelatech.com>,
        SEDE <s.deronne@televic.com>,
        ath10k <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <b0f67dd7-dea9-508e-7ad9-f6db3ac88b90@candelatech.com>
 <e9b42b3d-2d03-ca69-5532-fbae08fdec5d@uni-rostock.de>
 <8b9713fe-7573-f009-d002-13df73315898@televic.com>
 <9dd76e58-b514-26f2-2fe9-0c9a7f798054@candelatech.com>
 <AM4PR0101MB2305917B39A84BBE13FDFAD1E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
 <ea2ff457-e84e-8395-148d-8d90a749a40d@candelatech.com>
 <877els5xax.fsf@toke.dk>
 <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <c594f50b-a318-fbe2-847b-b76726eb1472@uni-rostock.de> (sfid-20180719_143948_177812_92A89E7D)
Date: Thu, 19 Jul 2018 14:39:43 +0200
MIME-Version: 1.0
In-Reply-To: <AM4PR0101MB230575D91CEE21630A723466E4530@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 18.07.2018 um 19:01 schrieb Jean-Pierre TOSONI:
> Hi Ben,
>
> I attached the patch. Please remind that it applies to ath9k.
>
> At the end there are 3 comments in French, translation follows:
> 1) " longretry gives directly the transmit count, the +1 is useless.
>      Should rather have -1 to account for the first try"
> 2) " The retries just made for this frame must be added in to know
>      If the max was overstepped"
> 3) " Add the 1st try (probably useless).
>      Upstream version adds 1 to A-MPDU retries but I don't understand w=
hy.
>      Since above I removed the +1 to fix the count, I add +1 here once =
per
>      frame in case the "+1" is actually hiding a bug in the upstream ve=
rsion"
>
> @Toke: As you can see in the patch, the value 30 was the fixed value de=
fined
>  in ath9k, I kept it for compatibility only (and that's why I wanted to=
 make
>  it configurable :-)
> On another hand, Minstrel in mac80211 seems to vary retries according t=
o what
> you say, i.e. Minstrel tries to stay below a certain amount of time, bu=
t this
> only applies to short/long retries.
>
> Jean-Pierre
We also experienced the problems regarding the inconsistencies between
documentation and implementation. I will further throw in another set of
patches:
https://github.com/steinwurf/openwrt-patches/tree/master/openwrt-r41097/m=
ac80211

I think they have have similarities but also other aspects to really
restrict ath9k to the specified retry limits. This problem is as Toke
already stated additionally depended on minstrel. It is really sad, that
all this stuff is offtree and but there is the illusion of an setting in
the mainline kernel, which firstly will not set the value as documented
and different drivers will apply them (without warnings) in different way=
s.

>> For general internet traffic, a retry count of 30 is way too high; tha=
t
>> is up to 120 ms of HOL blocking latency. Better to just drop the packe=
t
>> at that point.
>>
>> Ideally, the retry count should be dynamically calculated in units of
>> time (which would depend on the rate and aggregate size), and also tak=
e
>> queueing time into account. I've been meaning to experiment with this
>> for minstrel and ath9k, but haven't gotten around to it...
We have running current research on this topic but focused on the
effects in 802.11s mesh networks. With multiple(forwarding) wireless
links, the retry limit have a bigger impact as only in managed mode
setups, since every forwarding step is doing repeated transmissions. But
I also totally agree, that the retry count needs to be considered in the
bufferbloat/airtime queuing stuff, which Toke proposed.

Nonetheless, since this ambiguities are known, wouldn't it be nice to
clean up all this patches to enable at least ath9k and ath10k to do the
right thing, or do anybody can tell why they weren't included the first
time ?


--=20
M.Sc. Benjamin Beichler

Universit=E4t Rostock, Fakult=E4t f=FCr Informatik und Elektrotechnik
Institut f=FCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=DFe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
