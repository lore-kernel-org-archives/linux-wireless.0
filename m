Return-Path: <SRS0=8y3j=B4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C5EC433E1
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Aug 2020 01:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A645E2075E
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Aug 2020 01:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgHRBm7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Aug 2020 21:42:59 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:58142 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgHRBm5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Aug 2020 21:42:57 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.9]) by rmmx-syy-dmz-app03-12003 (RichMail) with SMTP id 2ee35f3b320ed58-a7502; Tue, 18 Aug 2020 09:42:38 +0800 (CST)
X-RM-TRANSID: 2ee35f3b320ed58-a7502
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from [192.168.21.77] (unknown[10.42.68.12])
        by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee55f3b320d8b7-328ee;
        Tue, 18 Aug 2020 09:42:38 +0800 (CST)
X-RM-TRANSID: 2ee55f3b320d8b7-328ee
Subject: Re: [PATCH] ath10k: fix the status check and wrong return
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org
References: <20200814144844.1920-1-tangbin@cmss.chinamobile.com>
 <87y2mdjqkx.fsf@codeaurora.org>
From:   Tang Bin <tangbin@cmss.chinamobile.com>
Message-ID: <e53ee8ca-9c2b-2313-6fd7-8f73ae33e1a2@cmss.chinamobile.com>
Date:   Tue, 18 Aug 2020 09:42:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87y2mdjqkx.fsf@codeaurora.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle£º

ÔÚ 2020/8/17 22:26, Kalle Valo Ð´µÀ:
>> In the function ath10k_ahb_clock_init(), devm_clk_get() doesn't
>> return NULL. Thus use IS_ERR() and PTR_ERR() to validate
>> the returned value instead of IS_ERR_OR_NULL().
> Why? What's the benefit of this patch? Or what harm does
> IS_ERR_OR_NULL() create?

Thanks for you reply, the benefit of this patch is simplify the code, 
because in

this function, I don't think the situation of 'devm_clk_get() return 
NULL' exists.

So please think about it, thanks.


Tang Bin

>
>> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
>> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
>> ---
>>   drivers/net/wireless/ath/ath10k/ahb.c | 12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
>> index ed87bc00f..ea669af6a 100644
>> --- a/drivers/net/wireless/ath/ath10k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath10k/ahb.c
>> @@ -87,24 +87,24 @@ static int ath10k_ahb_clock_init(struct ath10k *ar)
>>   	dev = &ar_ahb->pdev->dev;
>>   
>>   	ar_ahb->cmd_clk = devm_clk_get(dev, "wifi_wcss_cmd");
>> -	if (IS_ERR_OR_NULL(ar_ahb->cmd_clk)) {
>> +	if (IS_ERR(ar_ahb->cmd_clk)) {
>>   		ath10k_err(ar, "failed to get cmd clk: %ld\n",
>>   			   PTR_ERR(ar_ahb->cmd_clk));
>> -		return ar_ahb->cmd_clk ? PTR_ERR(ar_ahb->cmd_clk) : -ENODEV;
>> +		return PTR_ERR(ar_ahb->cmd_clk);
>>   	}
> devm_clk_get() can return NULL if CONFIG_HAVE_CLK is disabled:
>
> static inline struct clk *devm_clk_get(struct device *dev, const char *id)
> {
> 	return NULL;
> }
>


