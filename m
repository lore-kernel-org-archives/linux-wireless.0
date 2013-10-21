Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45247 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3JUGvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 02:51:49 -0400
Received: by mail-wi0-f180.google.com with SMTP id ey11so3456072wid.13
        for <linux-wireless@vger.kernel.org>; Sun, 20 Oct 2013 23:51:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87iowruocz.fsf@kamboji.qca.qualcomm.com>
References: <1382090878-22216-1-git-send-email-bartosz.markowski@tieto.com>
	<1382090878-22216-2-git-send-email-bartosz.markowski@tieto.com>
	<87iowruocz.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 21 Oct 2013 08:51:47 +0200
Message-ID: <CACKGw+EKg_5FQMvGPHxpvgt9wukyU5HD1jx++WkyYNLA3bBFSg@mail.gmail.com> (sfid-20131021_085152_259617_894C88B2)
Subject: Re: [PATCH 2/2] ath10k: extend number of AP interfaces for 10.X firmware
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 October 2013 08:31, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> This firmware can support up to 8 AP interfaces.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>> ---
>>  drivers/net/wireless/ath/ath10k/mac.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
>> index af046c4..dc65dcd 100644
>> --- a/drivers/net/wireless/ath/ath10k/mac.c
>> +++ b/drivers/net/wireless/ath/ath10k/mac.c
>> @@ -3255,7 +3255,7 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
>>       .types  = BIT(NL80211_IFTYPE_STATION)
>>       },
>>       {
>> -     .max    = 7,
>> +     .max    = 8,
>>       .types  = BIT(NL80211_IFTYPE_AP)
>>       },
>>  };
>
> Why only with 10.x firmware branch? Doesn't the main branch support 8
> interfaces?

With .636 there's a firmware crash when we try to create interface 8 (ap mode).

-- 
Bartosz
