Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:50725 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab1BHPry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 10:47:54 -0500
Subject: Re: [PATCH 5/5] iwlwifi: avoid too frequent recover from statistics
From: wwguy <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1297153919-18766-5-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
	 <1297153919-18766-5-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 07:45:53 -0800
Message-ID: <1297179953.20613.38.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Tue, 2011-02-08 at 00:31 -0800, Stanislaw Gruszka wrote:
> Usually H/W generate statistics notify once per about 100ms, but
> sometimes we can receive notify in shorter time, even 2 ms.
> 
> This can be problem for plcp health and ack health checking.
> 
> I.e. with 2 plcp errors happens randomly in 2 ms duration, we
> exceed plcp delta threshold equal to 100 (2*100/2).
> 
> Also checking ack's in short time, can results not necessary false
> positive and firmware reset, for example when channel is noised and
> we do not receive ACKs frames or when remote device does not send
> ACKs at the moment.
> 
> Patch change code, to do statistic check and possible recovery only
> if 99ms elapsed from last check. Forced delay should assure we have
> good statistic data to estimate hardware state.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c     |   24 ++++++++------
>  drivers/net/wireless/iwlwifi/iwl-agn-rx.c   |   46 +++++++++++++++++----------
>  drivers/net/wireless/iwlwifi/iwl-agn.c      |    2 +
>  drivers/net/wireless/iwlwifi/iwl-agn.h      |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-core.h     |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +-
>  drivers/net/wireless/iwlwifi/iwl-rx.c       |    4 +-
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    1 +
>  8 files changed, 53 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
> index f371d42..9646cbc 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -409,11 +409,9 @@ static void iwl3945_accumulative_statistics(struct iwl_priv *priv,
>   * to improve the throughput.
>   */
>  static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
> -				struct iwl_rx_packet *pkt)
> +				struct iwl_rx_packet *pkt, unsigned int msecs)
>  {
>  	__le32 cur_plcp_err, old_plcp_err;
> -	unsigned int msecs;
> -	unsigned long stamp;
>  	int delta;
>  	int threshold = priv->cfg->base_params->plcp_delta_threshold;
>  
> @@ -422,12 +420,7 @@ static bool iwl3945_good_plcp_health(struct iwl_priv *priv,
>  		return true;
>  	}
>  
> -	stamp = jiffies;
> -	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
> -	priv->plcp_jiffies = stamp;
> -
> -	if (msecs == 0)
> -		return true;
> +	BUG_ON(msecs == 0);

why not just return? I understand it should not be "0", but really need
BUG_ON?
 
>  
> -	stamp = jiffies;
> -	msecs = jiffies_to_msecs(stamp - priv->plcp_jiffies);
> -	priv->plcp_jiffies = stamp;
> -
> -	if (msecs == 0)
> -		return true;
> +	BUG_ON(msecs == 0);
Same above


Similar question, we are very close to finish driver split, when is the
best time for this patch?

Thanks
Wey

