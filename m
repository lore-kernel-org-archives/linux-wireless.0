Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36662 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757659AbcLTPZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 10:25:43 -0500
Subject: Re: [PATCH] rtlwifi: Fix kernel oops introduced with commit
 e49656147359
To: Kalle Valo <kvalo@codeaurora.org>
References: <20161220023812.5999-1-Larry.Finger@lwfinger.net>
 <87wpeuu9qm.fsf@kamboji.qca.qualcomm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, driver-devel@vger.kernel.org,
        Stable <stable@vger.kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <c3779ada-0018-3ec5-cdb2-c470f9ca467e@lwfinger.net> (sfid-20161220_162547_663479_F0277727)
Date: Tue, 20 Dec 2016 09:25:40 -0600
MIME-Version: 1.0
In-Reply-To: <87wpeuu9qm.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/20/2016 05:21 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> With commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of
>> kfree_skb"), the method used to free an skb was changed because the
>> kfree_skb() was inside a spinlock. What was forgotten is that kfree_skb()
>> guards against a NULL value for the argument. Routine dev_kfree_skb_irq()
>> does not, and a test is needed to prevent kernel panics.
>>
>> Fixes: commit e49656147359 {"rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")
>
> This should be:
>
> Fixes: e49656147359 ("rtlwifi: Use dev_kfree_skb_irq instead of kfree_skb")
>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> Cc: Stable <stable@vger.kernel.org> (4.9+)
>
> And this:
>
> Cc: Stable <stable@vger.kernel.org> # 4.9+
>
> I can fix both of them.
>
>> Cc: Wei Yongjun <weiyongjun1@huawei.com>
>> ---
>> Kalle,
>>
>> This change should be sent to mainline during the 4.10 merge period,
>> or as soon as possible.
>
> Ok, I'll queue this to 4.10. Most likely I'll send a pull request to
> Dave later this week or so.

Thanks for the suggested changes, and for the quick action.

Larry
