Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40722 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754121AbYJBTty (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Oct 2008 15:49:54 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 02 Oct 2008 12:49:54 -0700
Date: Thu, 2 Oct 2008 05:49:41 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Tomas Winkler <tomasw@gmail.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v4] mac80211: re-enable aggregation on 2.6.27
Message-ID: <20081002124941.GB5960@tesla> (sfid-20081002_214958_099665_8EE608C0)
References: <1222790548-7391-1-git-send-email-lrodriguez@atheros.com> <1ba2fa240809301318p16bedbdr31fdaea97c3cf3be@mail.gmail.com> <20080930152524.GA8131@tesla> <1ba2fa240809301707i22cab6b7hb1b22fc88ebda7f0@mail.gmail.com> <43e72e890810011216y17c3f4a6v28c74215c023ecb2@mail.gmail.com> <1ba2fa240810020427m307404b6x434830e2a3e5bf1b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1ba2fa240810020427m307404b6x434830e2a3e5bf1b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 02, 2008 at 04:27:36AM -0700, Tomas Winkler wrote:
> On Wed, Oct 1, 2008 at 10:16 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Tue, Sep 30, 2008 at 5:07 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> >> On Tue, Sep 30, 2008 at 6:25 PM, Luis R. Rodriguez
> >> <lrodriguez@atheros.com> wrote:
> >>> A quick test indicates it works but the removal is still an issue.
> >>
> >> I didn't implement it yet I just wanted a feedback if I'm in correct
> >> direction with the starting part.
> >
> > Seems reasonable so far, my concern so far was just the introduction
> > of a new spinlock for the ba_session list, but I can't see yet a
> > better way.
> >
> > At this point I've given up hope of this getting merged but I do think
> > distributions using 2.6.27 will want this anyway so we might as well
> > finish the job and maintain it ourselves should it not get merged.
> > What do you think?
> >
> >> yes ieee80211_init_agg()
> >
> > Thanks, I'm using this now.
> >
> >>> I don't think it was locking before under the code which is now
> >>> under initiate_aggr_and_timer() though.
> >>
> >> Correct you cannot lock this part it leads to soft lock.
> >
> > Oh ok v3 had this order.
> >
> >  Luis
> >
> I'm proposing to drop this implementation at all and focus on correct
> solution , this is just too messy.
> Maybe develop it over 2.6.27 so it will be maybe merge to stable
> release as well.

Well a clean solution would you to either move aggregation
queues to your drivers completely or make it optional (not sure if this
is worth it, what other hardware requires this???), which is a huge
change, which would not go into 2.6.27 for sure and I feel perhaps
distributions would be more reluctant to carry around.

Either way we still need an aggregation fix 2.6.27.

  Luis
