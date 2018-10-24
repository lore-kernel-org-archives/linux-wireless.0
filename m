Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9363C46475
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 02:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D17120651
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 02:49:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D17120651
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbeJXLPM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 07:15:12 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:54321 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725979AbeJXLPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 07:15:11 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9F275B6FC880A;
        Wed, 24 Oct 2018 10:04:02 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.68) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.408.0; Wed, 24 Oct 2018
 10:04:01 +0800
Message-ID: <5BCFD310.90305@huawei.com>
Date:   Wed, 24 Oct 2018 10:04:00 +0800
From:   zhong jiang <zhongjiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To:     Pkshih <pkshih@realtek.com>, "joe@perches.com" <joe@perches.com>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] rtlwifi: remove set but not used variable 'radiob_array_table'
 and 'radiob_arraylen'
References: <1540283282-9772-1-git-send-email-zhongjiang@huawei.com>  <19b16ca89b5cde607338513638d4ef8e3a3d2802.camel@perches.com> <1540342331.2495.1.camel@realtek.com>
In-Reply-To: <1540342331.2495.1.camel@realtek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.29.68]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018/10/24 8:52, Pkshih wrote:
> On Tue, 2018-10-23 at 12:33 -0700, Joe Perches wrote:
>> On Tue, 2018-10-23 at 16:28 +0800, zhong jiang wrote:
>>> radiob_array_table' and 'radiob_arraylen' are not used after setting its
>> value.
>>> It is safe to remove the unused variable. Meanwhile, radio B radio should be
>>> removed as well. because it will no longer be referenced.
>> The patch subject is a bit off and too generic here.
>>
>> This is specific to rtl8723ae and not rtlwifi so it is
>> probably better for the subject to be something like:
>>
>> [PATCH] rtl8723ae: Remove set but not used variables and #defines
> I'd like 'rtlwifi: rtl8723ae: ' as subject prefix.
Thanks for your suggestion. Will change the subject and resend.

[PATCH] rtlwifi: rtl8723ae: Remove set but not used variables and #defines


Thanks,
zhong jiang
>>> Signed-off-by: zhong jiang <zhongjiang@huawei.com>
>>> ---
>>>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/phy.c   | 5 +----
>>>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.c | 4 ----
>>>   drivers/net/wireless/realtek/rtlwifi/rtl8723ae/table.h | 2 --
>>
>> ------Please consider the environment before printing this e-mail.


