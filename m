Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53702 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbcCZTuy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Mar 2016 15:50:54 -0400
Message-ID: <56F6E81C.5050309@candelatech.com> (sfid-20160326_205057_351536_DFB7968C)
Date: Sat, 26 Mar 2016 12:50:52 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: hashing error in hacked 4.4.6+ kernel.
References: <56F5DE21.9050601@candelatech.com>	 (sfid-20160326_015610_163402_1721825C) <1459020054.8901.8.camel@sipsolutions.net>
In-Reply-To: <1459020054.8901.8.camel@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 03/26/2016 12:20 PM, Johannes Berg wrote:
> On Fri, 2016-03-25 at 17:56 -0700, Ben Greear wrote:
>>
>> Mar 25 17:02:05 ath10k.candelatech.com kernel: sta28:
>> deauthenticating from 04:f0:21:f6:85:1c by local choice (Reason:
>> 3=DEAUTH_LEAVING)
>> Mar 25 17:02:05 ath10k.candelatech.com kernel: ------------[ cut here
>> ]------------
>> Mar 25 17:02:05 ath10k.candelatech.com kernel: WARNING: CPU: 2 PID:
>> 6227 at /home/greearb/git/linux-
>> 4.4.dev.y/net/mac80211/sta_info.c:921
>> __sta_info_destroy_part1+0x91/0x422 [mac80211]()
>
> In upstream, this warning goes straight to rhashtable not finding the
> entry.
>
> In your code though (looking at the commit introducing it, hoping you
> didn't change it later), there's considerably more code in
> sta_info_hash_del() that can return an error. It might be interesting
> to find out *which* error is happening.
>
> I'd agree though, from my brief look at the code it doesn't seem likely
> that there's a problem with the code you add.

In my current code, I'm always returning whatever the rhashtable returned
(rv is never actually assigned after that).  I figured that was
most likely to not introduce bugs.

http://dmz2.candelatech.com/?p=linux-4.4.dev.y/.git;a=summary

or, grab the whole thing for easier looking:

git clone git://dmz2.candelatech.com/linux-4.4.dev.y

> johannes
>
> PS: you should probably write "return 0" instead of "return rv"
> whenever it's clear that "rv" must be 0 :)
>
> PPS: why are you not using rhashtable for the vhash?

Err, I was confused by the usage of rhashtable...and I had working
and tested code that patched in pretty easily.  Since it was not needed
upstream anyway, that seemed simplest.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
