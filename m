Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519Ab2LMVh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 16:37:28 -0500
Message-ID: <1355434671.9463.25.camel@jlt4.sipsolutions.net> (sfid-20121213_223731_938177_38D55C58)
Subject: Re: [PATCH 20/24] regulatory: fix memory leak
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 13 Dec 2012 22:37:51 +0100
In-Reply-To: <CAB=NE6Ush3Z+-V2LXtW4ApYqig+FfHz1Jm1dUXc5cka2Gnougg@mail.gmail.com> (sfid-20121213_223556_873761_D80C8EDE)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-21-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6Ush3Z+-V2LXtW4ApYqig+FfHz1Jm1dUXc5cka2Gnougg@mail.gmail.com>
	 (sfid-20121213_223556_873761_D80C8EDE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-13 at 13:35 -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 6, 2012 at 8:47 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > From: Johannes Berg <johannes.berg@intel.com>
> >
> > If duplicating here fails, we leak the original.
> >
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> >  net/wireless/reg.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index 011fab9..5a34830 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -2120,8 +2120,10 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
> >                         return -EALREADY;
> >
> >                 regd = reg_copy_regd(rd);
> > -               if (IS_ERR(regd))
> > +               if (IS_ERR(regd)) {
> > +                       kfree(rd);
> >                         return PTR_ERR(regd);
> > +               }
> 
> The caller, set_regdom() free's t for us if we fail though so I don't
> see how this was leaked.

Oops, so this patch is wrong, I'll drop it.

johannes

