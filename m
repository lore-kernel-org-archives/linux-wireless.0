Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36607 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755117AbcKYPZx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 10:25:53 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 1/3] ath9k: Add a module parameter to set btcoex duty
 cycle
Date: Fri, 25 Nov 2016 15:25:48 +0000
Message-ID: <87shqf8ttw.fsf@kamboji.qca.qualcomm.com> (sfid-20161125_162557_986474_858B48F5)
References: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
        (miaoqing@codeaurora.org's message of "Thu, 24 Nov 2016 14:53:20        +0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> btcoex duty cyle allows user to balance the performance
> between WLAN and BT.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

[...]

> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -73,6 +73,12 @@ struct ath9k_eeprom_ctx {
> =20
>  #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
> =20
> +#ifdef CONFIG_ATH9K_BTCOEX_SUPPORT
> +static int ath9k_btcoex_duty_cycle =3D ATH_BTCOEX_DEF_DUTY_CYCLE;
> +module_param_named(btcoex_duty_cycle, ath9k_btcoex_duty_cycle, int, 0444=
);
> +MODULE_PARM_DESC(btcoex_duty_cycle, "BT coexistence duty cycle");
> +#endif

I don't think module parameters are really meant for providing protocol
settings like this, especially as these would be global for all radios.
nl80211 (if used in production) or debugfs (if used only in testing) are
much better choises.

--=20
Kalle Valo=
