Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43316 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753909Ab0KZSsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 13:48:08 -0500
Subject: Re: [PATCH 2/3] ath9k: Add change_interface callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
References: <1290794073-5309-1-git-send-email-rmanoharan@atheros.com>
	 <1290794073-5309-2-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 26 Nov 2010 19:48:05 +0100
Message-ID: <1290797285.3531.23.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-26 at 23:24 +0530, Rajkumar Manoharan wrote:

> +static int ath9k_change_interface(struct ieee80211_hw *hw,
> +				  struct ieee80211_vif *vif,
> +				  enum nl80211_iftype new_type,
> +				  bool p2p)
> +{
> +	struct ath_wiphy *aphy = hw->priv;
> +	struct ath_softc *sc = aphy->sc;
> +	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
> +
> +	ath_print(common, ATH_DBG_CONFIG, "Change Interface\n");
> +	mutex_lock(&sc->mutex);
> +
> +	new_type = ieee80211_iftype_p2p(new_type, p2p);

I'm pretty sure you won't want that, and will just use new_type directly
because you don't care about P2P or non-P2P as of now.

johannes

