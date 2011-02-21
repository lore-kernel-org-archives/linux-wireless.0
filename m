Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18889 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab1BUFSk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 00:18:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 20 Feb 2011 21:18:19 -0800
Date: Mon, 21 Feb 2011 10:47:15 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Sujith <m.sujith@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Sujith Manoharan <Sujith.Manoharan@Atheros.com>
Subject: Re: [PATCH 16/23] ath9k_htc: Disable powersave if an AP interface
	is present
Message-ID: <20110221051715.GA17236@vasanth-laptop>
References: <19809.52162.358774.683966@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <19809.52162.358774.683966@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 21, 2011 at 07:49:46AM +0530, Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_main.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index f384b35..4779bb1 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -1393,7 +1393,8 @@ static int ath9k_htc_config(struct ieee80211_hw *hw, u32 changed)
>  
>  	}
>  
> -	if (changed & IEEE80211_CONF_CHANGE_PS) {
> +	if ((priv->ah->opmode != NL80211_IFTYPE_AP) &&
> +	    (changed & IEEE80211_CONF_CHANGE_PS)) {
>  		if (conf->flags & IEEE80211_CONF_PS) {
>  			ath9k_htc_setpower(priv, ATH9K_PM_NETWORK_SLEEP);
>  			priv->ps_enabled = true;

Is it not that mac80211 already takes care of that?.

Vasanth
