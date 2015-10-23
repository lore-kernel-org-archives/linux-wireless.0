Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50453 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbbJWOUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2015 10:20:46 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: overlap of devices in rtl8xxxu and rtl8192cu
References: <562A2711.9040700@gmail.com> <wrfj7fmdit3l.fsf@redhat.com>
Date: Fri, 23 Oct 2015 17:20:39 +0300
In-Reply-To: <wrfj7fmdit3l.fsf@redhat.com> (Jes Sorensen's message of "Fri, 23
	Oct 2015 09:59:10 -0400")
Message-ID: <87ziz91xag.fsf@kamboji.qca.qualcomm.com> (sfid-20151023_162049_693220_1FE27636)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Xose Vazquez Perez <xose.vazquez@gmail.com> writes:
>>
>> There is overlap of devices between rtl8xxxu and rtl8192cu:
>> USB_VENDER_ID_REALTEK, 0x8176
>> USB_VENDER_ID_REALTEK, 0x8178
>> USB_VENDER_ID_REALTEK, 0x817f
>> 0x7392, 0x7811
>
> Yes

What, are you saying that you didn't fix that? I did say in the last
review round that we should not have duplicated device entries within
drivers/net/wireless and I assumed you took care of that.

> and there is also a clash with USB IDs between
> drivers/staging/rtl8192u and drivers/net/wireless/realtek/rtlwifi -
> this is nothing new.

We should do things properly in under drivers/, I don't care what
happens in staging and that's no excuse to do things badly.

-- 
Kalle Valo
