Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43598 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040AbYF0Pex (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:34:53 -0400
Date: Fri, 27 Jun 2008 12:34:47 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <IvDoorn@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: Re: [PATCH] wireless: remove RFKILL_STATE_HARD_BLOCKED warnings
Message-ID: <20080627153447.GA24702@khazad-dum.debian.net> (sfid-20080627_173525_937228_7A678715)
References: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Jun 2008, John W. Linville wrote:
>   CC [M]  drivers/net/wireless/b43/rfkill.o
> drivers/net/wireless/b43/rfkill.c: In function ???b43_rfkill_soft_toggle???:
> drivers/net/wireless/b43/rfkill.c:90: warning: enumeration value ???RFKILL_STATE_HARD_BLOCKED??? not handled in switch
> 
>   CC [M]  drivers/net/wireless/b43legacy/rfkill.o
> drivers/net/wireless/b43legacy/rfkill.c: In function ???b43legacy_rfkill_soft_toggle???:
> drivers/net/wireless/b43legacy/rfkill.c:92: warning: enumeration value ???RFKILL_STATE_HARD_BLOCKED??? not handled in switch
> 
>   CC [M]  drivers/net/wireless/iwlwifi/iwl-rfkill.o
> drivers/net/wireless/iwlwifi/iwl-rfkill.c: In function ???iwl_rfkill_soft_rf_kill???:
> drivers/net/wireless/iwlwifi/iwl-rfkill.c:56: warning: enumeration value ???RFKILL_STATE_HARD_BLOCKED??? not handled in switch
> 
> Also handle RFKILL_STATE_{ON,OFF} -> RFKILL_STATE_{UNBLOCKED,SOFT_BLOCKED}
> conversion since I'm already here...
> 
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Acked-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

> ---
>  drivers/net/wireless/b43/rfkill.c          |    7 +++++--
>  drivers/net/wireless/b43legacy/rfkill.c    |    8 ++++++--
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c  |    7 +++++--
>  drivers/net/wireless/rt2x00/rt2x00rfkill.c |    7 +++++--
>  4 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
> index 11f53cb..4cca203 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -88,7 +88,7 @@ static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
>  		goto out_unlock;
>  	err = 0;
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		if (!dev->radio_hw_enable) {
>  			/* No luck. We can't toggle the hardware RF-kill
>  			 * button from software. */
> @@ -98,10 +98,13 @@ static int b43_rfkill_soft_toggle(void *data, enum rfkill_state state)
>  		if (!dev->phy.radio_on)
>  			b43_radio_turn_on(dev);
>  		break;
> -	case RFKILL_STATE_OFF:
> +	case RFKILL_STATE_SOFT_BLOCKED:
>  		if (dev->phy.radio_on)
>  			b43_radio_turn_off(dev, 0);
>  		break;
> +	default:
> +		b43warn(wl, "Received unexpected rfkill state %d.\n", state);
> +		break;
>  	}
>  out_unlock:
>  	mutex_unlock(&wl->mutex);
> diff --git a/drivers/net/wireless/b43legacy/rfkill.c b/drivers/net/wireless/b43legacy/rfkill.c
> index d178dfb..8935a30 100644
> --- a/drivers/net/wireless/b43legacy/rfkill.c
> +++ b/drivers/net/wireless/b43legacy/rfkill.c
> @@ -90,7 +90,7 @@ static int b43legacy_rfkill_soft_toggle(void *data, enum rfkill_state state)
>  		goto out_unlock;
>  	err = 0;
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		if (!dev->radio_hw_enable) {
>  			/* No luck. We can't toggle the hardware RF-kill
>  			 * button from software. */
> @@ -100,10 +100,14 @@ static int b43legacy_rfkill_soft_toggle(void *data, enum rfkill_state state)
>  		if (!dev->phy.radio_on)
>  			b43legacy_radio_turn_on(dev);
>  		break;
> -	case RFKILL_STATE_OFF:
> +	case RFKILL_STATE_SOFT_BLOCKED:
>  		if (dev->phy.radio_on)
>  			b43legacy_radio_turn_off(dev, 0);
>  		break;
> +	default:
> +		b43legacywarn(wl, "Received unexpected rfkill state %d.\n",
> +			      state);
> +		break;
>  	}
>  
>  out_unlock:
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> index 4624ac7..ffefbb4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> @@ -54,17 +54,20 @@ static int iwl_rfkill_soft_rf_kill(void *data, enum rfkill_state state)
>  	mutex_lock(&priv->mutex);
>  
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		iwl_radio_kill_sw_enable_radio(priv);
>  		/* if HW rf-kill is set dont allow ON state */
>  		if (iwl_is_rfkill(priv))
>  			err = -EBUSY;
>  		break;
> -	case RFKILL_STATE_OFF:
> +	case RFKILL_STATE_SOFT_BLOCKED:
>  		iwl_radio_kill_sw_disable_radio(priv);
>  		if (!iwl_is_rfkill(priv))
>  			err = -EBUSY;
>  		break;
> +	default:
> +		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
> +		break;
>  	}
>  	mutex_unlock(&priv->mutex);
>  
> diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> index fcef988..207281c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> @@ -45,14 +45,17 @@ static int rt2x00rfkill_toggle_radio(void *data, enum rfkill_state state)
>  	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
>  		return 0;
>  
> -	if (state == RFKILL_STATE_ON) {
> +	if (state == RFKILL_STATE_UNBLOCKED) {
>  		INFO(rt2x00dev, "Hardware button pressed, enabling radio.\n");
>  		__clear_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
>  		retval = rt2x00lib_enable_radio(rt2x00dev);
> -	} else if (state == RFKILL_STATE_OFF) {
> +	} else if (state == RFKILL_STATE_SOFT_BLOCKED) {
>  		INFO(rt2x00dev, "Hardware button pressed, disabling radio.\n");
>  		__set_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
>  		rt2x00lib_disable_radio(rt2x00dev);
> +	} else {
> +		WARNING(rt2x00dev, "Received unexpected rfkill state %d.\n",
> +			state);
>  	}
>  
>  	return retval;

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
