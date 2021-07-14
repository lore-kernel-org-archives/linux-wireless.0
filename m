Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C2E6C07E9A
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jul 2021 08:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7B2AC613A9
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Jul 2021 08:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238377AbhGNIGn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Jul 2021 04:06:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238254AbhGNIGn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jul 2021 04:06:43 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0DEDC06175F;
        Wed, 14 Jul 2021 01:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yid88HK+4EUm3M5vzWau2hpsI+S75ADbVyna/AKkqCc=; b=iCTSFoopf4OKzN1ZjTAHtMUa80
        6S/FQmX/GSv+QuTbVtzb12lbv/kmtqmjyfveESnKTDbE9NOb1iegy5T1eHrCJCR6rgq+Mukc259lf
        bcEirBXZihqY77Eh35fHZa0H4cGiIxFWxt0KGauIP87gOaM74ebE9+PqnscLhPQB/Yco=;
Received: from p54ae93f7.dip0.t-ipconnect.de ([84.174.147.247] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1m3Zru-0008WH-S2; Wed, 14 Jul 2021 10:03:46 +0200
Subject: Re: [RFC 2/7] net: ethernet: mtk_eth_soc: add support for Wireless
 Ethernet Dispatch (WED)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pablo@netfilter.org, ryder.lee@mediatek.com
References: <20210713160745.59707-1-nbd@nbd.name>
 <20210713160745.59707-3-nbd@nbd.name> <YO3cHoEGwzpWDxnI@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <425c69f9-7a11-2a54-b2c0-23196eee9692@nbd.name>
Date:   Wed, 14 Jul 2021 10:03:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YO3cHoEGwzpWDxnI@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2021-07-13 20:31, Andrew Lunn wrote:
>> diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
>> +
>> +static inline void
>> +wed_m32(struct mtk_wed_device *dev, u32 reg, u32 mask, u32 val)
>> +{
>> +	regmap_update_bits(dev->hw->regs, reg, mask | val, val);
>> +}
> 
> Please don't use inline functions in .c files. Let the compiler
> decide.
Will drop inline

>> +static void
>> +mtk_wed_reset(struct mtk_wed_device *dev, u32 mask)
>> +{
>> +	int i;
>> +
>> +	wed_w32(dev, MTK_WED_RESET, mask);
>> +	for (i = 0; i < 100; i++) {
>> +		if (wed_r32(dev, MTK_WED_RESET) & mask)
>> +			continue;
>> +
>> +		return;
>> +	}
> 
> It may be better to use something from iopoll.h
Will do

>> +static inline int
>> +mtk_wed_device_attach(struct mtk_wed_device *dev)
>> +{
>> +	int ret = -ENODEV;
>> +
>> +#ifdef CONFIG_NET_MEDIATEK_SOC_WED
> 
> if (IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED) is better, since it
> compiles the code, and then the optimizer throws away.
This one is intentional, since struct mtk_wed_device will be empty if
CONFIG_NET_MEDIATEK_SOC_WED is not set. The code would not compile
without the #ifdef.

Thanks,

- Felix
