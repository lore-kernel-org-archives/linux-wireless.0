Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:41198 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752300Ab1BHPhz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:37:55 -0500
Subject: Re: [PATCH 4/5] iwlwifi: fix ack health for WiFi/BT combo devices
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297153919-18766-4-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:36:10 -0800
Message-ID: <1297179370.20613.30.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> Combo devices have TX statistics on different place, because
> struct statistics_rx_bt and struct statistics_rx have different
> size. User proper values on combo devices instead of random data.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++++--
>  1 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 8c4ca39..6dd5001 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -1419,8 +1419,13 @@ bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
>  	if (priv->_agn.agg_tids_count)
>  		return true;
>  
> -	cur = &pkt->u.stats.tx;
> -	old = &priv->_agn.statistics.tx;
> +	if (iwl_bt_statistics(priv)) {
> +		cur = &pkt->u.stats_bt.tx;
> +		old = &priv->_agn.statistics_bt.tx;
> +	} else {
> +		cur = &pkt->u.stats.tx;
> +		old = &priv->_agn.statistics.tx;
> +	}
>  
>  	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
>  		       le32_to_cpu(old->actual_ack_cnt);

Should this combine with 3/5?

Thanks
Wey

