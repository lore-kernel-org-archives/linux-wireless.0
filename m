Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:40819 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932404AbeE2JXC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:23:02 -0400
Received: by mail-qt0-f193.google.com with SMTP id h2-v6so17755114qtp.7
        for <linux-wireless@vger.kernel.org>; Tue, 29 May 2018 02:23:02 -0700 (PDT)
Subject: Re: [PATCH] brcmfmac: stop watchdog before detach and free everything
To: Michael Nazzareno Trimarchi <michael@amarulasolutions.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
References: <1527493857-2220-1-git-send-email-michael@amarulasolutions.com>
 <5B0BD13D.8000809@broadcom.com>
 <CAOf5uw=mPOgngZW8UcPfvtxH+5nCR-36ovjYPH7AvO99y1M_xA@mail.gmail.com>
 <CAHp75VcC_cisfVTKU0bVm3+=NFLt3P0EkXh3uC4hWCA7y_7G3w@mail.gmail.com>
 <CAOf5uw=G5iYfuoRBCOWU-PkEGpm1_qMwB+1=MjRQgxB+e_0w=g@mail.gmail.com>
 <CAOf5uwkLT_-esTkqj-Mhbsn_f-JETs+XF+vd8v=U+FQSoSPcQA@mail.gmail.com>
Cc: Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Ian Molton <ian@mnementh.co.uk>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B0D1BF1.7070105@broadcom.com> (sfid-20180529_112324_866424_A3EB35EE)
Date: Tue, 29 May 2018 11:22:57 +0200
MIME-Version: 1.0
In-Reply-To: <CAOf5uwkLT_-esTkqj-Mhbsn_f-JETs+XF+vd8v=U+FQSoSPcQA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/28/2018 5:33 PM, Michael Nazzareno Trimarchi wrote:
> Hi Andy
>
> The problem seems really easy to solve:
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> index 412a05b..ba60b151 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
> @@ -4227,13 +4227,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct
> brcmf_sdio_dev *sdiodev)
>          timer_setup(&bus->timer, brcmf_sdio_watchdog, 0);
>          /* Initialize watchdog thread */
>          init_completion(&bus->watchdog_wait);
> -       bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
> -                                       bus, "brcmf_wdog/%s",
> -                                       dev_name(&sdiodev->func1->dev));
> -       if (IS_ERR(bus->watchdog_tsk)) {
> -               pr_warn("brcmf_watchdog thread failed to start\n");
> -               bus->watchdog_tsk = NULL;
> -       }
> +
>          /* Initialize DPC thread */
>          bus->dpc_triggered = false;
>          bus->dpc_running = false;
> @@ -4281,6 +4275,14 @@ struct brcmf_sdio *brcmf_sdio_probe(struct
> brcmf_sdio_dev *sdiodev)
>                  goto fail;
>          }
>
> +       bus->watchdog_tsk = kthread_run(brcmf_sdio_watchdog_thread,
> +                                       bus, "brcmf_wdog/%s",
> +                                       dev_name(&sdiodev->func1->dev));
> +       if (IS_ERR(bus->watchdog_tsk)) {
> +               pr_warn("brcmf_watchdog thread failed to start\n");
> +               bus->watchdog_tsk = NULL;
> +       }
> +
>          return bus;

Hi Michael,

That makes no sense. Or are you saying the function 
brcmf_fw_get_firmwares() fails for you? Oh wait, you mentioned the 
driver was built-in, right? The above change does not solve the issue. 
It just makes it less likely to occur. So I think your initial fix is 
the best solution for this.

Regards,
Arend
