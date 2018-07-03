Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:43151 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753259AbeGCBsn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jul 2018 21:48:43 -0400
Subject: Re: [PATCH v2] atmel: using strlcpy() to avoid possible buffer
 overflows
To: Kalle Valo <kvalo@codeaurora.org>
References: <20180630063341.9900-1-yuehaibing@huawei.com>
 <8736x1snu9.fsf@kamboji.qca.qualcomm.com>
CC: <simon@thekelleys.org.uk>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, <andy.shevchenko@gmail.com>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <258d1cb3-b876-d7d5-48f8-13bf221c6b3d@huawei.com> (sfid-20180703_034902_054302_85648071)
Date: Tue, 3 Jul 2018 09:48:38 +0800
MIME-Version: 1.0
In-Reply-To: <8736x1snu9.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/7/2 22:40, Kalle Valo wrote:
> YueHaibing <yuehaibing@huawei.com> writes:
> 
>> 'firmware' is a module param which may been longer than firmware_id,
>> so using strlcpy() to guard against overflows. Also priv is allocated
>> with zeroed memory,no need to set firmware_id[0] to '\0'.
>>
>> v1 -> v2: remove priv->firmware_id[0] = '\0';
>>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>> ---
>>  drivers/net/wireless/atmel/atmel.c | 3 +--
>>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> The changelog should be after "---" line. I can fix it this time, but in
> the future please use the correct location.

Thank you,will notice it.

> 
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#changelog_missing
> 
