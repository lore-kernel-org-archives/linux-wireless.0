Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115Ab1IUQi7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 12:38:59 -0400
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Johannes Berg <johannes@sipsolutions.net>
To: victorg@ti.com
Cc: Luciano Coelho <coelho@ti.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4E7A109C.2010701@ti.com>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
	 <20110921153102.GA32374@jm.kir.nu> <1316619903.2157.546.camel@cumari>
	 <4E7A109C.2010701@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 18:38:53 +0200
Message-ID: <1316623133.3940.55.camel@jlt3.sipsolutions.net> (sfid-20110921_183902_631692_A9F776E2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 19:28 +0300, Victor Goldenshtein wrote:
> On 21/09/2011 18:45, Luciano Coelho wrote:
> > On Wed, 2011-09-21 at 18:31 +0300, Jouni Malinen wrote:
> >> On Thu, Sep 08, 2011 at 09:31:01AM +0300, Victor Goldenshtein wrote:
> >> That brings up a question: Do we need to have this new function or would it
> >> be feasible for cfg80211 to generate the intermediate reports
> >> automatically based on cfg80211_inform_bss{,_frame}() calls during the
> >> scan?
> >
> > Very good point! Thinking of it, there is not need to add this new
> > function and have the drivers call it.  cfg80211 can find out when to
> > send the results by itself, whenever someone calls
> > cfg80211_inform_bss_frame(), by checking whether intermediate results
> > are enabled or not.
> >
> > This will simplify the code. :) Thanks for your comments!
> >
> 
> This could be a little bit problematic, since we need the 
> rdev->event_work, for the queue_work(), and wdev->event_list to save a 
> copy of the BSS, or just the mac which will be used to fetch the BSS 
> before the transmission (still not sure about it ..), and it seems like 
> these two can be obtained form sdata->dev, so it's look like that we 
> need this function and it should be in ieee80211_scan_rx.

It is not an issue to send a genl message with GFP_ATOMIC.

johannes

