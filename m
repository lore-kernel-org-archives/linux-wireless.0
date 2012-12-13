Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754635Ab2LMVez (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:34:55 -0500
Message-ID: <1355434516.9463.24.camel@jlt4.sipsolutions.net> (sfid-20121213_223458_037822_D90CED25)
Subject: Re: [PATCH 18/24] regulatory: fix reg_is_valid_request handling
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 22:35:16 +0100
In-Reply-To: <CAB=NE6WVa8bqbe2oyfpEaEJ84s6+C=9wM9+wzgtm6HUNaqm4DQ@mail.gmail.com> (sfid-20121213_222736_616047_BC93283F)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-19-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6WVa8bqbe2oyfpEaEJ84s6+C=9wM9+wzgtm6HUNaqm4DQ@mail.gmail.com>
	 (sfid-20121213_222736_616047_BC93283F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 13:27 -0800, Luis R. Rodriguez wrote:

> > diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> > index 260b5d8..370cd31 100644
> > --- a/net/wireless/nl80211.c
> > +++ b/net/wireless/nl80211.c
> > @@ -4333,6 +4326,8 @@ static int nl80211_set_reg(struct sk_buff *skb, struct genl_info *info)
> >                 }
> >         }
> >
> > +       mutex_lock(&cfg80211_mutex);
> > +
> >         r = set_regdom(rd);
> >         rd = NULL;
> 
> Unless you removed it from previous patches in the series the
> "bad_reg" goto label has an unlock but above you removed the top
> locking call so I think you just forgot to remove the unlock on the
> goto label.

Good catch. Wonder why smatch didn't complain? Fixed.


> > @@ -1471,6 +1475,7 @@ new_request:

        if (last_request != &core_request_world)
                kfree(last_request);

> >
> >         last_request = pending_request;
> >         last_request->intersect = intersect;
> > +       last_request->processed = false;
> 
> The clearing you are doing is on the last_request but it comes from
> the pending regulatory request which is always false given that the
> request is kzalloc'd, not sure if that was needed or how that helped.

Not necessarily, I added a bit more context above -- if it's
core_request_world the clearing is needed I believe.

johannes

