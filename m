Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab2G0Lmm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jul 2012 07:42:42 -0400
Message-ID: <1343389359.4449.3.camel@jlt3.sipsolutions.net> (sfid-20120727_134244_971598_F3A110F9)
Subject: Re: [RFC 18/20] mac80211: allow drv_add_chanctx to fail
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 27 Jul 2012 13:42:39 +0200
In-Reply-To: <50127E88.6020109@tieto.com>
References: <1343387816-9414-1-git-send-email-johannes@sipsolutions.net>
	 <1343387816-9414-19-git-send-email-johannes@sipsolutions.net>
	 <50127E88.6020109@tieto.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-07-27 at 13:42 +0200, Michal Kazior wrote:
> On 27/07/12 13:16, Johannes Berg wrote:
> > --- a/net/mac80211/chan.c
> > +++ b/net/mac80211/chan.c
> > @@ -237,7 +237,10 @@ ieee80211_new_chanctx(struct ieee80211_local *local,
> >
> >   	list_add(&ctx->list, &local->chanctx_list);
> >
> > -	drv_add_chanctx(local, ctx);
> > +	if (drv_add_chanctx(local, ctx)) {
> > +		kfree(ctx);
> 
> We should also do a list_del() here.

Good catch. Or just move the list_add() later?

johannes

