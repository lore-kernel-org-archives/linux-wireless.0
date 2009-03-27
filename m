Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:50477 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764898AbZC0Xvb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 19:51:31 -0400
Received: by fk-out-0910.google.com with SMTP id 18so542419fkq.5
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2009 16:51:28 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH] iwlwifi: change check triggering device restart after rfkill change
Date: Sat, 28 Mar 2009 00:51:19 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net
References: <1238183130-31461-1-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1238183130-31461-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903280051.20450.helmut.schaa@gmail.com> (sfid-20090328_005140_794496_6FD1F2E5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 27. M=E4rz 2009 schrieb Reinette Chatre:
> The STATUS_ALIVE value cannot be used because it is cleared when
> interface is brought down and will not be set if rfkill is enabled wh=
en
> interface is started again. The interface can thus not be brought up =
if
> rfkill was enabled before stopping the interface and disabled after
> starting the interface.
>=20
> Change the test to use priv->is_open instead, this will be set when
> interface is started whether rfkill is enabled or not.
>=20
> Thanks to Helmut Schaa for the suggested fix.
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> CC: Helmut Schaa <helmut.schaa@googlemail.com>

Acked-by: Helmut Schaa <helmut.schaa@googlemail.com>

Looks good to me. Thanks Reinette.

> ---
>  drivers/net/wireless/iwlwifi/iwl-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wi=
reless/iwlwifi/iwl-core.c
> index 18ef713..970c4fd 100644
> --- a/drivers/net/wireless/iwlwifi/iwl-core.c
> +++ b/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -2058,7 +2058,7 @@ void iwl_bg_rf_kill(struct work_struct *work)
>  			  "HW and/or SW RF Kill no longer active, restarting "
>  			  "device\n");
>  		if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
> -		    test_bit(STATUS_ALIVE, &priv->status))
> +		    priv->is_open)
>  			queue_work(priv->workqueue, &priv->restart);
>  	} else {
>  		/* make sure mac80211 stop sending Tx frame */


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
