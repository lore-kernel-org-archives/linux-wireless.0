Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756258AbeAIH3U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Jan 2018 02:29:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: AceLan Kao <acelan.kao@canonical.com>, Larry.Finger@lwfinger.net
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k: add a quirk to set use_msi automatically
References: <1515461962-27129-1-git-send-email-acelan.kao@canonical.com>
Date: Tue, 09 Jan 2018 09:29:14 +0200
In-Reply-To: <1515461962-27129-1-git-send-email-acelan.kao@canonical.com>
        (AceLan Kao's message of "Tue, 9 Jan 2018 09:39:22 +0800")
Message-ID: <877esr32yd.fsf@kamboji.qca.qualcomm.com> (sfid-20180109_082939_282729_A2CC6664)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AceLan Kao <acelan.kao@canonical.com> writes:

> Some platform(BIOS) blocks legacy interrupts (INTx), and only allows MSI
> for WLAN device. So adding a quirk to list those machines and set
> use_msi automatically.
> Adding the following platforms to the quirk.
>    Dell Inspiron 24-3460
>    Dell Inspiron 3472
>    Dell Inspiron 14-3473
>    Dell Vostro 3262
>    Dell Vostro 15-3572
>
> Signed-off-by: AceLan Kao <acelan.kao@canonical.com>

[...]

> @@ -96,6 +97,56 @@ static const struct ieee80211_tpt_blink ath9k_tpt_blink[] = {
>  };
>  #endif
>  
> +static int __init set_use_msi(const struct dmi_system_id *dmi)
> +{
> +	ath9k_use_msi = 1;
> +	return 1;
> +}
> +
> +static const struct dmi_system_id ath9k_quirks[] __initconst = {
> +	{
> +		.callback = set_use_msi,
> +		.ident = "Dell Inspiron 24-3460",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 24-3460"),
> +		},
> +	},

Larry, didn't rtlwifi have similar situation that with certain laptops
users were required to enable a module parameter to get the device
working? I think rtlwifi should do the same as AceLan does here as then
the user would not need to manually set the module parameter.

-- 
Kalle Valo
