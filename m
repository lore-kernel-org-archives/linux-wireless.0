Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24984 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYGAJlq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 05:41:46 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Subject: RE: [PATCH 1/1] iwlwifi: fix error path of iwl_rfkill_init
Date: Tue, 1 Jul 2008 17:41:41 +0800
Message-ID: <8AD95083DC3E36478732061D97524415035E38AB@pdsmsx411.ccr.corp.intel.com> (sfid-20080701_114150_030677_F604C9EC)
In-Reply-To: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
From: "Zhu, Yi" <yi.zhu@intel.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>,
	<linville@tuxdriver.com>, <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, looks like you didn't merge the last patch "[PATCH 33/33] iwlwifi=
: remove the input device from rfkill_mngr" from me but merged an earli=
er patch from Adel directly. Tomas' this patch fixes the iwl-rfkill.c p=
art, but we should also remove the input layer for 3945. Do you want me=
 to submit another patch on top of the current tip or you can handle it=
 yourself.

http://marc.info/?l=3Dlinux-wireless&m=3D121481826531792&w=3D2

Thanks,
-yi

> -----Original Message-----
> From: Winkler, Tomas
> Sent: 2008=C4=EA7=D4=C21=C8=D5 15:45
> To: linville@tuxdriver.com; johannes@sipsolutions.net; Zhu, Yi
> Cc: linux-wireless@vger.kernel.org; Winkler, Tomas
> Subject: [PATCH 1/1] iwlwifi: fix error path of iwl_rfkill_init
>=20
> This patch cleans rfkill error path. The problem was result of removi=
ng
> the input device
>=20
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-rfkill.c |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> index aa9f31e..eebaf43 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-rfkill.c
> @@ -101,17 +101,13 @@ int iwl_rfkill_init(struct iwl_priv *priv)
>  	ret =3D rfkill_register(priv->rfkill_mngr.rfkill);
>  	if (ret) {
>  		IWL_ERROR("Unable to register rfkill: %d\n", ret);
> -		goto unregister_rfkill;
> +		goto free_rfkill;
>  	}
>=20
>  	IWL_DEBUG_RF_KILL("RFKILL initialization complete.\n");
>  	return ret;
>=20
> -unregister_rfkill:
> -	rfkill_unregister(priv->rfkill_mngr.rfkill);
> -	priv->rfkill_mngr.rfkill =3D NULL;
> -
> -freed_rfkill:
> +free_rfkill:
>  	if (priv->rfkill_mngr.rfkill !=3D NULL)
>  		rfkill_free(priv->rfkill_mngr.rfkill);
>  	priv->rfkill_mngr.rfkill =3D NULL;
> --
> 1.5.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
