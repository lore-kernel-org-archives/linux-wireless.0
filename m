Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49245 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3CVJ4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Mar 2013 05:56:33 -0400
Message-ID: <1363946185.8238.1.camel@jlt4.sipsolutions.net> (sfid-20130322_105638_072014_70824DB4)
Subject: Re: [PATCH v3] mac80211:  Don't restart sta-timer if not associated.
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Fri, 22 Mar 2013 10:56:25 +0100
In-Reply-To: <20130320073028.GC1761@redhat.com> (sfid-20130320_082953_024251_C5540681)
References: <1363740650-1626-1-git-send-email-greearb@candelatech.com>
	 <20130320073028.GC1761@redhat.com> (sfid-20130320_082953_024251_C5540681)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-03-20 at 08:30 +0100, Stanislaw Gruszka wrote:
> On Tue, Mar 19, 2013 at 05:50:50PM -0700, greearb@candelatech.com wrote:
> > From: Ben Greear <greearb@candelatech.com>
> > 
> > I found another crash when deleting lots of virtual stations
> > in a congested environment.  I think the problem is that
> > the ieee80211_mlme_notify_scan_completed could call
> > ieee80211_restart_sta_timer for a stopped interface
> > that was about to be deleted.
> > 
> > With the following patch I am unable to reproduce the
> > crash.
> > 
> > Signed-off-by: Ben Greear <greearb@candelatech.com>
> > ---
> > v3:  Just check for sdata-is-running once at top of method
> >   instead of worrying about if it is associated or not.
> > 
> > :100644 100644 aec786d... 74a8c5f... M	net/mac80211/mlme.c
> >  net/mac80211/mlme.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index aec786d..74a8c5f 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -2933,6 +2933,9 @@ static void ieee80211_restart_sta_timer(struct ieee80211_sub_if_data *sdata)
> >  {
> >  	u32 flags;
> >  
> > +	if (!ieee80211_sdata_running(sdata))
> > +		return;
> > +
> 
> I think this check should go to ieee80211_mlme_notify_scan_completed(),
> and another one to ieee80211_mesh_notify_scan_completed(), IBSS already
> has it.

I made these changes and applied it.

johannes

