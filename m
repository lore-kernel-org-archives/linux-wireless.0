Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:15206 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756377Ab3IZJHL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 05:07:11 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Bartosz Markowski <bartosz.markowski@tieto.com>,
	<ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/13] ath10k: introduce dynamic WMI structures
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
	<1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com>
	<87ob7grmhv.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQk98WwdqyVtyHy9A1Z5kWgmkC6sHVjgaQNbrRLfm8YSiA@mail.gmail.com>
Date: Thu, 26 Sep 2013 12:07:01 +0300
In-Reply-To: <CA+BoTQk98WwdqyVtyHy9A1Z5kWgmkC6sHVjgaQNbrRLfm8YSiA@mail.gmail.com>
	(Michal Kazior's message of "Thu, 26 Sep 2013 11:03:17 +0200")
Message-ID: <87fvssrlxm.fsf@kamboji.qca.qualcomm.com> (sfid-20130926_110721_993320_BF1585D5)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 September 2013 10:54, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Bartosz Markowski <bartosz.markowski@tieto.com> writes:
>>
>>> @@ -1293,7 +1438,8 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
>>>       if (skb == NULL)
>>>               return -ENOMEM;
>>>
>>> -     return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_RESUME_CMDID);
>>> +     return ath10k_wmi_cmd_send(ar, skb,
>>> +                                ar->wmi.cmd->wmi_pdev_resume_cmdid);
>>>  }
>>
>> I was thinking of adding a macro WMI_PDEV_RESUME_CMDID(ar) for all
>> dynamic wmi ids, that way it would look as closely as possible with the
>> original code. But I'm not sure if that makes sense anymore. Thoughts?
>
> Seems like an unnecessary indirection to me. You still need to have
> the mapping structure, unless you want to use macro concatenation (##)
> instead.

Yeah, there's no real benefit from the macro.

-- 
Kalle Valo
