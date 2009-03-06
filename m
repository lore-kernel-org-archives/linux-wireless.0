Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.187]:56885 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888AbZCFP3V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 10:29:21 -0500
Received: by ti-out-0910.google.com with SMTP id d10so302865tib.23
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2009 07:29:18 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18865.16679.121576.346045@gargle.gargle.HOWL> (sfid-20090306_162924_776641_EB310064)
Date: Fri, 6 Mar 2009 20:58:39 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: <linville@tuxdriver.com>, ath9k-devel@lists.ath9k.org,
	Jouni.Malinen@atheros.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com
Subject: [ath9k-devel] [PATCH] ath9k: Set IEEE80211_TX_CTL_RATE_CTRL_PROBE in rate control for probe rates
In-Reply-To: <1236352117-18466-2-git-send-email-vasanth@atheros.com>
References: <1236352117-18466-1-git-send-email-vasanth@atheros.com>
	<1236352117-18466-2-git-send-email-vasanth@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> ---
>  drivers/net/wireless/ath9k/rc.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
> index 8327356..a35b525 100644
> --- a/drivers/net/wireless/ath9k/rc.c
> +++ b/drivers/net/wireless/ath9k/rc.c
> @@ -750,7 +750,8 @@ static u8 ath_rc_ratefind_ht(struct ath_softc *sc,
>  static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
>  				   struct ieee80211_tx_rate *rate,
>  				   struct ieee80211_tx_rate_control *txrc,
> -				   u8 tries, u8 rix, int rtsctsenable)
> +				   u8 tries, u8 rix, int rtsctsenable,
> +				   bool is_probe)
>  {
>  	rate->count = tries;
>  	rate->idx = rix;
> @@ -765,6 +766,8 @@ static void ath_rc_rate_set_series(struct ath_rate_table *rate_table,
>  		rate->flags |= IEEE80211_TX_RC_SHORT_GI;
>  	if (WLAN_RC_PHY_HT(rate_table->info[rix].phy))
>  		rate->flags |= IEEE80211_TX_RC_MCS;
> +	if (is_probe)
> +		rate->flags |= IEEE80211_TX_CTL_RATE_CTRL_PROBE;
>  }
>  

IEEE80211_TX_CTL_RATE_CTRL_PROBE is to be used with flags@ieee80211_tx_info
and is not a per-rate flag.

Sujith
