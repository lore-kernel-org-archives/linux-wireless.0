Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:54394 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750875AbZAEFv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Jan 2009 00:51:58 -0500
Message-ID: <49619FF7.2030606@lwfinger.net> (sfid-20090105_065200_489891_B53AF630)
Date: Sun, 04 Jan 2009 23:51:51 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: rate instability in wireless stack
References: <20090104164649.GV496@one.firstfloor.org> <200901041736.47650.mb@bu3sch.de> <20090104174123.GW496@one.firstfloor.org> <49615465.4090604@lwfinger.net> <20090105025302.GF496@one.firstfloor.org> <49618497.50809@lwfinger.net> <20090105050248.GG496@one.firstfloor.org> <496193A6.3040608@lwfinger.net> <20090105054830.GJ496@one.firstfloor.org>
In-Reply-To: <20090105054830.GJ496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andi Kleen wrote:
> On Sun, Jan 04, 2009 at 10:59:18PM -0600, Larry Finger wrote:
>> Andi Kleen wrote:
>>> On Sun, Jan 04, 2009 at 09:55:03PM -0600, Larry Finger wrote:
>>>
>>> Minstrel stays constantly at 1 Mbit/s
>> Do you have mac80211 debugging turned on? If so, then do a
>>
>> sudo cat /sys/kernel/debug/ieee80211/phyXX/stations/<MAC ADDR>/rc_stats
>>
>> and post them.
> 
> Lots of zeroes.

Strange. Mine looks like this.

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
     1         0.9       97.7      100.0          1(  1)       2086        2206
     2         0.1        7.0        0.0          0(  0)          1           5
     5.5       0.0        0.0        0.0          0(  0)          0           1
    11         0.0        0.0        0.0          0(  0)          0           4
     6         1.4       25.0      100.0          0(  0)          1           2
     9         0.0        0.0        0.0          0(  0)          0           6
    12         7.6       68.8        0.0          0(  0)        187         192
    18         7.0       43.3        0.0          0(  0)          3           5
    24        10.6       49.8      100.0          0(  0)         20          40
    36         8.5       28.0       50.0          0(  0)       1389        1520
T P 48        15.7       99.9      100.0          1(  1)       3277        3525
 t  54        21.7       50.1        0.0          0(  0)      19282       20028

Total packet count::    ideal 3800      lookaround 422

Johannes,

Any explanation as to why there are no attempts?

Larry


