Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97066C07E95
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Jul 2021 18:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75DEF613B0
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Jul 2021 18:32:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbhGMSex (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Jul 2021 14:34:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53088 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229478AbhGMSew (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jul 2021 14:34:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9YX3KaYPNTTmjOqBKaIiOKVXMBstGoy/1b6T+CZC0ck=; b=H6tJizJFpKicvb4o0o7PicCO8U
        NJHCGYB5r0WQBKZm2BePBdcb2fBVVqI/kojVDQljkJZUHVKxtWBNGpIqbDqS3E6eb8BuLQVWD80aR
        iF0Oa0LyJzjlAM+b4QzwbgKhjPt8dI5x67rYCnaMS3ZtYvAHWxTRiTtMw4uRnRrqHofk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m3NCI-00DFC4-So; Tue, 13 Jul 2021 20:31:58 +0200
Date:   Tue, 13 Jul 2021 20:31:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, ryder.lee@mediatek.com
Subject: Re: [RFC 2/7] net: ethernet: mtk_eth_soc: add support for Wireless
 Ethernet Dispatch (WED)
Message-ID: <YO3cHoEGwzpWDxnI@lunn.ch>
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-3-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713160745.59707-3-nbd@nbd.name>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
> +
> +static inline void
> +wed_m32(struct mtk_wed_device *dev, u32 reg, u32 mask, u32 val)
> +{
> +	regmap_update_bits(dev->hw->regs, reg, mask | val, val);
> +}

Please don't use inline functions in .c files. Let the compiler
decide.

> +static void
> +mtk_wed_reset(struct mtk_wed_device *dev, u32 mask)
> +{
> +	int i;
> +
> +	wed_w32(dev, MTK_WED_RESET, mask);
> +	for (i = 0; i < 100; i++) {
> +		if (wed_r32(dev, MTK_WED_RESET) & mask)
> +			continue;
> +
> +		return;
> +	}

It may be better to use something from iopoll.h

> +static inline int
> +mtk_wed_device_attach(struct mtk_wed_device *dev)
> +{
> +	int ret = -ENODEV;
> +
> +#ifdef CONFIG_NET_MEDIATEK_SOC_WED

if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) is better, since it
compiles the code, and then the optimizer throws away.

> +	rcu_read_lock();
> +	dev->ops = rcu_dereference(mtk_soc_wed_ops);
> +	if (dev->ops)
> +		ret = dev->ops->attach(dev);
> +	rcu_read_unlock();
> +
> +	if (ret)
> +		dev->ops = NULL;
> +#endif
> +
> +	return ret;
> +}

  Andrew
