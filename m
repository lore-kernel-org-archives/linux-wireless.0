Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 29.mail-out.ovh.net ([87.98.216.213]:50267 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754791AbYLEPZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2008 10:25:07 -0500
Date: Fri, 5 Dec 2008 16:20:58 +0100
From: Samuel Ortiz <samuel@sortiz.org>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	tomasw@gmail.com, yi.zhu@intel.com
Subject: Re: [PATCH] iwl3945: remove obsolete irq handling
Message-ID: <20081205152058.GA4590@sortiz.org> (sfid-20081205_162512_677509_9E6C31ED)
Reply-To: Samuel Ortiz <samuel@sortiz.org>
References: <200812011653.29150.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812011653.29150.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 01, 2008 at 04:53:28PM +0100, Helmut Schaa wrote:
> 3945 hardware does not emit the interrupts CSR_INT_BIT_RF_KILL (rfkill
> toggled) and CSR_INT_BIT_CT_KILL (adapter too hot). Hence this part of code
> can be removed since iwl3945_irq_tasklet does not handle 4965 hw at all.
That's correct.


> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Samuel Ortiz <samuel.ortiz@intel.com>

> ---
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 490bc4a..b32b507 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -4321,35 +4321,6 @@ static void iwl3945_irq_tasklet(struct iwl3945_priv *priv)
>  	/* Safely ignore these bits for debug checks below */
>  	inta &= ~(CSR_INT_BIT_SCD | CSR_INT_BIT_ALIVE);
>  
> -	/* HW RF KILL switch toggled (4965 only) */
> -	if (inta & CSR_INT_BIT_RF_KILL) {
> -		int hw_rf_kill = 0;
> -		if (!(iwl3945_read32(priv, CSR_GP_CNTRL) &
> -				CSR_GP_CNTRL_REG_FLAG_HW_RF_KILL_SW))
> -			hw_rf_kill = 1;
> -
> -		IWL_DEBUG(IWL_DL_INFO | IWL_DL_RF_KILL | IWL_DL_ISR,
> -				"RF_KILL bit toggled to %s.\n",
> -				hw_rf_kill ? "disable radio" : "enable radio");
> -
> -		/* Queue restart only if RF_KILL switch was set to "kill"
> -		 *   when we loaded driver, and is now set to "enable".
> -		 * After we're Alive, RF_KILL gets handled by
> -		 *   iwl3945_rx_card_state_notif() */
> -		if (!hw_rf_kill && !test_bit(STATUS_ALIVE, &priv->status)) {
> -			clear_bit(STATUS_RF_KILL_HW, &priv->status);
> -			queue_work(priv->workqueue, &priv->restart);
> -		}
> -
> -		handled |= CSR_INT_BIT_RF_KILL;
> -	}
> -
> -	/* Chip got too hot and stopped itself (4965 only) */
> -	if (inta & CSR_INT_BIT_CT_KILL) {
> -		IWL_ERROR("Microcode CT kill error detected.\n");
> -		handled |= CSR_INT_BIT_CT_KILL;
> -	}
> -
>  	/* Error detected by uCode */
>  	if (inta & CSR_INT_BIT_SW_ERR) {
>  		IWL_ERROR("Microcode SW error detected.  Restarting 0x%X.\n",
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
