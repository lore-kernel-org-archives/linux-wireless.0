Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34702 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbbJWRHr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 13:07:47 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
References: <562A2711.9040700@gmail.com> <wrfj7fmdit3l.fsf@redhat.com>
	<87ziz91xag.fsf@kamboji.qca.qualcomm.com>
	<wrfj611xhda9.fsf@redhat.com>
Date: Fri, 23 Oct 2015 20:07:37 +0300
In-Reply-To: <wrfj611xhda9.fsf@redhat.com> (Jes Sorensen's message of "Fri, 23
	Oct 2015 10:26:06 -0400")
Message-ID: <87oafp1pk6.fsf@kamboji.qca.qualcomm.com> (sfid-20151023_190750_573921_BFACE5AE)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Kalle Valo <kvalo@codeaurora.org> writes:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>
>>> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
>>>>
>>>> There is overlap of devices between rtl8xxxu and rtl8192cu:
>>>> USB_VENDER_ID_REALTEK, 0x8176
>>>> USB_VENDER_ID_REALTEK, 0x8178
>>>> USB_VENDER_ID_REALTEK, 0x817f
>>>> 0x7392, 0x7811
>>>
>>> Yes
>>
>> What, are you saying that you didn't fix that? I did say in the last
>> review round that we should not have duplicated device entries within
>> drivers/net/wireless and I assumed you took care of that.
>>
>>> and there is also a clash with USB IDs between
>>> drivers/staging/rtl8192u and drivers/net/wireless/realtek/rtlwifi -
>>> this is nothing new.
>>
>> We should do things properly in under drivers/, I don't care what
>> happens in staging and that's no excuse to do things badly.
>
> As I explained earlier, there is no way I can do that unless we remove
> rtlwifi's rtl8192cu driver and that cannot happen due to the feature
> differences. There are plenty of other conflicts and this is not a bug.

Like I said earlier in rtl8xxxu review, I don't want to have two drivers
supporting the same device. So either rtl8xxxu or rtlwifi supports the
devices above, not both. And to my knowledge rtl8xxxu is still lacking
in features, and it's a new driver, so it's best that rtlwifi continues
to support these for the time being. Once rtl8xxxu catches up and we
have a clear consensus we can make the switch.

I'll send a patch in a jiffy, merge window is getting closer so we don't
have any extra time.

-- 
Kalle Valo
