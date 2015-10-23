Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbbJWO0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 10:26:08 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
References: <562A2711.9040700@gmail.com> <wrfj7fmdit3l.fsf@redhat.com>
	<87ziz91xag.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 23 Oct 2015 10:26:06 -0400
In-Reply-To: <87ziz91xag.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Fri, 23 Oct 2015 17:20:39 +0300")
Message-ID: <wrfj611xhda9.fsf@redhat.com> (sfid-20151023_162613_544872_566719C8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>
>> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
>>>
>>> There is overlap of devices between rtl8xxxu and rtl8192cu:
>>> USB_VENDER_ID_REALTEK, 0x8176
>>> USB_VENDER_ID_REALTEK, 0x8178
>>> USB_VENDER_ID_REALTEK, 0x817f
>>> 0x7392, 0x7811
>>
>> Yes
>
> What, are you saying that you didn't fix that? I did say in the last
> review round that we should not have duplicated device entries within
> drivers/net/wireless and I assumed you took care of that.
>
>> and there is also a clash with USB IDs between
>> drivers/staging/rtl8192u and drivers/net/wireless/realtek/rtlwifi -
>> this is nothing new.
>
> We should do things properly in under drivers/, I don't care what
> happens in staging and that's no excuse to do things badly.

As I explained earlier, there is no way I can do that unless we remove
rtlwifi's rtl8192cu driver and that cannot happen due to the feature
differences. There are plenty of other conflicts and this is not a bug.

In other words I *have* done things correctly here, and Xose's complaint
is bogus.

Jes
