Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:55708 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3FRP7g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 11:59:36 -0400
Message-ID: <51C083E0.9020600@candelatech.com> (sfid-20130618_175943_415343_F4C5118E)
Date: Tue, 18 Jun 2013 08:59:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Lots of confusion on bss refcounting.
References: <51BF5A53.8050100@candelatech.com>    (sfid-20130617_205007_448068_E9E81DD2) <1371495758.8168.3.camel@jlt4.sipsolutions.net>   <51BF5ED4.9010704@candelatech.com> <51BF8040.2000408@candelatech.com>   <51BFAA34.1020407@candelatech.com>  <1371559771.8318.12.camel@jlt4.sipsolutions.net>  <51C08119.3000407@candelatech.com> <1371570723.22256.0.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371570723.22256.0.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 08:52 AM, Johannes Berg wrote:
>
>>> You mean ->current_bss? That should be handled in all the callbacks in
>>> sme.c or so
>>
>> Looks like much of the action happens on work-queues.  I'm wondering if
>> we managed to delete wdev objects before we have completely cleaned up
>> in some cases...
>
> Don't we flush work structs appropriately?

Looks like it, from core.c in the netdev event handler:

		/*
		 * Ensure that all events have been processed and
		 * freed.
		 */
		cfg80211_process_wdev_events(wdev);


          /* I just added this to see if it helps... */
		if (WARN_ON(wdev->current_bss)) {
			cfg80211_unhold_bss(wdev->current_bss);
			cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
			SET_BSS(wdev, NULL);
		}
		break;

Some of the unregister and similar sme.c calls that should be cleaning up
the current_bss have some early returns if state does not match expected
value.  If the warning above hits, then probably we are hitting those
somehow.

If not, then I'll keep looking :)

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

