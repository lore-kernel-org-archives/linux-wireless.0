Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48300 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932988AbcJLOWS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Oct 2016 10:22:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes.berg@intel.com,
        hofrat@osadl.org, xypron.glpk@gmx.de,
        prameela.garnepudi@redpinesignals.com
Subject: Re: [PATCH] rsi: fix memory leak in module unload
References: <1474447162-19956-1-git-send-email-prameela.j04cs@gmail.com>
Date: Wed, 12 Oct 2016 17:22:12 +0300
In-Reply-To: <1474447162-19956-1-git-send-email-prameela.j04cs@gmail.com>
        (Prameela Rani Garnepudi's message of "Wed, 21 Sep 2016 14:09:22
        +0530")
Message-ID: <87oa2pejfv.fsf@kamboji.qca.qualcomm.com> (sfid-20161012_162247_150402_96C48AAD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prameela Rani Garnepudi <prameela.j04cs@gmail.com> writes:

> debugfs entry removal statement moved inside CONFIG_RSI_DEBUGSFS flag
> added freeing of below structures
>  * channel list for each supported band
>  * rsi debugfs info
>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

[...]

> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
>  void rsi_mac80211_detach(struct rsi_hw *adapter)
>  {
>  	struct ieee80211_hw *hw = adapter->hw;
> +	enum nl80211_band band;
>  
>  	if (hw) {
>  		ieee80211_stop_queues(hw);
> @@ -201,7 +202,17 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
>  		ieee80211_free_hw(hw);
>  	}
>  
> +	for (band = 0; band < 2; band++) {
> +		struct ieee80211_supported_band *sband =
> +					&adapter->sbands[band];
> +
> +		kfree(sband->channels);
> +	}

Like Arend already mentioned[1] you should use NUM_NL80211_BANDS here
instead of hardcoded value. Yes, that will also go through
NL80211_BAND_60GHZ item but it doesn't matter as it should be empty
anyway.

[1] https://patchwork.kernel.org/patch/9341095/

-- 
Kalle Valo
