Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 207-172-69-77.c3-0.smr-ubr3.sbo-smr.ma.static.cable.rcn.com ([207.172.69.77]:52994
	"EHLO thaum.luto.us" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab0LONFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 08:05:03 -0500
Message-ID: <4D08BB15.5070803@mit.edu>
Date: Wed, 15 Dec 2010 07:56:53 -0500
From: Andy Lutomirski <luto@mit.edu>
MIME-Version: 1.0
To: Sujith <m.sujith@gmail.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Sujith.Manoharan@atheros.com
Subject: Re: [PATCH] mac80211: Add timeout to BA session start API
References: <19720.9510.589223.207856@gargle.gargle.HOWL>
In-Reply-To: <19720.9510.589223.207856@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith wrote:
> From: Sujith Manoharan <Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>
> 
> Allow drivers or rate control algorithms to specify BlockAck session
> timeout when initiating an ADDBA transaction. This is useful in cases
> where maintaining persistent BA sessions does not incur any overhead.
> 
> The current timeout value of 5000 TUs is retained for all non ath9k/ath9k_htc
> drivers.
> 
> Signed-off-by: Sujith Manoharan <Sujith.Manoharan-DlyHzToyqoxBDgjK7y7TUQ@public.gmane.org>
> ---
>  drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    2 +-
>  drivers/net/wireless/ath/ath9k/rc.c           |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn-rs.c     |    2 +-
>  include/net/mac80211.h                        |    4 +++-
>  net/mac80211/agg-tx.c                         |    7 +++++--
>  net/mac80211/debugfs_sta.c                    |    2 +-
>  net/mac80211/rc80211_minstrel_ht.c            |    2 +-
>  net/mac80211/sta_info.h                       |    2 ++
>  8 files changed, 15 insertions(+), 8 deletions(-)
> 

[...]

> diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
> index 4ad7a36..165a451 100644
> --- a/net/mac80211/rc80211_minstrel_ht.c
> +++ b/net/mac80211/rc80211_minstrel_ht.c
> @@ -374,7 +374,7 @@ minstrel_aggr_check(struct minstrel_priv *mp, struct ieee80211_sta *pubsta, stru
>  	if (skb_get_queue_mapping(skb) == IEEE80211_AC_VO)
>  		return;
>  
> -	ieee80211_start_tx_ba_session(pubsta, tid);
> +	ieee80211_start_tx_ba_session(pubsta, tid, 5000);

What about ath9k with minstrel_ht as rc?  A lot of openwrt users (e.g. me) use
this.

--Andy
