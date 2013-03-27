Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40337 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3C0SCo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 14:02:44 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364390086.8388.7.camel@jlt4.sipsolutions.net>
	<87r4j021ac.fsf@sycorax.lbl.gov>
	<1364406085.8388.11.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 11:02:31 -0700
In-Reply-To: <1364406085.8388.11.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 18:41:25 +0100)
Message-ID: <87ip4cg1qg.fsf@sycorax.lbl.gov> (sfid-20130327_190250_280564_CC29EFE8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Wed, 2013-03-27 at 10:35 -0700, Alex Romosan wrote:
>
>> ...i did a bisect using the above and it came up with this:
>> 
>> 89afe614c0c737fd40eda1f8c8ef686246cf3cb6 is the first bad commit
>> commit 89afe614c0c737fd40eda1f8c8ef686246cf3cb6
>> Author: Johannes Berg <johannes.berg@intel.com>
>> Date:   Wed Feb 13 15:39:57 2013 +0100
>> 
>>     mac80211: fix auth/assoc timeout handling
>> 
>> which makes a lot more sense. i'll try reverting it to see if it fixes
>> the problem, or i can try patches if you have any.
>
> Humm, yes, that makes more sense. That commit fixed a bug in another
> commit though, I'm surprised you ended up there?! Curious ... I'll
> check over the commit and see if I can find anything wrong with it.

i just reverted that commit on top of 3.9-rc4 and now i can reconnect
when resuming from suspend. so whatever bug that commit fixed, it also
introduced a new one.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
