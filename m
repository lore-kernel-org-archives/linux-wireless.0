Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:43019 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbaBYXjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 18:39:14 -0500
Received: by mail-pd0-f177.google.com with SMTP id g10so126090pdj.22
        for <linux-wireless@vger.kernel.org>; Tue, 25 Feb 2014 15:39:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1393356639-19169-11-git-send-email-arend@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com> <1393356639-19169-11-git-send-email-arend@broadcom.com>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Tue, 25 Feb 2014 15:38:33 -0800
Message-ID: <CAGVrzcaNp6j4pN5d7LaWaFi0xexbvDzgwt-csEUw3tBfUwpXZQ@mail.gmail.com> (sfid-20140226_003925_975734_7BB1704A)
Subject: Re: [PATCH 10/14] brcmfmac: Use atomic functions for intstatus update.
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

2014-02-25 11:30 GMT-08:00 Arend van Spriel <arend@broadcom.com>:
> From: Hante Meuleman <meuleman@broadcom.com>
>
> The intstatus in sdio code can be updated from different
> threads. To protect intstatus access, atomic functions are
> used. One of them is set_bit, but this function is not
> guaranteed atomic on all platforms. The loop was replaced
> with local created OR function.
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   29 ++++++++++----------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> index ac61419..90ff406 100644
> --- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> +++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
> @@ -2444,12 +2444,21 @@ static inline void brcmf_sdio_clrintr(struct brcmf_sdio *bus)
>         }
>  }
>
> +static void atomic_orr(int val, atomic_t *v)
> +{
> +       int old_val;
> +
> +       old_val = atomic_read(v);
> +       while (atomic_cmpxchg(v, old_val, val | old_val) != old_val)
> +               old_val = atomic_read(v);
> +}

Is not atomic_set_mask() doing the same thing?

> +
>  static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
>  {
>         struct brcmf_core *buscore;
>         u32 addr;
>         unsigned long val;
> -       int n, ret;
> +       int ret;
>
>         buscore = brcmf_chip_get_core(bus->ci, BCMA_CORE_SDIO_DEV);
>         addr = buscore->base + offsetof(struct sdpcmd_regs, intstatus);
> @@ -2457,7 +2466,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
>         val = brcmf_sdiod_regrl(bus->sdiodev, addr, &ret);
>         bus->sdcnt.f1regdata++;
>         if (ret != 0)
> -               val = 0;
> +               return ret;
>
>         val &= bus->hostintmask;
>         atomic_set(&bus->fcstate, !!(val & I_HMB_FC_STATE));
> @@ -2466,13 +2475,7 @@ static int brcmf_sdio_intr_rstatus(struct brcmf_sdio *bus)
>         if (val) {
>                 brcmf_sdiod_regwl(bus->sdiodev, addr, val, &ret);
>                 bus->sdcnt.f1regdata++;
> -       }
> -
> -       if (ret) {
> -               atomic_set(&bus->intstatus, 0);
> -       } else if (val) {
> -               for_each_set_bit(n, &val, 32)
> -                       set_bit(n, (unsigned long *)&bus->intstatus.counter);
> +               atomic_orr(val, &bus->intstatus);
>         }
>
>         return ret;
> @@ -2484,7 +2487,7 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
>         unsigned long intstatus;
>         uint txlimit = bus->txbound;    /* Tx frames to send before resched */
>         uint framecnt;                  /* Temporary counter of tx/rx frames */
> -       int err = 0, n;
> +       int err = 0;
>
>         brcmf_dbg(TRACE, "Enter\n");
>
> @@ -2588,10 +2591,8 @@ static void brcmf_sdio_dpc(struct brcmf_sdio *bus)
>         }
>
>         /* Keep still-pending events for next scheduling */
> -       if (intstatus) {
> -               for_each_set_bit(n, &intstatus, 32)
> -                       set_bit(n, (unsigned long *)&bus->intstatus.counter);
> -       }
> +       if (intstatus)
> +               atomic_orr(intstatus, &bus->intstatus);
>
>         brcmf_sdio_clrintr(bus);
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Florian
