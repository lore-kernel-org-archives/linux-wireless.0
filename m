Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56783 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbcAPL5K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2016 06:57:10 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: David Miller <davem@davemloft.net>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20160112.215136.850414372508130298.davem@davemloft.net>
	<56978094.4050302@arm.com>
Date: Sat, 16 Jan 2016 13:57:01 +0200
In-Reply-To: <56978094.4050302@arm.com> (Marc Zyngier's message of "Thu, 14
	Jan 2016 11:03:48 +0000")
Message-ID: <87k2n97n5e.fsf@kamboji.qca.qualcomm.com> (sfid-20160116_125819_079567_FAF54D22)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marc Zyngier <marc.zyngier@arm.com> writes:

> David, Hante,
>
> On 13/01/16 02:51, David Miller wrote:
>
> [...]
>
>> Hante Meuleman (33):
> [...]
>>       brcmfmac: Move all module parameters to one place

As a reminder to myself this is the commit id:

7d34b0560567 brcmfmac: Move all module parameters to one place

> This particular patch breaks one of my boxes in a spectacular way:
>
> [    3.602155] Unable to handle kernel paging request at virtual address 000027e4
> [    3.602160] pgd = c0003000
> [    3.602169] [000027e4] *pgd=80000040004003, *pmd=00000000
> [    3.602181] Internal error: Oops: 206 [#1] PREEMPT SMP ARM

[...]

> This is caused by this hunk:
>
> @@ -890,7 +887,8 @@ static void brcmf_sdiod_sgtable_alloc(struct brcmf_sdio_dev *sdiodev)
>  	if (!sdiodev->sg_support)
>  		return;
>  
> -	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE, brcmf_sdiod_txglomsz);
> +	nents = max_t(uint, BRCMF_DEFAULT_RXGLOM_SIZE,
> +		      sdiodev->bus_if->drvr->settings->sdiod_txglomsz);
>  	nents += (nents >> 4) + 1;
>  
>  	WARN_ON(nents > sdiodev->max_segment_count);
>
> were drvr->settings is NULL (as the settings allocation seems to be done
> much later). The fix is not completely obvious to me (probably requires
> pushing the call to brcmf_mp_device_attach() down into the various bus
> specific functions). An alternative would be to restore the txglomsz
> parameter as it was before and not rely on settings being allocated.

Should we revert the patch or can you Hante fix this? The revert doesn't
seem to be trivial so I would appreciate if someone could send a patch.

-- 
Kalle Valo
