Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46528 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3EOQRl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 12:17:41 -0400
Received: by mail-ie0-f171.google.com with SMTP id e11so4118114iej.2
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 09:17:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87a9nwpaaf.fsf@kamboji.qca.qualcomm.com>
References: <20130515134258.GA9033@zenon.in.qult.net>
	<87a9nwpaaf.fsf@kamboji.qca.qualcomm.com>
Date: Wed, 15 May 2013 18:11:49 +0200
Message-ID: <CAFSJ42bDB+c0=eRmBYZBaQnZ4-h2Jm_MWZbfSEhUELb9y0Qv_Q@mail.gmail.com> (sfid-20130515_181744_761618_1C706F19)
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Ignacy Gawedzki <i@lri.fr>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

there is a function in driver "ath9k_htc_reset"
http://lxr.free-electrons.com/source/drivers/net/wireless/ath/ath9k/htc_drv_main.c#L189
but not sure that is what you are looking for.

2013/5/15 Kalle Valo <kvalo@qca.qualcomm.com>:
> Ignacy Gawedzki <i@lri.fr> writes:
>
>> Hi everyone,
>>
>> This is an old issue, about which it seems the first posts date back to 2009.
>> With the latest possible version of the firmware for AR9271 and the latest
>> possible wireless drivers, the issue is still there.  Whether this is still
>> the exact same problem every time remains to be checked, but it is annoying
>> enough to deserve some consideration.
>>
>> The problem is that the driver can't talk to the device if the following
>> conditions are met:
>>
>>  - The system cold boots with the USB dongle inserted or the USB dongle is
>>    inserted on a running system.
>>
>>  - The interface is *not* brought up.
>>
>>  - The system (warm) reboots.
>>
>> Then the driver complains about the target being unresponsive after uploading
>> the firmware.  Apparently the only way to make it work again is to unplug and
>> then plug the USB dongle back, physically.  It seems that if the USB port is
>> not powered down during reboot (which happens with at least two different
>> setups that I've tested it with), the device is left in a broken state.
>>
>> I would gladly help in tracing down this bug if only I knew where to start.
>
> With ath6kl a cold reset helped in a similar situation. Try to find if
> ath9k_htc has a cold/warm reset and see if that helps.
>
> --
> Kalle Valo
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel



-- 
Best regards,
Eugene
