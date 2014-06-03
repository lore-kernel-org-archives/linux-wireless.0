Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59782 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932714AbaFCRKt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 13:10:49 -0400
Message-ID: <1401815433.4157.16.camel@jlt4.sipsolutions.net> (sfid-20140603_191052_819681_88C0F579)
Subject: Re: [PATCH v7 1/5] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 03 Jun 2014 19:10:33 +0200
In-Reply-To: <CA+BoTQnhOePTuDrzv_YNU6dmroRydqWfNjSj_e0UT6=SWu5r9w@mail.gmail.com> (sfid-20140603_081522_037334_31BAA2B3)
References: <1401348851-26732-1-git-send-email-michal.kazior@tieto.com>
	 <1401348851-26732-2-git-send-email-michal.kazior@tieto.com>
	 <1401708800.5528.62.camel@dubbel>
	 <CA+BoTQnhOePTuDrzv_YNU6dmroRydqWfNjSj_e0UT6=SWu5r9w@mail.gmail.com>
	 (sfid-20140603_081522_037334_31BAA2B3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-03 at 08:15 +0200, Michal Kazior wrote:

> Hmm... (my brain..)
> 
> Consider the following: 3 ctx, 6 vifs. cannot create more ctx.
> ctx1=vif1+vif2, ctx2=vif3+vif4, ctx3=vif5+vif6. ctx1..3 have
> chandef1..3.
> 
> vif5 wants chandef4 so it allocates ctx4 and sets `replaces` to ctx3.
> vif6 wants chandef5 so it allocates ctx5 and sets `replaces` to ctx1.
> [ note ctx1 with its assigned vif1 and vif2 ]
> vif3 wants chandef5 so it reserves ctx5.
> vif4 wants chandef5 so it reserves ctx5.
> [ ctx2 could be considered now as "free" and could be set as
> `replaces` for ctx5 instead of ctx1 ]
> 
> It's pretty far fetched for now I'd say - are there any devices that
> support more than 2 channels now?

Not right now, afaik, but in theory I think our device could have such
cases. But it wouldn't have enough vifs ;-)

Somebody is working on ath9k multi-channel though I believe - will be
interesting to see what happens there.

> >> +     struct ieee80211_sub_if_data *sdata, *sdata_tmp;
> >> +     struct ieee80211_chanctx *new_ctx = NULL, *ctx, *ctx_tmp;
> >
> > I prefer if declarations with assignments are in lines of their own, but
> > maybe it's just me.
> 
> Actually fair point. I'm declaring multiple vars here..

I think the above is fine, but if you want to declare on multiple lines
that's OK too. Maybe just separate the one with from the ones without
initialization?

> >> +     list_for_each_entry(ctx, &local->chanctx_list, list) {
> >> +             if (!(ctx->replaces && !ctx->replaced_by))
> >> +                     continue;
> >
> > if (!ctx->replaces || ctx->replaced_by) looks more natural to me. (Same
> > thing for some other cases in this patch).
> 
> I find it easier to reason with my condition. But yeah. Popular vote? :-)

Uh, I find them almost equally unreadable, but then again I have no idea
what "replaces" and "replaced_by" means :-)

*looking*...

Oh, those are pointers. I thought they were bool, reviewing without
paying attention is the one case where using bools as pointers is no
good I guess ;-)

I'm assuming that "ctx->replaces && ctx->replaced_by" is always false,
right? Or are some sort of concurrent replacement chains possible? In
this case though I don't understand the logic at all - shouldn't it be
equivalent to just checking ctx->replaces then?

Maybe for such logic it would be easier to understand to have

enum {
	NOT_AFFECTED,
	WILL_BE_REPLACED,
	IS_REPLACEMENT,
} replacement_state;
struct chanctx *replace_ctx;

then you can replace (pun intended) this check with

	if (ctx->replacement_state != IS_REPLACEMENT)
		continue;

But maybe I'm misunderstanding something entirely.

> > Hadn't we decided to disconnect the vifs that didn't follow? Can't
> > remember anymore. :) But now you're just canceling the whole switch?
> 
> I'm not sure myself anymore either. This keeps the current behaviour
> (i.e. disconnect interfaces that are switching on failure). Johannes?

I think I'd prefer to disconnect the failing switch ones, rather than
the other ones - seems simpler (since we know which ones are affected)
and easier to understand as it's a more localized operation. Any
arguments for the other way?


> >> +     if (!(old_ctx->replaced_by && new_ctx->replaces)) {
> >
> > Isn't !old->ctx->replaced_by enough here? Do you really care if the
> > new_ctx will replace something else at this point?
> 
> Hmm..
> 
> Now that I think this should actually be just:
> 
>  if (!new_ctx->replaces) { ... }

Oh ... I think that's what I asked above. Nah. This check actually means
that it *is* possible that replaced_by and replaces are true at the same
time? *confused*

johannes

