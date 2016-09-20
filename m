Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36063 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751765AbcITM1p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Sep 2016 08:27:45 -0400
Received: by mail-wm0-f48.google.com with SMTP id w84so131135255wmg.1
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2016 05:27:44 -0700 (PDT)
Subject: Re: [PATCH 1/1] rsi: fix memory leak in debugfs entry and supported
 bands
To: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org
References: <1474353784-9552-1-git-send-email-prameela.j04cs@gmail.com>
Cc: kvalo@codeaurora.org, johannes.berg@intel.com, hofrat@osadl.org,
        xypron.glpk@gmx.de,
        Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bf37845b-81d2-2e99-15d3-caef2d1f59eb@broadcom.com> (sfid-20160920_142748_893424_47079561)
Date: Tue, 20 Sep 2016 14:27:19 +0200
MIME-Version: 1.0
In-Reply-To: <1474353784-9552-1-git-send-email-prameela.j04cs@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20-9-2016 8:43, Prameela Rani Garnepudi wrote:
> From: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.garnepudi@redpinesignals.com>
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Now you are exaggerating ;-) One of these should be sufficient. Instead
some descriptive text in the commit message is required. Describe the
scenario in which the memory is leaked, ie. during driver unload.

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

Use NUM_NL80211_BANDS instead of hardcoded value.

Regards,
Arend

> +		struct ieee80211_supported_band *sbands = &adapter->sbands[i];
> +
> +		kfree(sbands->channels);
> +	}
