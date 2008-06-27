Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.188]:33138 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759976AbYF0SHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 14:07:18 -0400
Received: by fk-out-0910.google.com with SMTP id 18so542639fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 27 Jun 2008 11:07:17 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wireless: remove RFKILL_STATE_HARD_BLOCKED warnings
Date: Fri, 27 Jun 2008 20:09:30 +0200
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
References: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806272009.30269.IvDoorn@gmail.com> (sfid-20080627_200744_245568_0BE5468B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 June 2008, John W. Linville wrote:
>   CC [M]  drivers/net/wireless/b43/rfkill.o
> drivers/net/wireless/b43/rfkill.c: In function =E2=80=98b43_rfkill_so=
ft_toggle=E2=80=99:
> drivers/net/wireless/b43/rfkill.c:90: warning: enumeration value =E2=80=
=98RFKILL_STATE_HARD_BLOCKED=E2=80=99 not handled in switch
>=20
>   CC [M]  drivers/net/wireless/b43legacy/rfkill.o
> drivers/net/wireless/b43legacy/rfkill.c: In function =E2=80=98b43lega=
cy_rfkill_soft_toggle=E2=80=99:
> drivers/net/wireless/b43legacy/rfkill.c:92: warning: enumeration valu=
e =E2=80=98RFKILL_STATE_HARD_BLOCKED=E2=80=99 not handled in switch
>=20
>   CC [M]  drivers/net/wireless/iwlwifi/iwl-rfkill.o
> drivers/net/wireless/iwlwifi/iwl-rfkill.c: In function =E2=80=98iwl_r=
fkill_soft_rf_kill=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-rfkill.c:56: warning: enumeration va=
lue =E2=80=98RFKILL_STATE_HARD_BLOCKED=E2=80=99 not handled in switch
>=20
> Also handle RFKILL_STATE_{ON,OFF} -> RFKILL_STATE_{UNBLOCKED,SOFT_BLO=
CKED}
> conversion since I'm already here...
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

=46or rt2x00 changes:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
>  drivers/net/wireless/b43/rfkill.c          |    7 +++++--
>  drivers/net/wireless/b43legacy/rfkill.c    |    8 ++++++--
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c  |    7 +++++--
>  drivers/net/wireless/rt2x00/rt2x00rfkill.c |    7 +++++--
>  4 files changed, 21 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless=
/b43/rfkill.c
> index 11f53cb..4cca203 100644
> --- a/drivers/net/wireless/b43/rfkill.c
> +++ b/drivers/net/wireless/b43/rfkill.c
> @@ -88,7 +88,7 @@ static int b43_rfkill_soft_toggle(void *data, enum =
rfkill_state state)
>  		goto out_unlock;
>  	err =3D 0;
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		if (!dev->radio_hw_enable) {
>  			/* No luck. We can't toggle the hardware RF-kill
>  			 * button from software. */
> @@ -98,10 +98,13 @@ static int b43_rfkill_soft_toggle(void *data, enu=
m rfkill_state state)
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
> diff --git a/drivers/net/wireless/b43legacy/rfkill.c b/drivers/net/wi=
reless/b43legacy/rfkill.c
> index d178dfb..8935a30 100644
> --- a/drivers/net/wireless/b43legacy/rfkill.c
> +++ b/drivers/net/wireless/b43legacy/rfkill.c
> @@ -90,7 +90,7 @@ static int b43legacy_rfkill_soft_toggle(void *data,=
 enum rfkill_state state)
>  		goto out_unlock;
>  	err =3D 0;
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		if (!dev->radio_hw_enable) {
>  			/* No luck. We can't toggle the hardware RF-kill
>  			 * button from software. */
> @@ -100,10 +100,14 @@ static int b43legacy_rfkill_soft_toggle(void *d=
ata, enum rfkill_state state)
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
> =20
>  out_unlock:
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c b/drivers/net/=
wireless/iwlwifi/iwl-rfkill.c
> index 4624ac7..ffefbb4 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> @@ -54,17 +54,20 @@ static int iwl_rfkill_soft_rf_kill(void *data, en=
um rfkill_state state)
>  	mutex_lock(&priv->mutex);
> =20
>  	switch (state) {
> -	case RFKILL_STATE_ON:
> +	case RFKILL_STATE_UNBLOCKED:
>  		iwl_radio_kill_sw_enable_radio(priv);
>  		/* if HW rf-kill is set dont allow ON state */
>  		if (iwl_is_rfkill(priv))
>  			err =3D -EBUSY;
>  		break;
> -	case RFKILL_STATE_OFF:
> +	case RFKILL_STATE_SOFT_BLOCKED:
>  		iwl_radio_kill_sw_disable_radio(priv);
>  		if (!iwl_is_rfkill(priv))
>  			err =3D -EBUSY;
>  		break;
> +	default:
> +		IWL_WARNING("we recieved unexpected RFKILL state %d\n", state);
> +		break;
>  	}
>  	mutex_unlock(&priv->mutex);
> =20
> diff --git a/drivers/net/wireless/rt2x00/rt2x00rfkill.c b/drivers/net=
/wireless/rt2x00/rt2x00rfkill.c
> index fcef988..207281c 100644
> --- a/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> +++ b/drivers/net/wireless/rt2x00/rt2x00rfkill.c
> @@ -45,14 +45,17 @@ static int rt2x00rfkill_toggle_radio(void *data, =
enum rfkill_state state)
>  	if (!test_bit(DEVICE_STARTED, &rt2x00dev->flags))
>  		return 0;
> =20
> -	if (state =3D=3D RFKILL_STATE_ON) {
> +	if (state =3D=3D RFKILL_STATE_UNBLOCKED) {
>  		INFO(rt2x00dev, "Hardware button pressed, enabling radio.\n");
>  		__clear_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
>  		retval =3D rt2x00lib_enable_radio(rt2x00dev);
> -	} else if (state =3D=3D RFKILL_STATE_OFF) {
> +	} else if (state =3D=3D RFKILL_STATE_SOFT_BLOCKED) {
>  		INFO(rt2x00dev, "Hardware button pressed, disabling radio.\n");
>  		__set_bit(DEVICE_DISABLED_RADIO_HW, &rt2x00dev->flags);
>  		rt2x00lib_disable_radio(rt2x00dev);
> +	} else {
> +		WARNING(rt2x00dev, "Received unexpected rfkill state %d.\n",
> +			state);
>  	}
> =20
>  	return retval;


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
