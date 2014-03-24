Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48347 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653AbaCXQ7U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 12:59:20 -0400
Message-ID: <5330644F.5050906@candelatech.com> (sfid-20140324_175923_880701_0671DBF5)
Date: Mon, 24 Mar 2014 09:58:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/3] ath10k:  Add debugging for tx-credits usage.
References: <1395428150-31996-1-git-send-email-greearb@candelatech.com> <871txr7svw.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <871txr7svw.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2014 04:12 AM, Kalle Valo wrote:
> greearb@candelatech.com writes:
> 
>> From: Ben Greear <greearb@candelatech.com>
>>
>> This helps track tx credits accounting and usage.  If
>> firmware hangs or otherwise fails to return credits, one
>> can more easily see the last few command types that
>> was send to the firmware.
>>
>> Signed-off-by: Ben Greear <greearb@candelatech.com>
> 
> This patchset didn't apply, and the sha1 ids were useless so that 3-way
> merge didn't work. Can you rebase, please? And better yet if you rebase
> in top of my master branch.

I will do this.  I must have some conflicting patch between your top of
tree and this patch in my tree...

>> -	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb);
>> +	status = ath10k_htc_send(htc, ATH10K_HTC_EP_0, skb, __LINE__);
> 
> Using line numbers in debug messages is very cumbersome. Some people
> cherry pick patches, have their own changes and whatnot which will make
> it more difficult to read the debug logs. Isn't there any better way to
> do this?

It is nasty, but I wanted to keep performance overhead light.
I could do an enum instead if you think that would be an improvement.

>> --- a/drivers/net/wireless/ath/ath10k/wmi.c
>> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
>> @@ -544,7 +544,7 @@ static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
>>  	cmd_hdr->cmd_id = __cpu_to_le32(cmd);
>>  
>>  	memset(skb_cb, 0, sizeof(*skb_cb));
>> -	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb);
>> +	ret = ath10k_htc_send(&ar->htc, ar->wmi.eid, skb, 0x71100000 | cmd_id);
>>  	trace_ath10k_wmi_cmd(cmd_id, skb->data, skb->len, ret);
> 
> What does 0x71100000 stand for?

It's just something that is easily grepped for, and is obviously not
a line number.

Hopefully someone will have a better idea how to do this sort of thing,
as my patch is pretty far down the slope towards total hack :)

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

