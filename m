Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:18996 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbbGISZ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 14:25:28 -0400
Message-ID: <559EBC91.2070600@broadcom.com> (sfid-20150709_202602_849280_18832B04)
Date: Thu, 9 Jul 2015 20:25:21 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>, Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	Brett Rudley <brudley@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	Daniel Kim <dekim@broadcom.com>,
	<linux-wireless@vger.kernel.org>,
	<brcm80211-dev-list@broadcom.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/3] brcmfmac: dhd_sdio.c: use existing atomic_or primitive
References: <1436429599-10762-1-git-send-email-vgupta@synopsys.com> <1436429599-10762-3-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1436429599-10762-3-git-send-email-vgupta@synopsys.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/09/2015 10:13 AM, Vineet Gupta wrote:
> There's already a generic implementation so use that instead.

There is or there was? If there is now I am fine with this patch, but if 
it already was there the author might have had a reason for adding a 
local function and I would like to hear that reason.

> ---
> I'm not sure if the driver usage of atomic_or?() is correct in terms of
> storage size of @val for 64 bit arches.
>
> Assuming LP64 programming model for linux on say x86_64: atomic_or()
> callers in this driver use long (sana 64 bit) storage and pass it to
> atomic_orr/atomic_or which downcasts it to 32 bits. Is that OK ?

The function is used with 32bit register value from the device so I 
think it is ok.

Regards,
Arend

> ---
> Cc: Brett Rudley <brudley@broadcom.com>
> Cc: Arend van Spriel <arend@broadcom.com>
> Cc: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>
> Cc: Hante Meuleman <meuleman@broadcom.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Cc: Daniel Kim <dekim@broadcom.com>
> Cc: linux-wireless@vger.kernel.org
> Cc: brcm80211-dev-list@broadcom.com
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: netdev@vger.kernel.org
> Cc: linux-arch@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
>
> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> ---
>   drivers/net/wireless/brcm80211/brcmfmac/sdio.c | 13 ++-----------
>   1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> index d36f5f3d931b..f990e3d0e696 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/sdio.c
> @@ -2564,15 +2564,6 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
>   	}
>   }
>
> -static void atomic_orr(int val, atomic_t *v)
> -{
> -	int old_val;
> -
> -	old_val = atomic_read(v);
> -	while (atomic_cmpxchg(v, old_val, val | old_val) != old_val)
> -		old_val = atomic_read(v);
> -}
> -
>   static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
>   {
>   	struct brcmf_core *buscore;
> @@ -2595,7 +2586,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
>   	if (val) {
>   		brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
>   		bus->sdcnt.f1regdata++;
> -		atomic_orr(val, &bus->intstatus);
> +		atomic_or(val, &bus->intstatus);
>   	}
>
>   	return ret;
> @@ -2712,7 +2703,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
>
>   	/* Keep still-pending events for next scheduling */
>   	if (intstatus)
> -		atomic_orr(intstatus, &bus->intstatus);
> +		atomic_or(intstatus, &bus->intstatus);
>
>   	brcmf_sdio_clrintr(bus);
>
>

