Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1631 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbZHBDVb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Aug 2009 23:21:31 -0400
Date: Sat, 1 Aug 2009 23:20:20 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Joerg Albert <jal2@gmx.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	ath5k-devel@lists.ath5k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath5k: fix missing output in monitor mode after
	ifconfig up
Message-ID: <20090802032019.GA25339@hash.localnet>
References: <4A74C2B6.3070407@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4A74C2B6.3070407@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 02, 2009 at 12:33:26AM +0200, Joerg Albert wrote:
> Let ath5k_chan_set() call ath5k_reset() if ath5k_config() was told
> that the channel changed. This fixes the bug that we don't
> get any packets in monitor mode after:

Cool, thanks for the patch.  Just a couple of comments:

> +                              int chan_changed);

Should use bool for that.

> -       ret = ath5k_chan_set(sc, conf->channel);
> +       ret = ath5k_chan_set(sc, conf->channel,
> +                            changed & IEEE80211_CONF_CHANGE_CHANNEL);

Since this is the only place ath5k_chan_set is called, how about changing
ath5k_chan_set to unconditionally do a reset, and put the test outside?

i.e.:

        if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
                ath5k_chan_set(sc, conf->channel);

Thanks!

-- 
Bob Copeland %% www.bobcopeland.com

