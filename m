Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:58573 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752349AbZALVdo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2009 16:33:44 -0500
Subject: Re: [PATCH] iwl3945: fix
	=?UTF-8?Q?=22=E2=80=98power=5Fidx=E2=80=99?= may be used uninitialized"
	warning
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1231789741-13433-4-git-send-email-linville@tuxdriver.com>
References: <> <1231789741-13433-1-git-send-email-linville@tuxdriver.com>
	 <1231789741-13433-2-git-send-email-linville@tuxdriver.com>
	 <1231789741-13433-3-git-send-email-linville@tuxdriver.com>
	 <1231789741-13433-4-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 12 Jan 2009 13:35:38 -0800
Message-Id: <1231796138.27071.34.camel@rc-desk> (sfid-20090112_223348_947973_3CA648F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-01-12 at 11:49 -0800, John W. Linville wrote:
> drivers/net/wireless/iwlwifi/iwl-3945.c: In function =E2=80=98iwl3945=
_txpower_set_from_eeprom=E2=80=99:
> drivers/net/wireless/iwlwifi/iwl-3945.c:2222: warning: =E2=80=98power=
_idx=E2=80=99 may be used uninitialized in this function
>=20
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-3945.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wi=
reless/iwlwifi/iwl-3945.c
> index 8fdb342..45cfa1c 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-3945.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
> @@ -2219,7 +2219,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl3=
945_priv *priv)
>  		/* set tx power value for all OFDM rates */
>  		for (rate_index =3D 0; rate_index < IWL_OFDM_RATES;
>  		     rate_index++) {
> -			s32 power_idx;
> +			s32 uninitialized_var(power_idx);
>  			int rc;
> =20
>  			/* use channel group's clip-power table,

Thank you very much

Acked-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
