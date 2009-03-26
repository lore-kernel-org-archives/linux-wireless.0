Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:37285 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbZCZRuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 13:50:21 -0400
Received: by fg-out-1718.google.com with SMTP id e12so256045fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 10:50:18 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Thu, 26 Mar 2009 18:50:08 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wey-Yi Guy" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <1238087650-26993-2-git-send-email-reinette.chatre@intel.com> <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903261850.09869.helmut.schaa@gmail.com> (sfid-20090326_185025_458179_8263BE62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Am Donnerstag, 26. M=E4rz 2009 schrieb Reinette Chatre:
> From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>=20
> Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit get
> clear in __iwl_down() function; the additional checking will fail and
> cause RF can not be turn back on.

Are you sure this is needed? I'd argue we should only restart the adapt=
er
if it was alive when it got rf_killed. In case the adapter was rf_kille=
d
while the interface was down I don't think we want to restart the adapt=
er
immediately but first when the interface is taken up again.

Helmut

> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wi=
reless/iwlwifi/iwl-core.c
> index e1b5472..7560d6f 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -2056,8 +2056,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
>  		IWL_DEBUG_RF_KILL(priv,
>  			  "HW and/or SW RF Kill no longer active, restarting "
>  			  "device\n");
> -		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
> -		    test_bit(STATUS_ALIVE, &priv->status))
> +		if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>  			queue_work(priv->workqueue, &priv->restart);
>  	} else {
>  		/* make sure mac80211 stop sending Tx frame */


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
