Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from deine-taler.de ([217.160.107.63]:55297 "EHLO deine-taler.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbXIEFQ1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 01:16:27 -0400
Date: Wed, 5 Sep 2007 07:16:26 +0200
From: Ulrich Kunitz <kune@deine-taler.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Daniel Drake <dsd@gentoo.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
Message-ID: <20070905051626.GA12198@deine-taler.de>
References: <20070821161845.165557000@sipsolutions.net> <20070821161942.938977000@sipsolutions.net> <46DB6C7B.3020001@gentoo.org> <1188811750.14564.32.camel@johannes.berg> <1188817035.14564.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188817035.14564.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> And in fact, it seems that to protect against concurrent modification in
> different code paths I'll have to use the tx lock when calling this from
> the MLME code. Can you make sure that the filter will be reconfigured
> before further packets are transmitted, that is packets that are going
> to go into ->tx() after ->configure_filter()?

I see three options to achieve this:

1) Use ieee80211_stop_queues() in ->configure_filter() and
   ieee80211_wake_queues() at the end of the workqueue function.

2) Throw away all packets until the workqueue function
   terminates.

3) Implement our own tx queue.

I prefer to do option (1) because it wouldn't require adding
additional fields to our private structure beside the work_struct
for the workqueue function, it is simple to implement and it would
not throw away any packets. Are there any side effects that I have
overlooked?

-- 
Uli Kunitz
