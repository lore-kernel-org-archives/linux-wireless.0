Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:62190 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZKBG41 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 01:56:27 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2009 22:56:32 -0800
Date: Mon, 2 Nov 2009 12:26:19 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC] ath9k: fix listening to idle requests
Message-ID: <20091102065616.GB1989@vasanth-laptop>
References: <1256849546-15119-1-git-send-email-lrodriguez@atheros.com> <20091030063306.GH4602@vasanth-laptop> <43e72e890910300738i29a81f54p57fd0c6fdccbcaf5@mail.gmail.com> <20091031052952.GA1989@vasanth-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20091031052952.GA1989@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Oct 31, 2009 at 10:59:53AM +0530, Vasanth Thiagarajan wrote:
> On Fri, Oct 30, 2009 at 08:08:22PM +0530, Luis Rodriguez wrote:
> > On Thu, Oct 29, 2009 at 11:33 PM, Vasanthakumar Thiagarajan
> > <vasanth@atheros.com> wrote:
> > > On Fri, Oct 30, 2009 at 02:22:26AM +0530, Luis Rodriguez wrote:
> > >> The way idle configuration detection was implemented as
> > >> busted due to the fact that it assumed the ath9k virtual wiphy,
> > >> the aphy, would be marked as inactive if it was not used but
> > >> it turns out an aphy is always active if its the only wiphy
> > >> present. We need to distinguish between aphy activity and
> > >> idleness so we now add an idle bool for the aphy and mark
> > >> it as such based on the passed IEEE80211_CONF_CHANGE_IDLE
> > >> from mac80211.
> > >>
> > >> Previous to all_wiphys_idle would never be true when using
> > >> only one device so we never really were using
> > >> IEEE80211_CONF_CHANGE_IDLE -- we never turned the radio
> > >> off or on upon IEEE80211_CONF_CHANGE_IDLE changes as radio
> > >> changes depended on all_wiphys_idle being true either to
> > >> turn the radio on or off. Since it was always false for
> > >> one device this code was doing nothing.
> > >>
> > >> Reported-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> > >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > >> ---
> > >>
> > >> Vasanth, what do you think?
> > >
> > > Still we will have issue when bringing up a sec wiphy while the
> > > primary wiphy is in idle state. ath9k_start() does not brought up
> > > the newly created wiphy interface when the state of at least one
> > > previously created interface is in ACTIVE state. Unless already
> > > brought up interfaces are put down we hit this situation whenever
> > > we try to bring up a new secondary wiphy interface. So with this
> > > patch the actual h/w will remain radio disabled state even after
> > > a new interface is in active state. We need to bring the h/w into
> > > active state if all old interfaces are in idle state in
> > > ath9k_start().
> >
> > I don't see what prevents a secondary virtual wiphy from getting the
> > radio started -- perhaps I'm missing something. When a virtual wiphy
> > needs to become non-idle that'll come from the mac80211 non-idle
> > config call and that will find that one device is non-idle and hence
> > start it.
> 
> mac80211 will issue config() for non-idle only when the respective
> wiphy is already put into idle state.

When testing the patch I did not see this issue. The patch works
fine. I'll debug it further to see why the issue I was expecting
did not show up, but now this patch looks fine.

Vasanth
