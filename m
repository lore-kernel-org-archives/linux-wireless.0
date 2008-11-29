Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:34765 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYK2GyN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Nov 2008 01:54:13 -0500
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC v3 2/4] mac80211: implement dynamic power save
References: <1227901784-5325-1-git-send-email-kalle.valo@nokia.com>
	<1227901784-5325-3-git-send-email-kalle.valo@nokia.com>
	<1227910460.3543.3.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sat, 29 Nov 2008 08:53:34 +0200
In-Reply-To: <1227910460.3543.3.camel@johannes.berg> (ext Johannes Berg's message of "Fri\, 28 Nov 2008 23\:14\:20 +0100")
Message-ID: <87vdu710r5.fsf@nokia.com> (sfid-20081129_075416_513020_6EF9A11E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2008-11-28 at 21:49 +0200, Kalle Valo wrote:
>
>> +	/* always wake queues to avoid having them stopped forever */
>> +	netif_tx_wake_all_queues(local->mdev);
>
> I think we really need to think about keeping track of _who_ wanted the
> queues stopped now...

Makes sense.

> We have a number of users of stopping queues now:
>
>  * driver, obviously
>  * scanning code
>  * PS code
>  * ..?
>
> So when the driver wants a queue stopped, but the PS code wakes them up,
> the driver will end up having to drop a packet, which isn't really good.
> We really need to keep track, for each queue, who wants it
> stopped/started and then only start the real queue if all the code
> consents.

Frankly I'm not that familiar with mac80211 queues, but it's a good
time to learn now :) I'll look into this and will make a proposal.

-- 
Kalle Valo
