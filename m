Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:58706 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751771AbcCaLg6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2016 07:36:58 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>
Subject: RE: [PATCH] mwifiex: fix Tx timeout issue during suspend test
Date: Thu, 31 Mar 2016 11:36:53 +0000
Message-ID: <eb104a7f836547158e51a84fa4d1b677@SC-EXCH04.marvell.com> (sfid-20160331_133701_920929_15E4FE30)
References: <1458139576-4702-1-git-send-email-akarwar@marvell.com>
In-Reply-To: <1458139576-4702-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

> From: Amitkumar Karwar [mailto:akarwar@marvell.com]
> Sent: Wednesday, March 16, 2016 8:16 PM
> To: linux-wireless@vger.kernel.org
> Cc: Nishant Sarmukadam; Amitkumar Karwar
> Subject: [PATCH] mwifiex: fix Tx timeout issue during suspend test
> 
> Call netif_carrier_off/on while stoping/starting netdev queues.
> This fixes netdev watchdog warning and ->ndo_tx_timeout() invocation
> during suspend resume stress test.
> 
> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
> Fixes: 54f008497b9f09f ('mwifiex: Empty Tx queue during suspend')
> Tested-by: Wei-Ning Huang <wnhuang@chromium.org>
> ---
>  drivers/net/wireless/marvell/mwifiex/cfg80211.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> index bb7235e..b0663bd 100644
> --- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> +++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
> @@ -3272,8 +3272,11 @@ static int mwifiex_cfg80211_suspend(struct wiphy
> *wiphy,
> 
>  	for (i = 0; i < adapter->priv_num; i++) {
>  		priv = adapter->priv[i];
> -		if (priv && priv->netdev)
> +		if (priv && priv->netdev) {
>  			mwifiex_stop_net_dev_queue(priv->netdev, adapter);
> +			if (netif_carrier_ok(priv->netdev))
> +				netif_carrier_off(priv->netdev);
> +		}
>  	}
> 
>  	for (i = 0; i < retry_num; i++) {
> @@ -3344,8 +3347,11 @@ static int mwifiex_cfg80211_resume(struct wiphy
> *wiphy)
> 
>  	for (i = 0; i < adapter->priv_num; i++) {
>  		priv = adapter->priv[i];
> -		if (priv && priv->netdev)
> +		if (priv && priv->netdev) {
> +			if (!netif_carrier_ok(priv->netdev))
> +				netif_carrier_on(priv->netdev);
>  			mwifiex_wake_up_net_dev_queue(priv->netdev, adapter);
> +		}
>  	}
> 
>  	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
> --
> 1.8.1.4


Could you please take this patch? It fixes an issue introduced by "mwifiex: Empty Tx queue during suspend"

Regards,
Amitkumar
