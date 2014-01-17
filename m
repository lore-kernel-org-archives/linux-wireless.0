Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:38935 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbaAQNqn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 08:46:43 -0500
Received: by mail-bk0-f52.google.com with SMTP id e11so670801bkh.39
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 05:46:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87lhyercjd.fsf@kamboji.qca.qualcomm.com>
References: <1389345563-3445-1-git-send-email-michal.kazior@tieto.com>
	<87lhyercjd.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 17 Jan 2014 14:46:39 +0100
Message-ID: <CA+BoTQktbmjYJA91mJ_EU=iTtCOFiPNPjjxRm=yxiwxposS-rA@mail.gmail.com> (sfid-20140117_144646_576083_57717E56)
Subject: Re: [PATCH] ath10k: add support for AP CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 January 2014 13:57, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This patch implements Channel Switch Announcement
>> for AP mode. This allows for a smooth channel
>> switch for connected stations that support CSA
>> when radar is detected.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -414,6 +414,7 @@ struct ath10k {
>>       unsigned int filter_flags;
>>       unsigned long dev_flags;
>>       u32 dfs_block_radar_events;
>> +     struct ath10k_vif *csa_arvif;
>
> Please document how this is serialised.

[...]

I have a local patch capable of multi-interface CSA which basically
rewrites this patch entirely. Unless you want me send that as a follow
up patch later I'd like to drop this patch and send a completely new
one later.


Michał
