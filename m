Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:33760 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994AbbFLF46 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2015 01:56:58 -0400
Received: by wgez8 with SMTP id z8so16899496wge.0
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 22:56:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871thiaxjq.fsf@kamboji.qca.qualcomm.com>
References: <1433765734-646-1-git-send-email-michal.kazior@tieto.com>
	<871thiaxjq.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 12 Jun 2015 07:56:57 +0200
Message-ID: <CA+BoTQ=PPahCmvKf3uAw3QPwW4WNPFoNofvrOquWnb=uBamNhQ@mail.gmail.com> (sfid-20150612_075702_790198_DB1899B0)
Subject: Re: [PATCH 1/2] ath10k: dump fw features during probing
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11 June 2015 at 20:51, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> This should help when analysing problems from
>> users and spot fw api blob problems easier.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +static unsigned int ath10k_core_get_fw_feature_str(char *buf,
>> +                                                size_t buf_len,
>> +                                                enum ath10k_fw_features feat)
>> +{
>> +     if (feat >= ARRAY_SIZE(ath10k_core_fw_feature_str) ||
>> +         WARN_ON(!ath10k_core_fw_feature_str[feat])) {
>> +             return scnprintf(buf, buf_len, "bit%d", feat);
>> +     } else {
>> +             return scnprintf(buf, buf_len, "%s",
>> +                              ath10k_core_fw_feature_str[feat]);
>> +     }
>> +}
>
> I think the else is useless and did the change below in pending branch.
> Please review.
>
> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -123,10 +123,9 @@ static unsigned int ath10k_core_get_fw_feature_str(char *buf,
>         if (feat >= ARRAY_SIZE(ath10k_core_fw_feature_str) ||
>             WARN_ON(!ath10k_core_fw_feature_str[feat])) {
>                 return scnprintf(buf, buf_len, "bit%d", feat);
> -       } else {
> -               return scnprintf(buf, buf_len, "%s",
> -                                ath10k_core_fw_feature_str[feat]);
>         }
> +
> +       return scnprintf(buf, buf_len, "%s", ath10k_core_fw_feature_str[feat]);
>  }
>
>  void ath10k_core_get_fw_features_str(struct ath10k *ar,

I think the "else" approach is a bit more easier on the eyes because
scnprintf() and format strings are aligned against each other.

I understand that you dropped "else" to adhere to `if (error) { handle error }`.

No strong opinions. Feel free to pick whatever suits you.


Michał
