Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55750 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab2LGHxc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 02:53:32 -0500
Message-ID: <1354866830.9552.2.camel@jlt4.sipsolutions.net> (sfid-20121207_085335_751910_8F3F4237)
Subject: Re: [PATCH 01/24] regulatory: don't write past array when
 intersecting rules
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Dec 2012 08:53:50 +0100
In-Reply-To: <CAB=NE6VCgdMtj_v07BBZ36pOEP_qzVPR_YOe--C3iXw=_KMVgw@mail.gmail.com> (sfid-20121207_004322_625360_A0828621)
References: <1354812468-15709-1-git-send-email-johannes@sipsolutions.net>
	 <1354812468-15709-2-git-send-email-johannes@sipsolutions.net>
	 <CAB=NE6VCgdMtj_v07BBZ36pOEP_qzVPR_YOe--C3iXw=_KMVgw@mail.gmail.com>
	 (sfid-20121207_004322_625360_A0828621)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-12-06 at 15:43 -0800, Luis R. Rodriguez wrote:

> > diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> > index b6c7ea6..4197359 100644
> > --- a/net/wireless/reg.c
> > +++ b/net/wireless/reg.c
> > @@ -648,9 +648,9 @@ static struct ieee80211_regdomain *regdom_intersect(
> >         if (!rd)
> >                 return NULL;
> >
> > -       for (x = 0; x < rd1->n_reg_rules; x++) {
> > +       for (x = 0; x < rd1->n_reg_rules && rule_idx < num_rules; x++) {
> >                 rule1 = &rd1->reg_rules[x];
> > -               for (y = 0; y < rd2->n_reg_rules; y++) {
> > +               for (y = 0; y < rd2->n_reg_rules && rule_idx < num_rules; y++) {
> >                         rule2 = &rd2->reg_rules[y];
> >                         /*
> 
> Does rule_idx ever become > num_rules though? The check that builds
> num_rules are the same as we traverse and increment rule_idx.

It doesn't become great, but it becomes equal. Say you have the
following rules:

rd1: 1000-2000, 3000-4000
rd2: 1000-1500, 5000-6000

The result will be 1000-1500, so 1 rule. But while iterating, that's the
very first thing, so rule_idx becomes 1 after the first iteration of the
inner/outer loops, and then without the fix we still check 1000-2000 vs.
5000-6000, 3000-4000 vs. 1000-1500 and finally 3000-4000 vs. 5000-6000
and rule_idx is 1 all the time while checking that so we write past the
array ...

This makes it stop when it knows it has found the right number of rules.

johannes

