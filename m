Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33545 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753795Ab0K1RzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Nov 2010 12:55:10 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 28 Nov 2010 09:54:56 -0800
Date: Sun, 28 Nov 2010 23:24:43 +0530
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Rajkumar Manoharan <Rajkumar.Manoharan@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath9k: Add change_interface callback
Message-ID: <20101128175439.GA6721@vmraj-lnx.users.atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
 <1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
 <1290797285.3531.23.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1290797285.3531.23.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 27, 2010 at 12:18:05AM +0530, Johannes Berg wrote:
> On Fri, 2010-11-26 at 23:24 +0530, Rajkumar Manoharan wrote:
> 
> > +static int ath9k_change_interface(struct ieee80211_hw *hw,
> > +				  struct ieee80211_vif *vif,
> > +				  enum nl80211_iftype new_type,
> > +				  bool p2p)
> > +{
> > +	struct ath_wiphy *aphy = hw->priv;
> > +	struct ath_softc *sc = aphy->sc;
> > +	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> > +
> > +	ath_print(common, ATH_DBG_CONFIG, "Change Interface\n");
> > +	mutex_lock(&sc->mutex);
> > +
> > +	new_type = ieee80211_iftype_p2p(new_type, p2p);
> 
> I'm pretty sure you won't want that, and will just use new_type directly
> because you don't care about P2P or non-P2P as of now.
>
Yes and I missed to store new p2p bool value too ;) Thanks for pointing out.

--
Rajkumar
