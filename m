Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54207 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757917AbZKRRdc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 12:33:32 -0500
Date: Wed, 18 Nov 2009 09:27:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: fix addba timer (again...)
In-Reply-To: <1258560906.30511.43.camel@johannes.local>
Message-ID: <alpine.LFD.2.01.0911180922120.4644@localhost.localdomain>
References: <1258560906.30511.43.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Wed, 18 Nov 2009, Johannes Berg wrote:
> 
> Linus pointed out that del_timer_sync() isn't actually needed if we make 
> the timer able to deal with no longer being needed when it gets queued 
> _while_ we're in the locked section that also deletes it. For that the 
> timer function only needs to check the HT_ADDBA_RECEIVED_MSK bit as well 
> as the HT_ADDBA_REQUESTED_MSK bit, only if the former is clear should it 
> do anything.

Ok, this looks sane. It's not really worth me Acking it, since I don't 
actually know the code or the hardware, so I can't really judge whether 
this is in any way a good thing.

But from a "design patterns" standpoint it no longer triggers my WTF 
reaction.

It's just bound to be more robust to have the timer just check the state 
of things itself rather than depend on some (complex and almost inevitably 
racy) "timer is only enabled IFF certain-state-is-true" rule.

			Linus
