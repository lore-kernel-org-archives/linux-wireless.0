Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53248
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159AbXCHPko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2007 10:40:44 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Properly kill tasklets before shutdown
Date: Thu, 8 Mar 2007 16:39:40 +0100
Cc: Jiri Benc <jbenc@suse.cz>, John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200703061902.00001.mb@bu3sch.de> <1173317164.3546.41.camel@johannes.berg>
In-Reply-To: <1173317164.3546.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703081639.40395.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 08 March 2007 02:26, Johannes Berg wrote:
> On Tue, 2007-03-06 at 19:01 +0100, Michael Buesch wrote:
> 
> > This fixes the tasklet related crash that was reported some time ago.
> 
> I agree with that :)
>  
> > -	tasklet_disable(&local->tasklet);
> > -	/* TODO: skb_queue should be empty here, no need to do anything? */
> > +	tasklet_kill(&local->tx_pending_tasklet);
> > +	tasklet_kill(&local->tasklet);
> 
> But I'm not sure this is sufficient. I think we can then leak pending
> skbs.

I don't think so. tasklet_kill does actually waiting, not killing.
It waits until the (maybe) scheduled tasklet did run and then waits
for it to finish running.
It doesn't rip off a scheduled tasklet without letting it run.

> In my tests I've often gotten that warning message about the skb 
> queue not being empty (right before the crash). Or is that handled
> elsewhere now?

Uh, didn't get that. The assertion for this is in the same function
some lines down.

-- 
Greetings Michael.
