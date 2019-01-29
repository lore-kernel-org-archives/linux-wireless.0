Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1878BC282D0
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 06:04:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB2E02177E
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 06:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfA2GD2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 01:03:28 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:2691 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfA2GD1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 01:03:27 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id D8DF69316415B00B7C32;
        Tue, 29 Jan 2019 14:03:25 +0800 (CST)
Received: from [127.0.0.1] (10.177.31.96) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.408.0; Tue, 29 Jan 2019
 14:03:24 +0800
Subject: Re: [PATCH] rtlwifi: remove set but not used variable 'cmd_seq'
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <1536667978-10556-1-git-send-email-yuehaibing@huawei.com>
 <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
From:   YueHaibing <yuehaibing@huawei.com>
Message-ID: <e37bae9c-c920-56cf-7813-0004c017f02a@huawei.com>
Date:   Tue, 29 Jan 2019 14:03:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <581817ea-a414-e6ed-3615-5e44837a5221@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.31.96]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+cc netdev@vger.kernel.org

On 2019/1/29 13:57, YueHaibing wrote:
> ping...
> 
> On 2018/9/11 20:12, YueHaibing wrote:
>> Fixes gcc '-Wunused-but-set-variable' warning:
>>
>> drivers/net/wireless/realtek/rtlwifi/base.c: In function 'rtl_c2h_content_parsing':
>> drivers/net/wireless/realtek/rtlwifi/base.c:2313:13: warning:
>>  variable 'cmd_seq' set but not used [-Wunused-but-set-variable]
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/wireless/realtek/rtlwifi/base.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
>> index f4122c8..92b6918 100644
>> --- a/drivers/net/wireless/realtek/rtlwifi/base.c
>> +++ b/drivers/net/wireless/realtek/rtlwifi/base.c
>> @@ -2310,11 +2310,10 @@ static void rtl_c2h_content_parsing(struct ieee80211_hw *hw,
>>  	struct rtl_priv *rtlpriv = rtl_priv(hw);
>>  	struct rtl_hal_ops *hal_ops = rtlpriv->cfg->ops;
>>  	const struct rtl_btc_ops *btc_ops = rtlpriv->btcoexist.btc_ops;
>> -	u8 cmd_id, cmd_seq, cmd_len;
>> +	u8 cmd_id, cmd_len;
>>  	u8 *cmd_buf = NULL;
>>  
>>  	cmd_id = GET_C2H_CMD_ID(skb->data);
>> -	cmd_seq = GET_C2H_SEQ(skb->data);
>>  	cmd_len = skb->len - C2H_DATA_OFFSET;
>>  	cmd_buf = GET_C2H_DATA_PTR(skb->data);
>>
>>
>> .
>>

