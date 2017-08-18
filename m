Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55324 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751350AbdHRW6O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Aug 2017 18:58:14 -0400
Message-ID: <1503097091.2730.14.camel@redhat.com> (sfid-20170819_005817_943149_F07B37BB)
Subject: Re: [POC/GIT] mac80211 multicast rate selection (help wanted!)
From: Matteo Croce <mcroce@redhat.com>
To: David Lamparter <equinox@diac24.net>,
        linux-wireless@vger.kernel.org
Date: Sat, 19 Aug 2017 00:58:11 +0200
In-Reply-To: <20170818222910.GT773745@eidolon>
References: <20170818222910.GT773745@eidolon>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il giorno sab, 19/08/2017 alle 00.29 +0200, David Lamparter ha scritto:
> Hello Linux Wireless hackers,
> 
> 
> I've taken up an hacking endeavour in trying to improve multicast on
> wifi, specifically to get it off the stupid 1 MBit rate.  Before
> anyone
> yells "that's not allowed by the spec" - it actually is, please refer
> to
> section 9.7.5 of 802.11-2012. ("... using one of the rates included
> in
> the BSSBasicRateSet parameter ...")  Also, Cisco and Aruba are doing
> this in their enterprise APs, and it's rather nice.
> 
> So, from some completely unrelated datacenter work, I have hacked up
> the
> bridge to hand back down to the driver detailed info on multicast
> receivers.  Then I took this and fudged around in the minstrel_ht
> code
> and, well, it gave me 9 MBit/s ;)
> 
> Now, I have pretty little no clue about the Linux wireless stack, so
> I'd
> appreciate if someone could tell me how massively wrong I'm doing
> this
> and which places in particular are the wrongest!
> 
> You can find the code here:
> https://github.com/eqvinox/vpls-linux-kernel/commits/mdb-hack
> https://github.com/eqvinox/vpls-iproute2/tree/mdb-hack
> 
> Please note that all of this is proof-of-concept level, it probably
> leaks tons of memory, has great race conditions and eats your cat for
> breakfast.  It also contains some debug printks like this:
> [ 9006.253504] mac80211_hwsim hwsim0 wlan0: multi-dst TX:
> 02:00:00:00:02:00 02:00:00:00:01:00
> [ 9006.255007] mac80211_hwsim hwsim0 wlan0: rc 02:00:00:00:02:00 =>
> rate #1
> [ 9006.256095] mac80211_hwsim hwsim0 wlan0: rc 02:00:00:00:01:00 =>
> rate #12
> [ 9006.257186] mac80211_hwsim hwsim0 wlan0: result rate #1
> 
> 
> Cheers,
> 
> -David
> 
> 
> P.S.: yes, I know about unicast conversion.  But that's not helpful
> when, for example, you want to get a 10 MBit multicast TV livestream
> to
> 5 simultaneous wifi clients...

So you are scanning the multicast receivers list to select the lowest
rate, comparing the rates by data rate?
I think that this is incorrect, the data rate is a combination of many
parameters (modulation, GI interval, coding rate, streams, etc.) so a
rate with higher data rate could be better than another with lower
speed in some circumstances. Or even worse, some station could not
receive the packet at all (too many streams, unsupported modulations.
etc.).

You could try to select the lowest MCS rate, the longer GI and the
minimum number of stream from all the receivers and use a data rate
compatible with these settings, if any (not all combinations are
allowed unfortunately)

Ciao,
-- 
Matteo Croce
per aspera ad upstream
