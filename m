Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out9.libero.it ([212.52.84.109]:58640 "EHLO
	cp-out9.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbZGWVuD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 17:50:03 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: WARNING: at net/mac80211/tx.c:561
Date: Thu, 23 Jul 2009 23:47:43 +0200
Cc: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
	linux-wireless@vger.kernel.org
References: <200907230051.57201.rossi.f@inwind.it> <43e72e890907231119s5e992c91r2225f6ea77543dc8@mail.gmail.com> <43e72e890907231123w7267c022yc33f4aad63e3a3fd@mail.gmail.com>
In-Reply-To: <43e72e890907231123w7267c022yc33f4aad63e3a3fd@mail.gmail.com>
MIME-Version: 1.0
Message-Id: <200907232347.44096.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 23 July 2009, Luis R. Rodriguez wrote:

> >> Please try this patch:
> >>
> >> From: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> Subject: [PATCH] mac80211: do not trigger beacon work if scanning
> >>
> >> We were issues probe requests to the associated AP on the wrong
> >> band. This leads to finding not bitrate. We should not be doing
> >> this, so prevent the timer from stuffing beacon loss work on
> >> the mac80211 workqueue.
> >>
> >> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> >> ---
> >>  net/mac80211/mlme.c |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >> index 523c0d9..e90992e 100644
> >> --- a/net/mac80211/mlme.c
> >> +++ b/net/mac80211/mlme.c
> >> @@ -2187,7 +2187,7 @@ static void ieee80211_sta_bcn_mon_timer(unsigned
> >> long data) (struct ieee80211_sub_if_data *) data;
> >>        struct ieee80211_local *local = sdata->local;
> >>
> >> -       if (local->quiescing)
> >> +       if (local->quiescing || local->sw_scanning ||
> >> local->hw_scanning) return;
> >
> > Heh no wait, this is very wrong.
>
> Never mind, please do try it. If we are scanning we should not be
> sending probe requests through a timer. That clarifies what I mean and
> I should add that to the commit log. But please do try it.

Patch applied, now the warning is disappeared!

Fabio
