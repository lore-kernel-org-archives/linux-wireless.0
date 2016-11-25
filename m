Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61703 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754813AbcKYP2W (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Nov 2016 10:28:22 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 2/3] ath9k: export configurable parameters of PTA
Date: Fri, 25 Nov 2016 15:28:13 +0000
Message-ID: <87oa138tpv.fsf@kamboji.qca.qualcomm.com> (sfid-20161125_162825_761584_76ADC662)
References: <1479970402-13796-1-git-send-email-miaoqing@codeaurora.org>
        <1479970402-13796-2-git-send-email-miaoqing@codeaurora.org>
In-Reply-To: <1479970402-13796-2-git-send-email-miaoqing@codeaurora.org>
        (miaoqing@codeaurora.org's message of "Thu, 24 Nov 2016 14:53:21        +0800")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

miaoqing@codeaurora.org writes:

> From: Miaoqing Pan <miaoqing@codeaurora.org>
>
> Export time_extend, pritority_time, first_slot_time, wl_active_time
> and wl_qc_time those PTA(aka slotted mode) configurable parameters,
> allow user to change/debug the timing easily.
>
> Also set wl_active_time and wl_qc_time default value to 0, as in this
> period WLAN chip may send out ACK, and it will corrupt the BT(or other)
> received packet in the PTA cycle.
>
> Signed-off-by: Miaoqing Pan <miaoqing@codeaurora.org>

Please try to always write commit logs so that everyone will understand,
for example spelling out what PTA means would be nice.

> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -77,6 +77,26 @@ struct ath9k_eeprom_ctx {
>  static int ath9k_btcoex_duty_cycle =3D ATH_BTCOEX_DEF_DUTY_CYCLE;
>  module_param_named(btcoex_duty_cycle, ath9k_btcoex_duty_cycle, int, 0444=
);
>  MODULE_PARM_DESC(btcoex_duty_cycle, "BT coexistence duty cycle");
> +
> +static int ath9k_btcoex_time_extend;
> +module_param_named(btcoex_time_extend, ath9k_btcoex_time_extend, int, 04=
44);
> +MODULE_PARM_DESC(btcoex_time_extend, "BT coexistence time extend");
> +
> +static int ath9k_btcoex_priority_time =3D 2;
> +module_param_named(btcoex_priority_time, ath9k_btcoex_priority_time, int=
, 0444);
> +MODULE_PARM_DESC(btcoex_priority_time, "BT coexistence priority time");
> +
> +static int ath9k_btcoex_first_slot_time =3D 5;
> +module_param_named(btcoex_first_slot_time, ath9k_btcoex_first_slot_time,=
 int, 0444);
> +MODULE_PARM_DESC(btcoex_first_slot_time, "BT coexistence first slot time=
");
> +
> +static int ath9k_btcoex_wl_active_time;
> +module_param_named(btcoex_wl_active_time, ath9k_btcoex_wl_active_time, i=
nt, 0444);
> +MODULE_PARM_DESC(btcoex_wl_active_time, "BT coexistence wlan active time=
");
> +
> +static int ath9k_btcoex_wl_qc_time;
> +module_param_named(btcoex_wl_qc_time, ath9k_btcoex_wl_qc_time, int, 0444=
);
> +MODULE_PARM_DESC(btcoex_wl_qc_time, "BT coexistence wlan quiet collision=
 time");
>  #endif

Same as with the previous patch, I don't think these should be set via
module parameters.

--=20
Kalle Valo=
