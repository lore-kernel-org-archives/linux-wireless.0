Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56712 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0DSLWJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 07:22:09 -0400
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix stopping RX BA session from timer
References: <87pr20mrez.fsf@purkki.valot.fi>
	<20100415195812.GC3020@tuxdriver.com> <871veclztk.fsf@purkki.valot.fi>
	<1271659397.3873.9.camel@jlt3.sipsolutions.net>
	<87wrw3lxjh.fsf@purkki.valot.fi>
	<1271667624.3873.12.camel@jlt3.sipsolutions.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 19 Apr 2010 14:22:06 +0300
In-Reply-To: <1271667624.3873.12.camel@jlt3.sipsolutions.net> (Johannes Berg's message of "Mon\, 19 Apr 2010 11\:00\:24 +0200")
Message-ID: <87sk6rlmap.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Kalle reported that his system deadlocks since my
> recent work in this area. The reason quickly became
> apparent: we try to cancel_timer_sync() a timer
> from within itself. Fix that by making the function
> aware of the context it is called from.

I have now tested this for an hour and I can't reproduce the problem
anymore, earlier I was able to reproduce at least within a minute or
so. So I'm confident that the problem I saw is this fixed by this
patch.

Thank you very much for fixing this so quickly.

> Reported-by: Kalle Valo <kvalo@adurom.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

Tested-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
