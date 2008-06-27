Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:55025 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbYF0Pnf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Jun 2008 11:43:35 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wireless: remove RFKILL_STATE_HARD_BLOCKED warnings
Date: Fri, 27 Jun 2008 17:42:58 +0200
Cc: linux-wireless@vger.kernel.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
References: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1214579554-14581-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200806271742.58833.mb@bu3sch.de> (sfid-20080627_174338_211904_824849C8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 27 June 2008 17:12:34 John W. Linville wrote:
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

ACK for b43 and b43legacy changes.

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

"recieved" typo.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
