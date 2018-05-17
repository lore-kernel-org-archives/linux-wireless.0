Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37807 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752014AbeEQJEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 May 2018 05:04:31 -0400
Received: by mail-wm0-f65.google.com with SMTP id l1-v6so7603328wmb.2
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2018 02:04:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180516140820.1636-3-daniel@zonque.org>
References: <20180516140820.1636-1-daniel@zonque.org> <20180516140820.1636-3-daniel@zonque.org>
From: Ramon Fried <ramon.fried@gmail.com>
Date: Thu, 17 May 2018 12:04:29 +0300
Message-ID: <CA+Kvs9kJW5mna=o7i1rPJ3gmrss6SAZ1c9=fO44VmUrHw_6yxA@mail.gmail.com> (sfid-20180517_110437_185799_4B720188)
Subject: Re: [PATCH 02/10] wcn36xx: set DMA mask explicitly
To: Daniel Mack <daniel@zonque.org>
Cc: linux-wireless@vger.kernel.org, loic.poulain@linaro.org,
        bjorn.andersson@linaro.org, nicolas.dechesne@linaro.org,
        wcn36xx@lists.infradead.org, rfried@codeaurora.org,
        kvalo@codeaurora.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2018 at 5:08 PM, Daniel Mack <daniel@zonque.org> wrote:
> The device takes 32-bit addresses only, so inform the DMA API about it.
> This is the default on msm8016, so that doesn't change anything, but
> it's best practice to be explicit.
>
> Signed-off-by: Daniel Mack <daniel@zonque.org>
> ---
>  drivers/net/wireless/ath/wcn36xx/main.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
> index e3b91b3b38ef..e6330ad372b3 100644
> --- a/drivers/net/wireless/ath/wcn36xx/main.c
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -1309,6 +1309,12 @@ static int wcn36xx_probe(struct platform_device *pdev)
>         mutex_init(&wcn->hal_mutex);
>         mutex_init(&wcn->scan_lock);
>
> +       ret = dma_set_mask_and_coherent(wcn->dev, DMA_BIT_MASK(32));
> +       if (ret < 0) {
> +               wcn36xx_err("failed to set DMA mask: %d\n", ret);
> +               goto out_wq;
> +       }
> +
>         INIT_WORK(&wcn->scan_work, wcn36xx_hw_scan_worker);
>
>         wcn->smd_channel = qcom_wcnss_open_channel(wcnss, "WLAN_CTRL", wcn36xx_smd_rsp_process, hw);
> --
> 2.14.3
>
>
> _______________________________________________
> wcn36xx mailing list
> wcn36xx@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/wcn36xx
Acked-by: Ramon Fried <ramon.fried@linaro.org>
