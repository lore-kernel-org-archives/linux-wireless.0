Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-co1nam03on0070.outbound.protection.outlook.com ([104.47.40.70]:62336
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750990AbdHaJs1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 05:48:27 -0400
Date: Thu, 31 Aug 2017 12:48:12 +0300
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: implement 64-bit dma support
Message-ID: <20170831094812.utahi5ayz3ag7wrl@bars> (sfid-20170831_114832_045600_952C071B)
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
 <20170829121623.24761-6-sergey.matyukevich.os@quantenna.com>
 <87lgm1nh7j.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87lgm1nh7j.fsf@purkki.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Kalle,

> > -     writel(QTN_HOST_LO32(paddr),
> > -            PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
> > +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
> >       writel(QTN_HOST_HI32(paddr),
> >              PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
> > +#endif
> 
> Personally I detest ifdefs and try to write code like this using
> IS_ENABLED():
> 
> if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
>         writel(QTN_HOST_HI32(paddr),
>                PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
> 
> But up to you which style you prefer.

I agree that this way it looks better. But I am using the same ifdef in header
to define QTN_HOST_* macros. So in this particular case I would prefer to
keep the same notation in both source and header files.

Thanks,
Sergey
