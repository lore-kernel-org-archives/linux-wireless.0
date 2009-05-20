Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:17106 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754913AbZETBZA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 21:25:00 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 18:25:02 -0700
Date: Tue, 19 May 2009 18:25:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Bob Copeland <me@bobcopeland.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath9k: fix custom regulatory call position
Message-ID: <20090520012504.GC7639@tesla>
References: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com> <b6c5339f0905191533v30683b9cueb929f44f2f8725@mail.gmail.com> <43e72e890905191542k7e65200en8b6f9453ead1a21a@mail.gmail.com> <20090520005101.GA16051@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20090520005101.GA16051@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 19, 2009 at 05:51:01PM -0700, Bob Copeland wrote:
> On Tue, May 19, 2009 at 03:42:56PM -0700, Luis R. Rodriguez wrote:
> > >> @@ -1412,8 +1412,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
> > >>        for (i = 0; i < sc->keymax; i++)
> > >>                ath9k_hw_keyreset(ah, (u16) i);
> > >>
> > >> -       error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
> > >> -                             ath9k_reg_notifier);
> > >>        if (error)
> > >>                goto bad;
> > >
> > > Is the "if (error)" check still valid?
> >
> > Sure, although we'll never hit it, we should just make ath_regd_init() void
> 
> I should rephrase that as a statement :)  You moved the ath_regd_init
> but forgot to remove the "if (error) goto bad" part.

Heh... thanks, will resend.

  Luis
