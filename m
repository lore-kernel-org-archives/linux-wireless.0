Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f172.google.com ([209.85.214.172]:33400 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbcCGOrR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Mar 2016 09:47:17 -0500
Received: by mail-ob0-f172.google.com with SMTP id fz5so107188044obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 07 Mar 2016 06:47:17 -0800 (PST)
Subject: Re: [PATCH] rtlwifi: Fix size of wireless mode variable
To: Kalle Valo <kvalo@codeaurora.org>
References: <1456419781-14722-1-git-send-email-Larry.Finger@lwfinger.net>
 <87pov6tqcu.fsf@kamboji.qca.qualcomm.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56DD9472.4050308@lwfinger.net> (sfid-20160307_154721_005191_0A5F497A)
Date: Mon, 7 Mar 2016 08:47:14 -0600
MIME-Version: 1.0
In-Reply-To: <87pov6tqcu.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/07/2016 06:38 AM, Kalle Valo wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>
>> Smatch reports the following warning:
>>
>>    CHECK   drivers/net/wireless/realtek/rtlwifi/rc.c
>> drivers/net/wireless/realtek/rtlwifi/rc.c:144 _rtl_rc_rate_set_series() warn: impossible condition '(wireless_mode == 256) => (0-255 == 256)'
>>
>> This warning arises because commit acc6907b87a9 ("rtlwifi: Fix warning
>> from ieee80211_get_tx_rates() when using 5G") now checks the wireless
>> mode for WIRELESS_MODE_AC_ONLY (BIT(8)) in _rtl_rc_rate_set_series().
>> As a result, all quantities used to store the wireless mode must be u16.
>>
>> This patch also reorders struct rtl_sta_info to save a little space.
>>
>> Fixes: commit acc6907b87a9 ("rtlwifi: Fix warning from ieee80211_get_tx_rates() when using 5G")
>> Reported-by: Dan Williams <dcbw@redhat.com>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>
> I can't find commit acc6907b87a9 from any of my trees. And oddly enough
> I can't either any commits with title "rtlwifi: Fix warning from
> ieee80211_get_tx_rates() when using 5G". I can fix it before commiting
> but what should I use?
>
> Also the fixes line should not have the word "commit".

Kalle,

I do not know where I got that commit and title. The correct reference is commit 
d76d65fd2695 ("rtlwifi: fix broken VHT support").

If you would rather not fix this on commit, I can submit a new version.

Thanks,

Larry


