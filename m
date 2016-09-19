Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:64662 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752100AbcISR2B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 13:28:01 -0400
Subject: Re: [PATCH] rsi: fix memory leak in debugfs entry and supported bands
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org
References: <1474282311-21541-1-git-send-email-prameela.j04cs@gmail.com>
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
From: Heinrich Schuchardt <xypron.glpk@gmx.de>
Message-ID: <a3bc60bb-05c9-4fc5-5db1-5098c30f49c4@gmx.de> (sfid-20160919_192805_478067_E5EE5E17)
Date: Mon, 19 Sep 2016 19:25:52 +0200
MIME-Version: 1.0
In-Reply-To: <1474282311-21541-1-git-send-email-prameela.j04cs@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2016 12:51 PM, Prameela Rani Garnepudi wrote:
> From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
> ---
>  drivers/net/wireless/rsi/rsi_91x_mac80211.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> index dbb2389..dc64532 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
> @@ -194,6 +194,7 @@ static void rsi_register_rates_channels(struct rsi_hw *adapter, int band)
>  void rsi_mac80211_detach(struct rsi_hw *adapter)
>  {
>  	struct ieee80211_hw *hw = adapter->hw;
> +	int i;
>  
>  	if (hw) {
>  		ieee80211_stop_queues(hw);
> @@ -201,7 +202,16 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
>  		ieee80211_free_hw(hw);
>  	}
>  
> +	for (i = 0; i < 2; i++) {
> +		struct ieee80211_supported_band *sbands = &adapter->sbands[i];
> +
> +		kfree(sbands->channels);
> +	}
> +
> +#ifdef CONFIG_RSI_DEBUGFS
>  	rsi_remove_dbgfs(adapter);
> +	kfree(adapter->dfsentry);
> +#endif
>  }
>  EXPORT_SYMBOL_GPL(rsi_mac80211_detach);
>  
> 

Please, use
  git format-patch -ns HEAD~1..HEAD
to create the patch message and
  git send-email
to post your patch including your commit message.

Best regards

Heinrich
