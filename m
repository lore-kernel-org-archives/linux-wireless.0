Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sycorax.lbl.gov ([128.3.11.121]:40327 "EHLO sycorax.lbl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597Ab3C0RgB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 13:36:01 -0400
From: Alex Romosan <romosan@sycorax.lbl.gov>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: Re: iwlwifi unable to reconnect after suspend since v3.9-rc1
References: <87li993mug.fsf@sycorax.lbl.gov>
	<1364390086.8388.7.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Mar 2013 10:35:55 -0700
In-Reply-To: <1364390086.8388.7.camel@jlt4.sipsolutions.net> (message from
	Johannes Berg on Wed, 27 Mar 2013 14:14:46 +0100)
Message-ID: <87r4j021ac.fsf@sycorax.lbl.gov> (sfid-20130327_183607_592387_721A31B5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> That sounds like it stopped the queues. Can you check debugfs:
>
> cat /sys/kernel/debug/ieee80211/phy0/queues
>
> when this happens?

i don't have anything under /sys/kernel/debug/ so i probably need to
turn some debugging options on, but...

> git bisect start -- drivers/net/wireless net/wireless net/mac80211
>
> would probably have been more successful.

...i did a bisect using the above and it came up with this:

89afe614c0c737fd40eda1f8c8ef686246cf3cb6 is the first bad commit
commit 89afe614c0c737fd40eda1f8c8ef686246cf3cb6
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Wed Feb 13 15:39:57 2013 +0100

    mac80211: fix auth/assoc timeout handling

which makes a lot more sense. i'll try reverting it to see if it fixes
the problem, or i can try patches if you have any.

--alex--

-- 
| I believe the moment is at hand when, by a paranoiac and active |
|  advance of the mind, it will be possible (simultaneously with  |
|  automatism and other passive states) to systematize confusion  |
|  and thus to help to discredit completely the world of reality. |
