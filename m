Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:46323 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728291AbeIJSs5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 14:48:57 -0400
Message-ID: <5B96779C.5060306@huawei.com> (sfid-20180910_160054_831199_1936F658)
Date: Mon, 10 Sep 2018 21:54:36 +0800
From: zhong jiang <zhongjiang@huawei.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wireless: remove unnecessary condition check before kfree
References: <1536415955-33776-1-git-send-email-zhongjiang@huawei.com> <1536563406.3224.2.camel@sipsolutions.net>
In-Reply-To: <1536563406.3224.2.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/9/10 15:10, Johannes Berg wrote:
> On Sat, 2018-09-08 at 22:12 +0800, zhong jiang wrote:
>> kfree has taken the null pointer into account. Just remove the
>> redundant condition check before kfree.
> I'm all for doing that if it actually removes conditionals, but
>
>> -	if (!IS_ERR_OR_NULL(regdb))
>> +	if (!IS_ERR(regdb))
>>  		kfree(regdb);
> this seems rather pointless since there's still a condition. In that
> case, I feel it's easier to understand the original code.
 Fine, make sense you have said. I just consider the duplication of function.
 
 Thanks,
 zhong jiang
> johannes
>
> .
>
