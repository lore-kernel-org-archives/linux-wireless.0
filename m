Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42652 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751089AbeDFIFg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 04:05:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        ath10k@lists.infradead.org
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for various chipsets
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
        <871sftemru.fsf@kamboji.qca.qualcomm.com>
        <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
Date: Fri, 06 Apr 2018 11:05:30 +0300
In-Reply-To: <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com> (Sebastian
        Gottschall's message of "Thu, 5 Apr 2018 20:01:47 +0200")
Message-ID: <87lge0sqt1.fsf@codeaurora.org> (sfid-20180406_100544_352534_E87683EA)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 05.04.2018 um 16:44 schrieb Kalle Valo:
>> s.gottschall@dd-wrt.com writes:
>>
>>> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984
>>> based chipsets with on chipset connected led's using WMI Firmware API.
>>> The LED device will get available named as "ath10k-phyX" at sysfs and
>>> can be controlled with various triggers. adds also debugfs interface
>>> for gpio control.
>>>
>>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>> [...]
>>
>>> @@ -1034,7 +1068,7 @@ ath10k_wmi_pdev_get_temperature(struct ath10k *ar)
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (IS_ERR(skb))
>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return PTR_ERR(s=
kb);
>>> =C2=A0 -=C2=A0=C2=A0=C2=A0 return ath10k_wmi_cmd_send(ar, skb,
>>> +=C2=A0=C2=A0=C2=A0 return ath10k_wmi_cmd_send_nowait(ar, skb,
>>> ar->wmi.cmd->pdev_get_temperature_cmdid);
>>> =C2=A0 }
>> This looks odd, I don't think it belongs to this patch.
>
> thats true. but due the nature of this function i found it better to
> use nowait here. better if i split it up?

Yes, this should be done in a separate patch with a proper commit log
explaining why it's needed.

>> Also you made a some sort of record, your patch had 181 checkpatch
>> warnings! Do you use Word as your editor or what? But please do check
>> your editor settings and read the coding style documents.
>
> no? i use midnight commander for all of my code since more than 20 years
> and its the first time that i see such warnings. is there any special
> coding rule for ath10k which differs from the kernel rules?

You got even the indentation wrong in multiple functions and indentation
rules have been the same as long as I remember. And checkpatch has been
around a long time already, that should not be new to anyone submitting
patches.

> and where is ath10k-check located?

Check the link I provided:

>> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle

--=20
Kalle Valo
