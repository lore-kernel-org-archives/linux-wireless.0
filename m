Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:49852 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaEWIiX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 04:38:23 -0400
Received: by mail-wi0-f172.google.com with SMTP id hi2so454265wib.17
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 01:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87oayovr1m.fsf@kamboji.qca.qualcomm.com>
References: <1399637749-13489-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-1-git-send-email-michal.kazior@tieto.com>
	<1400143324-14911-4-git-send-email-michal.kazior@tieto.com>
	<87oayovr1m.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 May 2014 10:38:20 +0200
Message-ID: <CA+BoTQmJTsh3Kcwmqx19WAzoBhYrhkQaPT_S=JFVPptkVaaKyw@mail.gmail.com> (sfid-20140523_103831_577790_8E0CCF53)
Subject: Re: [PATCH v2 3/5] ath10k: drain tx before restarting hw
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 May 2014 10:27, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This makes sure no further tx requests are
>> submitted to HTT before driver teardown.
>>
>> This should prevent invalid pointer/NULL
>> dereference on htt tx pool in ath10k_htt_tx() in
>> some cases of heavy traffic.
>>
>> Reported-By: Ben Greear <greearb@candelatech.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -2289,6 +2289,21 @@ static void ath10k_tx(struct ieee80211_hw *hw,
>>  /*
>>   * Initialize various parameters with default vaules.
>>   */
>> +static void ath10k_drain_tx(struct ath10k *ar)
>> +{
>> +     /* workers can hold conf_mutex -- avoid deadlock */
>> +     WARN_ON(lockdep_is_held(&ar->conf_mutex));
>
> If CONFIG_LOCKDEP is disabled this will fail with:
>
> drivers/net/wireless/ath/ath10k/mac.c:2301:2: error: implicit declaration of function 'lockdep_is_held' [-Werror=implicit-function-declaration]
>
> I wasn't able to come up with any other way than adding '#ifdef
> CONFIG_LOCKDEP' which is quite ugly. What should we do?

I guess we could define lockdep_assert_not_held() in debug.h?


Michał
