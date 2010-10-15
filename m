Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43912 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930Ab0JOWLj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 18:11:39 -0400
Message-ID: <4CB8D194.9060907@openwrt.org>
Date: Sat, 16 Oct 2010 00:11:32 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH v2] ath9k:  Properly initialize ath_common->cc_lock.
References: <1287180249-18647-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1287180249-18647-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-10-16 12:04 AM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Otherwise, lockdep splats, at the least:
> [...]
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index a4c5ed4..fdc25f9 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -577,6 +577,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
>  	common->hw = sc->hw;
>  	common->priv = sc;
>  	common->debug_mask = ath9k_debug;
> +	spin_lock_init(&common->cc_lock);
>  
>  	spin_lock_init(&sc->wiphy_lock);
>  	spin_lock_init(&sc->sc_resetlock);

Makes sense. Please update ath5k as well, it also uses the lock.

- Felix
