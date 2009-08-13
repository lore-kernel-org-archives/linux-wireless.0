Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:57945 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbZHMHcq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2009 03:32:46 -0400
Date: Thu, 13 Aug 2009 09:31:22 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 2.6.30] iwl3945: fix rfkill switch
Message-ID: <20090813073122.GB2373@dhcp-lab-161.englab.brq.redhat.com>
References: <1249389350-4158-1-git-send-email-sgruszka@redhat.com> <1249512709.30019.4902.camel@rc-desk> <20090806071902.GA9816@dhcp-lab-161.englab.brq.redhat.com> <1249589758.30019.5034.camel@rc-desk> <20090807063141.GA2523@dhcp-lab-161.englab.brq.redhat.com> <1249922692.30019.5610.camel@rc-desk> <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090811140908.GA3235@dhcp-lab-161.englab.brq.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 11, 2009 at 04:09:08PM +0200, Stanislaw Gruszka wrote:
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> index d6b6098..636c04a 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> @@ -35,6 +35,19 @@
>  #include "iwl-dev.h"
>  #include "iwl-core.h"
>  
> +static void iwl_force_rfkill_state(struct iwl_priv *priv,
> +				   enum rfkill_state state)
> +{
> +	enum rfkill_state oldstate;
> +
> +	oldstate = priv->rfkill->state;
> +	priv->rfkill->state = state;
> +
> +	/* rfkill_uevent() */
> +	if (oldstate != state)
> +		kobject_uevent(&priv->rfkill->dev.kobj, KOBJ_CHANGE);

This is not needed because rfkill_toggle_radio() will send
rfkill_uevent().
  
> +}
> +
>  /* software rf-kill from user */
>  static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  {
> @@ -54,8 +67,9 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  	case RFKILL_STATE_UNBLOCKED:
>  		if (iwl_is_rfkill_hw(priv)) {
>  			err = -EBUSY;
> -			/* pass error to rfkill core to make it state HARD
> +			/* pass error to rfkill core, make it state HARD
>  			 * BLOCKED and disable software kill switch */
> +			iwl_force_rfkill_state(priv, RFKILL_STATE_HARD_BLOCKED);
>  		}
>  		iwl_radio_kill_sw_enable_radio(priv);
>  		break;
> @@ -63,10 +77,10 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  		iwl_radio_kill_sw_disable_radio(priv);
>  		/* rfkill->mutex lock is taken */
>  		if (priv->rfkill->state == RFKILL_STATE_HARD_BLOCKED) {
> -			/* force rfkill core state to be SOFT BLOCKED,
> +			/* force rfkill core state to be in SOFT BLOCKED,
>  			 * otherwise core will be unable to disable software
>  			 * kill switch */
> -			priv->rfkill->state = RFKILL_STATE_SOFT_BLOCKED;
> +			iwl_force_rfkill_state(priv, RFKILL_STATE_SOFT_BLOCKED);
>  		}
>  		break;

Stanislaw
