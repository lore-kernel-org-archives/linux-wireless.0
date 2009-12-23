Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:35909 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbZLWDt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Dec 2009 22:49:56 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 22 Dec 2009 19:49:55 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19249.38711.712672.190663@gargle.gargle.HOWL>
Date: Wed, 23 Dec 2009 09:36:15 +0530
To: Luis Rodriguez <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Asus eeepc 1008HA suspend issue and mac80211 suspend corner case
In-Reply-To: <43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
References: <20091222022355.GA32508@bombadil.infradead.org>
	<19248.19829.293087.367661@gargle.gargle.HOWL>
	<20091222155005.GA4385@tux>
	<20091222162055.GC4385@tux>
	<20091222165528.GE4385@tux>
	<20091222175939.GF4385@tux>
	<43e72e890912221716r64ea4542qd747302b536a3156@mail.gmail.com>
	<19249.34294.19925.963051@gargle.gargle.HOWL>
	<43e72e890912221854s5f06a0d2jcfffb1cc8d857347@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis Rodriguez wrote:
> > diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
> > index 419c382..7fdcc6b 100644
> > --- a/drivers/net/wireless/ath/ath9k/main.c
> > +++ b/drivers/net/wireless/ath/ath9k/main.c
> > @@ -2673,6 +2673,11 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
> >
> >        mutex_lock(&sc->mutex);
> >
> > +       if (sc->sc_flags & SC_OP_INVALID) {
> > +               mutex_unlock(&sc->mutex);
> > +               return 0;
> > +       }
> > +
> >        /*
> >         * Leave this as the first check because we need to turn on the
> >         * radio if it was disabled before prior to processing the rest
> 
> That ones busts the resume.

Weird, checking for the device status before allowing configuration
changes is valid. Not sure why this is happening.

Sujith
