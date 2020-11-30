Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36230C64E8A
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Nov 2020 18:21:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9EF6206F9
	for <linux-wireless@archiver.kernel.org>; Mon, 30 Nov 2020 18:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbgK3SUz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:20:55 -0500
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:27092 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727182AbgK3SUz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 30 Nov 2020 13:20:55 -0500
Received: from [192.168.42.210] ([81.185.173.102])
        by mwinf5d73 with ME
        id yiK82300D2CvH0103iK8vB; Mon, 30 Nov 2020 19:19:10 +0100
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 30 Nov 2020 19:19:10 +0100
X-ME-IP: 81.185.173.102
Subject: Re: [PATCH] mlxsw: switch from 'pci_' to 'dma_' API
To:     Heiner Kallweit <hkallweit1@gmail.com>, jiri@nvidia.com,
        idosch@nvidia.com, davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Newsgroups: gmane.linux.kernel.janitors,gmane.linux.kernel.wireless.general,gmane.linux.network,gmane.linux.kernel
References: <20201129211733.2913-1-christophe.jaillet@wanadoo.fr>
 <a4fde87f-ea73-8ba4-e6cd-689f0f649eb4@gmail.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <35052891-4d32-19f0-e991-2aad009917e9@wanadoo.fr>
Date:   Mon, 30 Nov 2020 19:19:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <a4fde87f-ea73-8ba4-e6cd-689f0f649eb4@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Le 29/11/2020 à 22:46, Heiner Kallweit a écrit :
> Am 29.11.2020 um 22:17 schrieb Christophe JAILLET:
>> @@ -1817,17 +1817,17 @@ static int mlxsw_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>   		goto err_pci_request_regions;
>>   	}
>>   
>> -	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
>> +	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
> 
> Using dma_set_mask_and_coherent() would be better here.
> 
>>   	if (!err) {
>> -		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(64));
>> +		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(64));
>>   		if (err) {
> 
> This check isn't needed, see comment at definition of
> dma_set_mask_and_coherent().
> 

Hi,

Correct, but I didn't want to mix several things in the same commit.
This one is dedicated to automatically generated changes done with 
coccinelle.

I plan to have another set of such clean-ups once "wrappers in 
include/linux/pci-dma-compat.h are gone"

However, if it is prefered to have only one patch, I can resubmit.

CJ

