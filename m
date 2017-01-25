Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59065 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbdAYN3r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Jan 2017 08:29:47 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware
 fails
Date: Wed, 25 Jan 2017 13:29:41 +0000
Message-ID: <8760l38dz0.fsf@kamboji.qca.qualcomm.com> (sfid-20170125_142951_389160_069C1859)
References: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
        (Mohammed Shafi Shajakhan's message of "Tue, 20 Dec 2016 13:39:11       +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com> writes:

> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
>
> This fixes the below crash when ath10k probe firmware fails,
> NAPI polling tries to access a rx ring resource which was never
> allocated, fix this by disabling NAPI right away once the probe
> firmware fails by calling 'ath10k_hif_stop'. Its good to note
> that the error is never propogated to 'ath10k_pci_probe' when
> ath10k_core_register fails, so calling 'ath10k_hif_stop' to cleanup
> PCI related things seems to be ok
>
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP:  __ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]
> __ath10k_htt_rx_ring_fill_n+0x19/0x230 [ath10k_core]
>
> Call Trace:
>
> [<ffffffffa113ec62>] ath10k_htt_rx_msdu_buff_replenish+0x42/0x90
> [ath10k_core]
> [<ffffffffa113f393>] ath10k_htt_txrx_compl_task+0x433/0x17d0
> [ath10k_core]
> [<ffffffff8114406d>] ? __wake_up_common+0x4d/0x80
> [<ffffffff811349ec>] ? cpu_load_update+0xdc/0x150
> [<ffffffffa119301d>] ? ath10k_pci_read32+0xd/0x10 [ath10k_pci]
> [<ffffffffa1195b17>] ath10k_pci_napi_poll+0x47/0x110 [ath10k_pci]
> [<ffffffff817863af>] net_rx_action+0x20f/0x370
>
> Reported-by: Ben Greear <greearb@candelatech.com>
> Fixes: 3c97f5de1f28 ("ath10k: implement NAPI support")
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Is there an easy way to reproduce this bug? I don't see it on my x86
laptop with qca988x and I call rmmod all the time. I would like to test
this myself.

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -2164,6 +2164,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
>  	ath10k_core_free_firmware_files(ar);
> =20
>  err_power_down:
> +	ath10k_hif_stop(ar);
>  	ath10k_hif_power_down(ar);
> =20
>  	return ret;

This breaks the symmetry, we should not be calling ath10k_hif_stop() if
we haven't called ath10k_hif_start() from the same function. This can
just create a bigger mess later, for example with other bus support like
sdio or usb. In theory it should enough that we call
ath10k_hif_power_down() and pci.c does the rest correctly "behind the
scenes".

I investigated this a bit and I think the real cause is that we call
napi_enable() from ath10k_pci_hif_power_up() and napi_disable() from
ath10k_pci_hif_stop(). Does anyone remember why?

I was expecting that we would call napi_enable()/napi_disable() either
in ath10k_hif_power_up/down() or ath10k_hif_start()/stop(), but not
mixed like it's currently.

--=20
Kalle Valo=
