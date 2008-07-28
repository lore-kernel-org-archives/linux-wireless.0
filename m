Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [66.209.47.173] ([66.209.47.173]:55296 "EHLO mythtv.ewol.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750851AbYG1Msi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 08:48:38 -0400
Message-ID: <488DBF6E.10606@cortland.com> (sfid-20080728_144843_698280_C55883D2)
Date: Mon, 28 Jul 2008 08:45:34 -0400
From: Steve Brown <sbrown@cortland.com>
Reply-To: sbrown@cortland.com
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: YanBo <dreamfly281@gmail.com>,
	Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: Re: [ath5k-devel] [PATCH] ath5k: add Mesh Point support
References: <487fa7a8.14da600a.1aae.48b1@mx.google.com>	 <1197ff4c0807280209x754f3a15j9dca3e60e99c69cb@mail.gmail.com>	 <488D9E79.8050408@cortland.com> (sfid-20080728_122546_840137_51FD7C0F) <1217247004.12662.3.camel@johannes.berg>
In-Reply-To: <1217247004.12662.3.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> I've been looking at this too. After the "revamp beacon configuration" 
>> patch, mesh no longer send beacons. If I revert it, beacons reappear and 
>> my two stations are found. I'm using both a b43 & zd1211rw.
>>
>> I believe the problem is in mac80211. It appears that the call to 
>> ieee80211_if_config that was previously in ieee80211_open never made it 
>> to the new start_mesh routine in the revision. The attached patch seems 
>> to revive beacons and both stations are now found. I'm not familiar with 
>> the code and wouldn't call this a fix.
>>     
>
> Yeah, we talked about it yesterday or the day before, and this seems
> like the right fix, except you say that AP is also broken.
>
> I'll look into everything when I no longer feel hung over from
> travelling for about 18 hours.
>
> johannes
>   
I haven't tested AP, just mesh. So far, it's working w/ 3 nodes. In 
rereading my post, it wasn't clear which beacons I meant.

Although mesh path timeout seems to default to 5000ms, in my testing it 
takes about 50 min. Is this really the timeout that removes a node when 
it's beacon is off for this period?

Steve

