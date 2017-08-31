Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:59614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750790AbdHaLJS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 07:09:18 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
Subject: Re: [PATCH 5/5] qtnfmac: implement 64-bit dma support
References: <20170829121623.24761-1-sergey.matyukevich.os@quantenna.com>
        <20170829121623.24761-6-sergey.matyukevich.os@quantenna.com>
        <87lgm1nh7j.fsf@purkki.adurom.net>
        <20170831094812.utahi5ayz3ag7wrl@bars>
Date: Thu, 31 Aug 2017 14:09:12 +0300
In-Reply-To: <20170831094812.utahi5ayz3ag7wrl@bars> (Sergey Matyukevich's
        message of "Thu, 31 Aug 2017 12:48:12 +0300")
Message-ID: <87bmmwro2v.fsf@kamboji.qca.qualcomm.com> (sfid-20170831_130921_954537_84D1DC41)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> > -     writel(QTN_HOST_LO32(paddr),
>> > -            PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
>> > +#ifdef CONFIG_ARCH_DMA_ADDR_T_64BIT
>> >       writel(QTN_HOST_HI32(paddr),
>> >              PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
>> > +#endif
>> 
>> Personally I detest ifdefs and try to write code like this using
>> IS_ENABLED():
>> 
>> if (IS_ENABLED(CONFIG_ARCH_DMA_ADDR_T_64BIT))
>>         writel(QTN_HOST_HI32(paddr),
>>                PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
>> 
>> But up to you which style you prefer.
>
> I agree that this way it looks better. But I am using the same ifdef in header
> to define QTN_HOST_* macros. So in this particular case I would prefer to
> keep the same notation in both source and header files.

Ok. I'll try to get these to 4.14 still.

-- 
Kalle Valo
