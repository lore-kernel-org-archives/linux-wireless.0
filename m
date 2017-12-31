Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35116 "EHLO
        mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750880AbdLaMHM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 31 Dec 2017 07:07:12 -0500
MIME-Version: 1.0
In-Reply-To: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com>
References: <1514649113-7366-1-git-send-email-himanshujha199640@gmail.com>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Sun, 31 Dec 2017 14:07:10 +0200
Message-ID: <CAHp75VcFFfMp=nNDNyN3SNHnFXXXGGCobtKL2xaP+OqefmH5JQ@mail.gmail.com> (sfid-20171231_130733_217018_04BDB974)
Subject: Re: [PATCH] brcmfmac: Use zeroing memory allocator than allocator/memset
To: Himanshu Jha <himanshujha199640@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Dec 30, 2017 at 5:51 PM, Himanshu Jha
<himanshujha199640@gmail.com> wrote:
> Use dma_zalloc_coherent for allocating zeroed
> memory and remove unnecessary memset function.
>
> Done using Coccinelle.
> Generated-by: scripts/coccinelle/api/alloc/kzalloc-simple.cocci
> 0-day tested with no failures.
>

Makes sense.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>

> Suggested-by: Luis R. Rodriguez <mcgrof@kernel.org>
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 3c87157..bdef2ac 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -1251,14 +1251,13 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
>         u64 address;
>         u32 addr;
>
> -       devinfo->shared.scratch = dma_alloc_coherent(&devinfo->pdev->dev,
> -               BRCMF_DMA_D2H_SCRATCH_BUF_LEN,
> -               &devinfo->shared.scratch_dmahandle, GFP_KERNEL);
> +       devinfo->shared.scratch =
> +               dma_zalloc_coherent(&devinfo->pdev->dev,
> +                                       BRCMF_DMA_D2H_SCRATCH_BUF_LEN,
> +                                       &devinfo->shared.scratch_dmahandle,
> +                                       GFP_KERNEL);
>         if (!devinfo->shared.scratch)
>                 goto fail;
>
> -       memset(devinfo->shared.scratch, 0, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
> -
>         addr = devinfo->shared.tcm_base_address +
>                BRCMF_SHARED_DMA_SCRATCH_ADDR_OFFSET;
>         address = (u64)devinfo->shared.scratch_dmahandle;
> @@ -1268,14 +1267,13 @@ static int brcmf_pcie_init_scratchbuffers(struct brcmf_pciedev_info *devinfo)
>                BRCMF_SHARED_DMA_SCRATCH_LEN_OFFSET;
>         brcmf_pcie_write_tcm32(devinfo, addr, BRCMF_DMA_D2H_SCRATCH_BUF_LEN);
>
> -       devinfo->shared.ringupd = dma_alloc_coherent(&devinfo->pdev->dev,
> -               BRCMF_DMA_D2H_RINGUPD_BUF_LEN,
> -               &devinfo->shared.ringupd_dmahandle, GFP_KERNEL);
> +       devinfo->shared.ringupd =
> +               dma_zalloc_coherent(&devinfo->pdev->dev,
> +                                       BRCMF_DMA_D2H_RINGUPD_BUF_LEN,
> +                                       &devinfo->shared.ringupd_dmahandle,
> +                                       GFP_KERNEL);
>         if (!devinfo->shared.ringupd)
>                 goto fail;
>
> -       memset(devinfo->shared.ringupd, 0, BRCMF_DMA_D2H_RINGUPD_BUF_LEN);
> -
>         addr = devinfo->shared.tcm_base_address +
>                BRCMF_SHARED_DMA_RINGUPD_ADDR_OFFSET;
>         address = (u64)devinfo->shared.ringupd_dmahandle;
> --
> 2.7.4
>



-- 
With Best Regards,
Andy Shevchenko
