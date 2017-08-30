Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36272 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750995AbdH3QjA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 12:39:00 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: implement 64-bit dma support
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
        <20170829121623.24761-6-sergey.matyukevich.os@quantenna.com>
Date: Wed, 30 Aug 2017 19:38:56 +0300
In-Reply-To: <20170829121623.24761-6-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 29 Aug 2017 15:16:23 +0300")
Message-ID: <87lgm1nh7j.fsf@purkki.adurom.net> (sfid-20170830_183903_791503_8C3E3ABF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Use 64-bit dma for hosts with CONFIG_ARCH_DMA_ADDR_T_64BIT enabled.
>
> Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
> ---
>  .../net/wireless/quantenna/qtnfmac/pearl/pcie.c    | 70 ++++++++++++++++++----
>  .../wireless/quantenna/qtnfmac/pearl/pcie_ipc.h    | 10 ++--
>  .../quantenna/qtnfmac/pearl/pcie_regs_pearl.h      |  1 +
>  3 files changed, 65 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> index 2921d8069bf2..502e72b7cdcc 100644
> --- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> +++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
> @@ -403,10 +403,12 @@ static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
>  	priv->rx_bd_vbase = vaddr;
>  	priv->rx_bd_pbase = paddr;
>  
> -	writel(QTN_HOST_LO32(paddr),
> -	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
> +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>  	writel(QTN_HOST_HI32(paddr),
>  	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
> +#endif

Personally I detest ifdefs and try to write code like this using
IS_ENABLED():

if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
  	writel(QTN_HOST_HI32(paddr),
  	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));

But up to you which style you prefer.

-- 
Kalle Valo
