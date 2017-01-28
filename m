Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:36373 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751049AbdA1Rba (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 28 Jan 2017 12:31:30 -0500
Received: by mail-ot0-f194.google.com with SMTP id 36so33987028otx.3
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2017 09:31:30 -0800 (PST)
Subject: Re: [PATCH 11/11] rtlwifi: Add work queue for c2h cmd.
To: Kalle Valo <kvalo@codeaurora.org>
References: <20170120212716.29887-1-Larry.Finger@lwfinger.net>
 <20170120212716.29887-12-Larry.Finger@lwfinger.net>
 <87ziibfzcm.fsf@purkki.adurom.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a26323a4-cde7-8e8e-1a0c-f9de8ea4b366@lwfinger.net> (sfid-20170128_183152_933554_3C5F60C5)
Date: Sat, 28 Jan 2017 11:31:29 -0600
MIME-Version: 1.0
In-Reply-To: <87ziibfzcm.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/28/2017 12:55 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>
>> btcoex needs to sleep, thus it must run in thread context.
>>
>> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> [...]
>
>> +void rtl_c2hcmd_launcher(struct ieee80211_hw *hw, int exec)
>> +{
>> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
>> +	unsigned long flags;
>> +	struct rtl_c2hcmd *c2hcmd;
>> +
>> +	while (true) {
>> +		/* dequeue a task */
>> +		spin_lock_irqsave(&rtlpriv->locks.c2hcmd_lock, flags);
>> +
>> +		c2hcmd = list_first_entry_or_null(&rtlpriv->c2hcmd_list,
>> +						  struct rtl_c2hcmd, list);
>> +
>> +		if (c2hcmd)
>> +			list_del(&c2hcmd->list);
>> +
>> +		spin_unlock_irqrestore(&rtlpriv->locks.c2hcmd_lock, flags);
>> +
>> +		/* do it */
>> +		if (!c2hcmd)
>> +			break;
>> +
>> +		if (rtlpriv->cfg->ops->c2h_content_parsing && exec)
>> +			rtlpriv->cfg->ops->c2h_content_parsing(hw,
>> +					c2hcmd->tag, c2hcmd->len, c2hcmd->val);
>> +
>> +		/* free */
>> +		kfree(c2hcmd->val);
>> +
>> +		kfree(c2hcmd);
>> +	}
>> +}
>
> Never ending loops are not really preferred in kernel, with a simple bug
> it could cause annoying system-wide problems. Can you add a some sort of
> failsafe mechanism, for example bailing out from the loop if it has been
> running more than 200 ms or something like that?

Certainly.

Larry
