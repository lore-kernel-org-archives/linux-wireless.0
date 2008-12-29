Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37273 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbYL2MYv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 07:24:51 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] ath9k: Enable dynamic power save in ath9k.
Date: Mon, 29 Dec 2008 13:23:54 +0100
Cc: Vivek Natarajan <vivek.natraj@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
References: <20081229235300.GA8458@myhost.users.atheros.com> <1230552660.3116.33.camel@johannes>
In-Reply-To: <1230552660.3116.33.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812291323.54588.mb@bu3sch.de> (sfid-20081229_132457_737549_89BAD3FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 December 2008 13:11:00 Johannes Berg wrote:
> On Mon, 2008-12-29 at 15:53 -0800, Vivek Natarajan wrote:
> 
> > +#define ATH9K_PS_WAKEUP(sc)						      \
> > +	do {								      \
> > +		if (!atomic_read(&sc->ps_usecount) && 			      \
> > +		   (ah->ah_powerMode !=  ATH9K_PM_AWAKE)) {		      \
> > +			ah->ah_restoreMode = ah->ah_powerMode;		      \
> > +			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);	      \
> > +		}							      \
> > +		atomic_inc(&sc->ps_usecount);				      \
> > +	} while (0);
> > +
> > +#define ATH9K_PS_RESTORE(sc)						      \
> > +	do {								      \
> > +		if (atomic_dec_and_test(&sc->ps_usecount) &&  		      \
> > +		   (sc->hw->conf.flags & IEEE80211_CONF_PS))		      \
> > +			ath9k_hw_setpower(sc->sc_ah, ah->ah_restoreMode);     \
> > +	} while (0);
> 
> I think those would be better as static inlines rather than macros.

And the do-while c-block-protection of the macro is buggy. It has an extra
semicolon at the end, which defeats the whole purpose.

-- 
Greetings, Michael.
