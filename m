Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C90AC46475
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D72120651
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 14:28:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D72120651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728291AbeJWWwA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Oct 2018 18:52:00 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:14107 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727758AbeJWWwA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Oct 2018 18:52:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id CC8A7C6B254AC;
        Tue, 23 Oct 2018 22:28:13 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.408.0; Tue, 23 Oct 2018
 22:28:13 +0800
Message-ID: <5BCF2FFA.3060109@huawei.com>
Date:   Tue, 23 Oct 2018 22:28:10 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Lubomir Rintel <lkundrak@v3.sk>
CC:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <libertas-dev@lists.infradead.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] libertas: remove set but not used variable 'int_type'
References: <1540265568-58721-1-git-send-email-zhongjiang@huawei.com> <25ed3d0b71eb34e121f2d7a8d936665d7720270f.camel@v3.sk>
In-Reply-To: <25ed3d0b71eb34e121f2d7a8d936665d7720270f.camel@v3.sk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018/10/23 22:23, Lubomir Rintel wrote:
> On Tue, 2018-10-23 at 11:32 +0800, zhong jiang wrote:
>> int_type is not used after setting its value. It is safe to remove
>> the unused variable.
> Hi. I believe your colleague has sent an equivalent patch a few days
> ago in <1539569795-176889-1-git-send-email-yuehaibing@huawei.com>:
>
> https://lore.kernel.org/linux-wireless/1539569795-176889-1-git-send-email-yuehaibing@huawei.com/
I miss that. Thanks, please ignore the patch.

Sincerely,
zhong jiang
> Cheers,
> Lubo
>
>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>> ---
>>  drivers/net/wireless/marvell/libertas/if_spi.c | 4 +---
>>  1 file changed, 1 insertion(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/marvell/libertas/if_spi.c
>> b/drivers/net/wireless/marvell/libertas/if_spi.c
>> index 504d6e0..7c3224b 100644
>> --- a/drivers/net/wireless/marvell/libertas/if_spi.c
>> +++ b/drivers/net/wireless/marvell/libertas/if_spi.c
>> @@ -796,15 +796,13 @@ static void if_spi_h2c(struct if_spi_card
>> *card,
>>  {
>>  	struct lbs_private *priv = card->priv;
>>  	int err = 0;
>> -	u16 int_type, port_reg;
>> +	u16 port_reg;
>>  
>>  	switch (type) {
>>  	case MVMS_DAT:
>> -		int_type = IF_SPI_CIC_TX_DOWNLOAD_OVER;
>>  		port_reg = IF_SPI_DATA_RDWRPORT_REG;
>>  		break;
>>  	case MVMS_CMD:
>> -		int_type = IF_SPI_CIC_CMD_DOWNLOAD_OVER;
>>  		port_reg = IF_SPI_CMD_RDWRPORT_REG;
>>  		break;
>>  	default:
>
> .
>


