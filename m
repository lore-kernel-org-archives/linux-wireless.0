Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:62734 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3IZJDU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:03:20 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so292865bkb.15
        for <linux-wireless@vger.kernel.org>; Thu, 26 Sep 2013 02:03:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ob7grmhv.fsf@kamboji.qca.qualcomm.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
	<87ob7grmhv.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 26 Sep 2013 11:03:17 +0200
Message-ID: <CA+BoTQk98WwdqyVtyHy9A1Z5kWgmkC6sHVjgaQNbrRLfm8YSiA@mail.gmail.com> (sfid-20130926_110326_585020_FE45E03F)
Subject: Re: [PATCH 01/13] ath10k: introduce dynamic WMI structures
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Bartosz Markowski <bartosz.markowski@tieto.com>,
	ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 September 2013 10:54, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>
>> This is the initial framework to implement dynamic
>> WMI API in order to support new firmware (from so
>> called 10.X branch)
>>
>> The realization is to have a static WMI cmd map for
>> each of the firmwares, registered upom wmi init.
>>
>> This patch creates such map for MAIN FW, updates
>> wmi_cmd_send() calls to take as a parameter
>> the map value instead of direct WMI enum.
>>
>> As soon as complete 10.X API will be on place,
>> we will introduce the FW IE mechanics to dynamicaly
>> identify which FW is being used and based on that
>> we will use correct map, API, structures, etc.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>> ---
>
> [...]
>
>> @@ -1293,7 +1438,8 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
>>       if (skb == NULL)
>>               return -ENOMEM;
>>
>> -     return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_RESUME_CMDID);
>> +     return ath10k_wmi_cmd_send(ar, skb,
>> +                                ar->wmi.cmd->wmi_pdev_resume_cmdid);
>>  }
>
> I was thinking of adding a macro WMI_PDEV_RESUME_CMDID(ar) for all
> dynamic wmi ids, that way it would look as closely as possible with the
> original code. But I'm not sure if that makes sense anymore. Thoughts?

Seems like an unnecessary indirection to me. You still need to have
the mapping structure, unless you want to use macro concatenation (##)
instead.


Michał.
