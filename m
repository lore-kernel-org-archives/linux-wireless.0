Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:4125 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbYKXWcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 17:32:39 -0500
Date: Mon, 24 Nov 2008 17:29:51 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: add suspend/resume callbacks
Message-ID: <20081124222951.GE30249@hash.localnet> (sfid-20081124_233241_736775_88BAAA14)
References: <1227415286-30179-2-git-send-email-me@bobcopeland.com> <1227431953.3599.37.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1227431953.3599.37.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 23, 2008 at 10:19:13AM +0100, Johannes Berg wrote:

Great, thanks for the feedback!

> > +	/* disable aggregation and notify that STAs are going away */
> 
> I think this should run through interfaces twice, in the first run to
> remove keys, then remove stas and then in the second run remove the
> interfaces, because otherwise you may be having keys left when the sta
> for which the key was has been removed.

Ok, that makes sense.

> > +	/* setup RTS and frag thresholds */
> > +	if (local->ops->set_rts_threshold)
> > +		local->ops->set_rts_threshold(hw, local->rts_threshold);
> > +
> > +	if (local->ops->set_frag_threshold)
> > +		local->ops->set_frag_threshold(hw, 
> > +			local->fragmentation_threshold);
> 
> Heh, I didn't even think of those.

They were in your original email on the website.  I'm not making up too 
much, yet :) 

> What were you thinking of when you said something is missing? I can't
> think of anything right now. And what warnings do you get?

conf_tx was the last callback from your email that I hadn't yet worked in.

Predictably, I got the netif_running() warning on ieee80211_enable_keys,
so hopefully the reordering and checking first will take care of that.

> Resume definitely needs to defer to schedule_work(), I think, but that's
> a trivial change.

Yeah that shouldn't be a problem.
 
-- 
Bob Copeland %% www.bobcopeland.com

