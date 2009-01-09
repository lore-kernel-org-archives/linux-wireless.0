Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60066 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbZAIUAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 15:00:43 -0500
Date: Fri, 9 Jan 2009 14:51:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath9k: Enable dynamic power save in ath9k.
Message-ID: <20090109195119.GC3371@tuxdriver.com> (sfid-20090109_210052_557226_955EDFEC)
References: <20081229235300.GA8458@myhost.users.atheros.com> <1230552660.3116.33.camel@johannes> <8e92b4100812290537q7605b39dg382fe5d42963c65a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8e92b4100812290537q7605b39dg382fe5d42963c65a@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 07:07:41PM +0530, Vivek Natarajan wrote:
> On Mon, Dec 29, 2008 at 5:41 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Mon, 2008-12-29 at 15:53 -0800, Vivek Natarajan wrote:
> >
> >> +#define ATH9K_PS_WAKEUP(sc)                                                \
> >> +     do {                                                                  \
> >> +             if (!atomic_read(&sc->ps_usecount) &&                         \
> >> +                (ah->ah_powerMode !=  ATH9K_PM_AWAKE)) {                   \
> >> +                     ah->ah_restoreMode = ah->ah_powerMode;                \
> >> +                     ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);         \
> >> +             }                                                             \
> >> +             atomic_inc(&sc->ps_usecount);                                 \
> >> +     } while (0);
> >> +
> >> +#define ATH9K_PS_RESTORE(sc)                                               \
> >> +     do {                                                                  \
> >> +             if (atomic_dec_and_test(&sc->ps_usecount) &&                  \
> >> +                (sc->hw->conf.flags & IEEE80211_CONF_PS))                  \
> >> +                     ath9k_hw_setpower(sc->sc_ah, ah->ah_restoreMode);     \
> >> +     } while (0);
> >
> > I think those would be better as static inlines rather than macros.
> >
> > johannes
> 
> Thanks Johannes. I'll change them.
> 
> > Also, this seems racy, shouldn't it use something like if
> > (atomic_inc_return() == 1) ?
> 
> Thanks.This seems much better.

Did you repost this?  I don't see it.  Please (re?)send it to the
list w/ the requested changes.

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
