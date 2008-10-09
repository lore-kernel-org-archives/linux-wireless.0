Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:3154 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYJICPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 22:15:43 -0400
Date: Wed, 8 Oct 2008 22:15:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Elias Oltmanns <eo@nebensachen.de>
Cc: jirislaby@gmail.com, toralf.foerster@gmx.de,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com, johannes@sipsolutions.net
Subject: Re: [ath5k-devel] Oops with current kernel and ath5k
Message-ID: <20081009021516.GA14690@hash.localnet> (sfid-20081009_041602_333796_35A6F298)
References: <87bpy32c1w.fsf@denkblock.local> <b6c5339f0810021137g3d93c5c8t5fa8fb3784294a86@mail.gmail.com> <20081003134648.M45120@bobcopeland.com> <87fxnd2112.fsf@denkblock.local> <20081003193739.M19356@bobcopeland.com> <877i8nky65.fsf@denkblock.local> <20081007013529.GA9691@hash.localnet> <873aj8vg45.fsf@denkblock.local> <20081007130613.GB10693@hash.localnet> <87ljx0t9fd.fsf@denkblock.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87ljx0t9fd.fsf@denkblock.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[gmail keeps dropping CCs for some reason]

On Tue, Oct 07, 2008 at 10:52:22PM +0200, Elias Oltmanns wrote:
> Bitops on sc->status have to be protected by the sc->lock as soon as
> ieee80211_register_hw() has been called.

Agreed...

> +	mutex_lock(&sc->lock);
> +	ath5k_init_leds(sc);

I'd rather leave ath5k_init_leds in attach so it somewhat matches up 
with detach, but yeah I suppose it could use locking due to a
probe/start race.

The LED flag is not really a status flag compared to the rest, it just
says whether the hardware supports it or not.  Another approach would
be to separate it from the others.

> @@ -2881,12 +2883,14 @@ static void ath5k_configure_filter(struct ieee80211_hw *hw,
>  		AR5K_RX_FILTER_MCAST);
>  
>  	if (changed_flags & (FIF_PROMISC_IN_BSS | FIF_OTHER_BSS)) {
> +		mutex_lock(&sc->lock);

Unfortunately, I don't believe configure_filter can sleep :(

-- 
Bob Copeland %% www.bobcopeland.com

