Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:33682 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbcAGNIP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 08:08:15 -0500
Received: by mail-pa0-f50.google.com with SMTP id cy9so258706079pac.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2016 05:08:15 -0800 (PST)
Subject: Re: [PATCH v3 0/2] wcn36xx: fix crash because rx skb allocation
 failure
To: Kalle Valo <kvalo@codeaurora.org>
References: <1450617641-29531-1-git-send-email-fengwei.yin@linaro.org>
 <87si29k09a.fsf@kamboji.qca.qualcomm.com>
Cc: julian.calaby@gmail.com, linux-wireless@vger.kernel.org,
	wcn36xx@lists.infradead.org, me@bobcopeland.com,
	k.eugene.e@gmail.com, bjorn.andersson@sonymobile.com,
	lking@qti.qualcomm.com
From: yfw <fengwei.yin@linaro.org>
Message-ID: <568E6337.7070105@linaro.org> (sfid-20160107_140818_397494_6574D9BE)
Date: Thu, 7 Jan 2016 21:08:07 +0800
MIME-Version: 1.0
In-Reply-To: <87si29k09a.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2016年01月07日 21:05, Kalle Valo wrote:
> Fengwei Yin <fengwei.yin@linaro.org> writes:
>
>> The current wcn36xx driver didn't handle rx skb allocation failure case.
>> It only could be triggered when system is in extremly memory shortage
>> case. King Lawrence <lking@qti.qualcomm.com> hit it by git clone linux
>> kernel tree on DragonBoard <1>.
>>
>> The fixing is not to submit the old rx skb to network upper layer and
>> reuse it as rx DMA buffer again.
>>
>> Changes from v2:
>>   * Remove the ugly macro introduced in v2 per comment from Julian Calaby.
>>   * Seperate the DMA int mask register writing as one patch per comment
>>     from Bjorn Andersson.
>>
>> Changes from v1:
>>   * Move switch block out of while loop.
>>   * Remove the warning of unknown channel because we didn't deal with it.
>>
>> Fengwei Yin (2):
>>    wcn36xx: handle rx skb allocation failure to avoid system crash
>>    wcn36xx: split DMA mask register writing.
>
> Applied to ath.git, thanks.
>
Thanks a lot.

Regards
Yin, Fengwei
