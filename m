Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:63556 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655Ab3D1ONR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Apr 2013 10:13:17 -0400
Received: from mailout-de.gmx.net ([10.1.76.16]) by mrigmx.server.lan
 (mrigmx001) with ESMTP (Nemesis) id 0M4UOQ-1UgZAz0MIe-00yfap for
 <linux-wireless@vger.kernel.org>; Sun, 28 Apr 2013 16:13:13 +0200
Message-ID: <517D2E77.8000104@rempel-privat.de> (sfid-20130428_161331_044718_8642C42B)
Date: Sun, 28 Apr 2013 16:13:11 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC] ath9k: collect statistics about Rx-Dup and Rx-STBC
 packets
References: <1367076326-21616-1-git-send-email-linux@rempel-privat.de> <517D1B45.9020302@openwrt.org>
In-Reply-To: <517D1B45.9020302@openwrt.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.04.2013 14:51, schrieb Felix Fietkau:
> On 2013-04-27 5:25 PM, Oleksij Rempel wrote:
>> Collect statistics about recived duplicate and STBC packets.
>> This information should help see if STBC is actually working.
>>
>> Tested on ar9285;
>>
>> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
> I thought about this patch some more, and I'm wondering what's the point
> in doing this? These statistics are going to be completely useless for
> most people and they'll waste some memory/cpu cycles, especially on
> small-cache devices. I think it's much more useful to simply pass the
> information to mac80211 via rx flags and get them added to the radiotap
> header.

Sure.

> I'd like to keep the number of 'poor man's debug hacks' in the driver to
> a minimum,

well, i'll prefer it to call with my name: lazy man's hack ;)

> and there are some other things that I think should be
> removed: rx_frags and rx_beacons in struct ath_rx_stats, the tx/rx MAC
> sampling hack, and pretty much anything else that can be just as easily
> accessed from mac80211 through regular interfaces.

I think there is more things to do in ath9k. Create the list and we can 
talk about it. For example one of it: I needed some time to understand 
how some parts of code relate to the hardware. Especially Rx and Tx 
descriptors. Some comments in header will help... I can add some of them 
(may be it will help other beginners), but i afraid that i spend time 
but my patches wont be included.
-- 
Regards,
Oleksij
