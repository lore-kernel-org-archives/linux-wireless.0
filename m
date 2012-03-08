Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752699Ab2CHNzl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 08:55:41 -0500
Date: Thu, 8 Mar 2012 14:55:30 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Don Fry <donald.h.fry@intel.com>
Subject: Re: [PATCH RESEND 34/35] iwlwifi: correct status bit refactoring
 errors
Message-ID: <20120308135529.GA14445@redhat.com> (sfid-20120308_145545_354863_21A18601)
References: <1331142764-5750-1-git-send-email-wey-yi.w.guy@intel.com>
 <1331142764-5750-35-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1331142764-5750-35-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 07, 2012 at 09:52:43AM -0800, Wey-Yi Guy wrote:
> From: Don Fry <donald.h.fry@intel.com>
> 
> I missed a couple of status bits in my refactoring changes.  This
> fixes the ones I missed.
> 
> Signed-off-by: Don Fry <donald.h.fry@intel.com>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-agn-rx.c |    2 +-
>  drivers/net/wireless/iwlwifi/iwl-agn.c    |    8 ++++----
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
> index 3ad4333..cc0227c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
> @@ -628,7 +628,7 @@ static int iwlagn_rx_card_state_notif(struct iwl_priv *priv,
>  	struct iwl_rx_packet *pkt = rxb_addr(rxb);
>  	struct iwl_card_state_notif *card_state_notif = (void *)pkt->data;
>  	u32 flags = le32_to_cpu(card_state_notif->flags);
> -	unsigned long status = priv->shrd->status;
> +	unsigned long status = priv->status;
>  
>  	IWL_DEBUG_RF_KILL(priv, "Card state received: HW:%s SW:%s CT:%s\n",
>  			  (flags & HW_CARD_DISABLED) ? "Kill" : "On",
> diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
> index 3793dc4..28422c0 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-agn.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
> @@ -819,15 +819,15 @@ void iwl_down(struct iwl_priv *priv)
>  	iwl_trans_stop_device(trans(priv));
>  
>  	/* Clear out all status bits but a few that are stable across reset */
> -	priv->shrd->status &=
> -			test_bit(STATUS_RF_KILL_HW, &priv->status) <<
> +	priv->status &= test_bit(STATUS_RF_KILL_HW, &priv->status) <<
>  				STATUS_RF_KILL_HW |
>  			test_bit(STATUS_GEO_CONFIGURED, &priv->status) <<
>  				STATUS_GEO_CONFIGURED |
> -			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
> -				STATUS_FW_ERROR |
>  			test_bit(STATUS_EXIT_PENDING, &priv->status) <<
>  				STATUS_EXIT_PENDING;
> +	priv->shrd->status &=
> +			test_bit(STATUS_FW_ERROR, &priv->shrd->status) <<
> +				STATUS_FW_ERROR;

So we have now priv->shrd->status & priv->status, how do you prevent to
confuse them? Also I still do not understand at all what for this ->shrd stuff
is needed.

Stanislaw
