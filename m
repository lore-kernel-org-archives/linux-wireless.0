Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:55718 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab1JJTZL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 15:25:11 -0400
Received: by bkbzs2 with SMTP id zs2so9882411bkb.0
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 12:25:08 -0700 (PDT)
Subject: Re: [PATCH 10/29] wl12xx: move tx_security_seq into wlvif
From: Luciano Coelho <coelho@ti.com>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1318234397-21081-11-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
	 <1318234397-21081-11-git-send-email-eliad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 22:25:05 +0300
Message-ID: <1318274705.9690.399.camel@cumari> (sfid-20111010_212515_198039_6458D4FC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-10 at 10:12 +0200, Eliad Peller wrote: 
> The last security seq num has to be saved across reconfigs.
> Add a new "persistent" struct into wlvif, which won't get
> deleted on wl12xx_init_vif_data()
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>
> ---




> @@ -1910,8 +1914,8 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
>  {
>  	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
>  
> -	/* make sure wlvif is zeroed */
> -	memset(wlvif, 0, sizeof(*wlvif));
> +	/* clear everything but the persistent data */
> +	memset(wlvif, 0, offsetof(struct wl12xx_vif, persistent));

Nice trick! :)


> diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
> index c7be151..0a5fef5 100644
> --- a/drivers/net/wireless/wl12xx/tx.c
> +++ b/drivers/net/wireless/wl12xx/tx.c
> @@ -755,6 +755,8 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
>  				      struct wl1271_tx_hw_res_descr *result)
>  {
>  	struct ieee80211_tx_info *info;
> +	struct ieee80211_vif *vif;
> +	struct wl12xx_vif *wlvif;
>  	struct sk_buff *skb;
>  	int id = result->id;
>  	int rate = -1;
> @@ -774,6 +776,10 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
>  		return;
>  	}
>  
> +	/* info->control is valid as long as we don't update info->status */
> +	vif = info->control.vif;
> +	wlvif = wl12xx_vif_to_data(vif);

>From a comment in the ieee80211_tx_info struct in mac80211.h:

/* NB: vif can be NULL for injected frames */

Should we check the vif here...


> 	/* update the TX status info */
>  	if (result->status == TX_SUCCESS) {
>  		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
> @@ -801,14 +807,14 @@ static void wl1271_tx_complete_packet(struct wl1271 *wl,
>  	     info->control.hw_key->cipher == WLAN_CIPHER_SUITE_CCMP ||
>  	     info->control.hw_key->cipher == WL1271_CIPHER_SUITE_GEM)) {
>  		u8 fw_lsb = result->tx_security_sequence_number_lsb;
> -		u8 cur_lsb = wl->tx_security_last_seq_lsb;
> +		u8 cur_lsb = wlvif->tx_security_last_seq_lsb;

...because we're accessing it directly here?

And don't we get TX complete events for dummy packets?

> 		/*
>  		 * update security sequence number, taking care of potential
>  		 * wrap-around
>  		 */
> -		wl->tx_security_seq += (fw_lsb - cur_lsb + 256) % 256;
> -		wl->tx_security_last_seq_lsb = fw_lsb;
> +		wlvif->tx_security_seq += (fw_lsb - cur_lsb + 256) % 256;
> +		wlvif->tx_security_last_seq_lsb = fw_lsb;

We could change this (... + 256) % 256 here for & 0xFF as Ido suggested
for some other code earlier.


-- 
Cheers,
Luca.

