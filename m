Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C9E2C6787A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07E2020C0A
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 01:24:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 07E2020C0A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726699AbeJIIjH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 04:39:07 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:13606 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbeJIIjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 04:39:07 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 3C83DD813E27D;
        Tue,  9 Oct 2018 09:24:38 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.399.0; Tue, 9 Oct 2018
 09:24:38 +0800
Subject: Re: [PATCH net-next] mt76x0: pci: fix set external PA I/O current
To:     David Miller <davem@davemloft.net>
References: <1539004909-195005-1-git-send-email-yuehaibing@huawei.com>
 <20181008.110230.1232459474222849074.davem@davemloft.net>
CC:     <kvalo@codeaurora.org>, <nbd@nbd.name>,
        <lorenzo.bianconi@redhat.com>, <sgruszka@redhat.com>,
        <linux-wireless@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <e77eab30-6989-afcc-c257-c7201faf5732@huawei.com>
Date:   Tue, 9 Oct 2018 09:24:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20181008.110230.1232459474222849074.davem@davemloft.net>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2018/10/9 2:02, David Miller wrote:
> From: YueHaibing <yuehaibing@huawei.com>
> Date: Mon, 8 Oct 2018 13:21:49 +0000
> 
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c: In function 'mt76x0e_register_device':
>> drivers/net/wireless/mediatek/mt76/mt76x0/pci.c:107:8: warning:
>>  variable 'data' set but not used [-Wunused-but-set-variable]
>>
>> It seems correct value to write is 'data'
>>
>> Fixes: 2b2cb40bcd7d ("mt76x0: pci: add hw initialization at bootstrap")
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> 
> Wireless changes should be marked as appropriate in the Subject line
> for targetting the wireless GIT tree, not "net-next".

Ok, will fix it in v2.

> 
> .
> 

