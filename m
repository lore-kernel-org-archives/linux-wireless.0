Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42960 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932960AbcILPjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Sep 2016 11:39:07 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "bartosz.markowski@tieto.com" <bartosz.markowski@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: add platform regulatory domain support
Date: Mon, 12 Sep 2016 15:35:30 +0000
Message-ID: <87bmztm8qm.fsf@kamboji.qca.qualcomm.com> (sfid-20160912_173918_362878_5989B932)
References: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
        <1470140454-3899-3-git-send-email-bartosz.markowski@tieto.com>
In-Reply-To: <1470140454-3899-3-git-send-email-bartosz.markowski@tieto.com>
        (Bartosz Markowski's message of "Tue, 2 Aug 2016 14:20:54 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> This overrides whatever regulatory the device
> EEPROM contains and uses what the platform says
> instead - in this implementation the ACPI driver.
>
> In case the hint is not programmed or corrupted (0xffff)
> the device falls back to the eeprom programmed settings.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

> +#ifdef CONFIG_ACPI
> +#define WRD_METHOD "WRDD"
> +#define WRDD_WIFI  (0x07)
> +
> +static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_object =
*wrdd)
> +{

I don't think the ifdef is really necessary, acpi.h should handle that
(hopefully). Also I changed the error handling to use standard error
values and changed the info messages to dbg, they are too spammy in my
opinion. Please check carefully my changes in the pending branch:

https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=3Dpend=
ing&id=3Dfe91745381ec3999d8de6dedb07b396c82539717

--=20
Kalle Valo=
