Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:65325 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754244AbdKAKtv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 06:49:51 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 5/6] ath10k: add memory dump support for QCA6174/QCA9377
Date: Wed, 1 Nov 2017 10:49:46 +0000
Message-ID: <87wp3axohi.fsf@kamboji.qca.qualcomm.com> (sfid-20171101_114955_563645_3CF21714)
References: <150278532045.22482.14490702801292107536.stgit@potku.adurom.net>
        <150278542590.22482.1613614809483892010.stgit@potku.adurom.net>
In-Reply-To: <150278542590.22482.1613614809483892010.stgit@potku.adurom.net>
        (Kalle Valo's message of "Tue, 15 Aug 2017 11:23:46 +0300")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> From: Alan Liu <alanliu@qca.qualcomm.com>
>
> Add memory dump to the firmware crash data file which is provided to user=
 space
> via devcoredump interface. This makes it easier for firmware engineers to=
 debug
> firmware crashes.
>
> Due to increased memory consumption the memory dump is disabled by defaul=
t. To
> enable it make sure that bit 3 is set in coredump_mask module parameter:
>
> modprobe ath10k_core coredump_mask=3D0xffffffff
>
> When RAMDUMP is enabled a buffer for the dump is allocated with vmalloc d=
uring
> device probe. The actual memory layout is different in hardware versions =
and
> the layouts are defined in coredump.c. The memory is split to regions and=
, to
> get even finegrained control of what to copy, the region can split to sma=
ller
> sections as not all registers are readable (which could cause the whole s=
ystem
> to stall).
>
> Signed-off-by: Alan Liu <alanliu@qca.qualcomm.com>
> [kvalo@qca.qualcomm.com: refactoring and cleanup]
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

[...]

> +		/* To get IRAM dump, the host driver needs to switch target
> +		 * ram config from DRAM to IRAM.
> +		 */
> +		if (current_region->type =3D=3D ATH10K_MEM_REGION_TYPE_IRAM1 ||
> +		    current_region->type =3D=3D ATH10K_MEM_REGION_TYPE_IRAM2) {
> +			shift =3D current_region->start >> 20;
> +
> +			ret =3D ath10k_pci_set_ram_config(ar, shift);
> +			if (!ret) {
> +				ath10k_warn(ar, "failed to switch ram config to IRAM for section %s:=
 %d\n",
> +					    current_region->name, ret);

A colleague noticed that there's a bug here, it should be "if (ret)".
I'll fix that in the next version.

--=20
Kalle Valo=
