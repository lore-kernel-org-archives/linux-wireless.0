Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 4.mo179.mail-out.ovh.net ([46.105.36.149]:46254 "EHLO
        4.mo179.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751309AbeEPBH1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 21:07:27 -0400
Received: from player734.ha.ovh.net (unknown [10.109.108.122])
        by mo179.mail-out.ovh.net (Postfix) with ESMTP id 49DC5C1031
        for <linux-wireless@vger.kernel.org>; Wed, 16 May 2018 00:41:28 +0200 (CEST)
Subject: Re: [PATCH v2] mac80211: Fix wlan freezes under load at rekey
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, greearb@candelatech.com,
        s.gottschall@dd-wrt.com
References: <1523258757.3076.5.camel@sipsolutions.net>
 <20180515102202.2021-1-alexander.wetzel@web.de>
 <1526399448.4450.10.camel@sipsolutions.net>
From: Alexander Wetzel <alexander.wetzel@web.de>
Message-ID: <e37c7000-c281-dfc1-70a0-66d4001d78ed@web.de> (sfid-20180516_030732_735513_92785C57)
Date: Wed, 16 May 2018 00:41:14 +0200
MIME-Version: 1.0
In-Reply-To: <1526399448.4450.10.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

> On Tue, 2018-05-15 at 12:22 +0200, Alexander Wetzel wrote:
>>
>> Both issues can be prevented by first replacing the key in the HW and
>> makeing sure no aggregation sessions are running during the rekey.
> 
> I don't think you can do this - just tear down all aggregation sessions
> - there are APs out there that will not re-establish them if you tear
> them down, or only attempt a given number of times, etc. This will cause
> interoperability problems.

I'm on very thin ice here, but my impression was that this should work
without too many problems for all (most?) systems:
- An aggregation session is only started when needed
- ADDBA can't be expected to succeed
- It's normal to tear down an aggregation session once your queue is empty.

The only unusual thing here is, that the originator can get a DELBA from
the recipient while transmitting data and not after some inactivity
timeout. But reading IEEE802.11-2016 chapter 11.5.4 seems to indicate
that you have to expect and handle DELBA frames any time.

So far I've found only one device which is handling a PSK rekey
correctly (Windows Surface Pro 3 running Win 10) and that one was
working fine with my patched AP for three rekeys while downloading at
full speed. The fourth rekey failed and caused an re-associated, but
according to the OTA capture the AP did not respond to at least 5 EAPOL
#2 frames and we therefore never got to the code stopping the
aggregation for rekey.

That said I think I can get the code working without stopping RX
aggregation and a spoofed "idle" tear down of the TX aggregation.

Problem here is the reorder buffer can have already decoded packets
queued from both the old and the new key. And once the session is
complete will releases those when we are on the new key, poisoning our PN.
First plan would be to mark any running RX aggregation queue as tainted
and once the aggregation is complete discard all packets in it.

> 
> OTOH, arguably we have worse interoperability problems today, and anyone
> who configures PTK rekeying is deluded that it'll work properly, so
> maybe that's not _that_ bad. Hmm.

Assuming the other STA is not totally broken this should only degrade
the speed, but keep the connection operable.
If you prefer to not stop the RX aggregation I'll try my hand on that
next. (I assume stopping TX is fine?)

The tests I've run so far are showing that we have at least two group of
"broken" devices out in the wild:
1) The first group is handling rekeys pretty much like mac80211. Some
are better on TX like my HTC 10 (seems to be fullmac) but are failing to
separate RX frames properly based on the key used to decode it.

2) The second group is even worse implemented, but in a nice twist are
seeming to work quite fine for the users. Those are simply encoding
eapol #4 with the new key, preventing any rekey to ever succeed and
triggering a re-associate.

Statistically my data is less than insufficient, but I suspect that
there are quite some APs in the wild running rekeys but the combination
of hour long rekey intervals, the fact hat you must have traffic during
the rekey and that at least some common network cards handle eapol #4
wrong keeps the heat down. And of course this issue is next to
impossible to track down if you are not some kind of expert.

Nevertheless I can you find many "magic" solutions to fix linux wlan
issues by switching over to software encryption and disabling 802.11n,
which are exactly the actions which drastically reduce the chance to
freeze a wlan during a PSK rekey. (I'm sure many of those are other
issues, but I'm equally sure a sizeable fraction is not.)

One of the "better" reports is here:
https://bugzilla.kernel.org/show_bug.cgi?id=42877

Alexander
