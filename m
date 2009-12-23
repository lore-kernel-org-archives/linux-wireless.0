Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:39409 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752155AbZLWLnc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 06:43:32 -0500
Received: from vs3009.wh2.ocn.ne.jp (125.206.180.237)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-051908611
	for <linux-wireless@vger.kernel.org>; Wed, 23 Dec 2009 20:43:31 +0900 (JST)
Message-ID: <4B320265.7050807@thinktube.com>
Date: Wed, 23 Dec 2009 20:43:33 +0900
From: =?ISO-2022-JP?B?GyRCMyRBdDdJRzcbKEI=?= <tkaiso@thinktube.com>
MIME-Version: 1.0
To: 8an@praha12.net
CC: johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Reimplement clock rate to usec
 conversion
Content-Type: text/plain; charset=ISO-2022-JP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, Lukas
> According to my interpretation the calculation should depend 
> on channel width (20MHz in normal mode, 40MHz in turbo mode, same for 802.11g 
> and 802.11a), not on MAC chip clocks. 
thanks, then my guess was irrelevant...
I got some improvement (even not so significant), but I might have
mislead myself at this moment .

let me show my observation during last a few days.

at first
- chip is AR5414
- I pulled down codes via git a week before and your recent patches were
applied.

then what I have observed till now was

1. stable and excellent throughput for 5GHz (with 1hop and also 2hops cases)
16Mbps(1hop) , 8Mbps(2hops)
note: testing with IBSS ad-hoc mode, 1 hop, 2hops , 3 hops..

2. still not good and unstable throughput for 2.4Ghz
thanks to your patch[3/5], [4/5], throughput was improved pretty much
but still staying around 10~15Mbps(1hop), 1Mbps~6Mbps(2hops)

without my experimental patch, 2hops throughput was
worse than the case with that patch.
( 1~2Mbps vs 1~6Mbps --> I can't say this difference is significant ) .
debugfs(rc_stats) shows minstrel reported around 85%~95 success
rate with 48/54Mbps and selected low xmit rate.

(this was the result on limited number of tests. five ~ ten times )

in my these tests, node is sitting pretty close (1m) to each other,
therefore I did not enable RTS/CTS and just counted on physical
carrier sense.

Does it seem that there still exist vulnerable part around carrier
sensing for 2.4GHz.?

anyway,
I would like to get back to this issue, again later

thanks
Taka


