Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53148 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2G0VDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 17:03:10 -0400
Message-ID: <1343422984.5397.0.camel@jlt3.sipsolutions.net> (sfid-20120727_230313_935467_B27349C2)
Subject: Re: [RFC 03/20] mac80211: add drv_* wrappers for channel contexts
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Date: Fri, 27 Jul 2012 23:03:04 +0200
In-Reply-To: <1343412489.1982.10.camel@joe2Laptop>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1343387816-9414-4-git-send-email-johannes@sipsolutions.net>
	 <1343412489.1982.10.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 11:08 -0700, Joe Perches wrote:

> > +static inline void drv_add_chanctx(struct ieee80211_local *local,
> > +				   struct ieee80211_chanctx *ctx)
> > +{
> > +	if (local->ops->add_chanctx)
> > +		local->ops->add_chanctx(&local->hw, &ctx->conf);
> 
> Perhaps these repeated function names should be some macro
> to avoid typos or copy/paste errors.
> 
> Maybe something like:
> 
> #define local_op(func, ...)				\
> do {							\
> 	if (local->ops->func)				\
> 		local->ops->func(##__VA_ARGS__);	\
> } while (0)
> 
> So the uses become:
> 
> 	local_op(add_chanctx, &local->hw, &ctx->conf);

Interesting idea, but no, it needs tracing -- look at the next patch in
the series. (and yes, you could play with macros to add tracing, but
that would certainly just obfuscate the code)

johannes

