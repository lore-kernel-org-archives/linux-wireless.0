Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46630 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab3DTRpG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Apr 2013 13:45:06 -0400
Received: by mail-we0-f174.google.com with SMTP id u12so4699290wey.33
        for <linux-wireless@vger.kernel.org>; Sat, 20 Apr 2013 10:45:04 -0700 (PDT)
Date: Sat, 20 Apr 2013 19:44:53 +0200
From: Karl Beldan <karl.beldan@gmail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH v4 2/3] mac80211/minstrel_ht: use the new rate control API
Message-ID: <20130420174453.GC767@gobelin> (sfid-20130420_194512_590587_2F695CD8)
References: <1366385329-42690-1-git-send-email-nbd@openwrt.org>
 <1366385329-42690-2-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1366385329-42690-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 19, 2013 at 05:28:48PM +0200, Felix Fietkau wrote:
> @@ -846,6 +856,8 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  
>  	msp->is_ht = true;
>  	memset(mi, 0, sizeof(*mi));
> +
> +	mi->sta = sta;
>  	mi->stats_update = jiffies;
>  
>  	ack_dur = ieee80211_frame_duration(sband->band, 10, 60, 1, 1);
> @@ -907,7 +919,6 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
>  	if (!n_supported)
>  		goto use_legacy;
>  
> -	/* init {mi,mi->groups[*]}->{max_tp_rate,max_tp_rate2,max_prob_rate} */
>  	minstrel_ht_update_stats(mp, mi);
>  
This time you kept minstrel_ht_update_stats but you got rid of the call
to minstrel_ht_update_rates you previously had.
If you don't minstrel_ht_update_rates, ieee80211_tx_h_rate_ctrl will
TX_DROP the frame until minstrel's get_sample_rate returns != -1,
Maybe you could pair update_stats with ht_update_rates, e.g move/call
ht_update_stats in ht_update_rates ?
 
Karl
