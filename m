Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbcGIPwQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 11:52:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 3/4] rtl8xxxu: Mark 0x20f4:0x648b as tested
References: <1466706955-10339-1-git-send-email-Jes.Sorensen@redhat.com>
	<1466706955-10339-4-git-send-email-Jes.Sorensen@redhat.com>
	<87h9c42nrh.fsf@kamboji.qca.qualcomm.com>
Date: Sat, 09 Jul 2016 11:52:11 -0400
In-Reply-To: <87h9c42nrh.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
	of "Tue, 05 Jul 2016 16:54:58 +0300")
Message-ID: <wrfjshvin710.fsf@redhat.com> (sfid-20160709_175220_930410_E1812738)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@codeaurora.org> writes:
> Jes.Sorensen@redhat.com writes:
>
>> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>>
>> Successfully tested by Jocelyn Mayer
>>
>> Reported-by: J. Mayer <l_indien@magic.fr>
>> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
>> ---
>>  drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 9 +++++++--
>>  1 file changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> index cfa5528..90d21c3 100644
>> --- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> +++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
>> @@ -5852,6 +5852,10 @@ static int rtl8xxxu_probe(struct usb_interface *interface,
>>  		if (id->idProduct == 0x1004)
>>  			untested = 0;
>>  		break;
>> +	case 0x20f4:
>> +		if (id->idProduct == 0x648b)
>> +			untested = 0;
>> +		break;
>>  	default:
>>  		break;
>>  	}
>> @@ -6021,6 +6025,9 @@ static struct usb_device_id dev_table[] = {
>>  /* Tested by Andrea Merello */
>>  {USB_DEVICE_AND_INTERFACE_INFO(0x050d, 0x1004, 0xff, 0xff, 0xff),
>>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>> +/* Tested by Jocelyn Mayer */
>> +{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>>  /* Currently untested 8188 series devices */
>>  {USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x8191, 0xff, 0xff, 0xff),
>>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>> @@ -6080,8 +6087,6 @@ static struct usb_device_id dev_table[] = {
>>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>>  {USB_DEVICE_AND_INTERFACE_INFO(0x2019, 0xed17, 0xff, 0xff, 0xff),
>>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>> -{USB_DEVICE_AND_INTERFACE_INFO(0x20f4, 0x648b, 0xff, 0xff, 0xff),
>> -	.driver_info = (unsigned long)&rtl8192cu_fops},
>>  {USB_DEVICE_AND_INTERFACE_INFO(0x4855, 0x0090, 0xff, 0xff, 0xff),
>>  	.driver_info = (unsigned long)&rtl8192cu_fops},
>>  {USB_DEVICE_AND_INTERFACE_INFO(0x4856, 0x0091, 0xff, 0xff, 0xff),
>
> But will this now conflict with rtlwifi?
>
> drivers/net/wireless/realtek/rtlwifi/rtl8192cu/sw.c:
> {RTL_USB_DEVICE(0x20f4, 0x648b, rtl92cu_hal_cfg)}, /*TRENDnet -
> Cameo*/
>
> Like discussed before, I don't like having two drivers support same
> hardware and users more or less randomly using either of them.

Same procedure as last time - these are still listed under UNTESTED so
only get configured it people explicitly enable them.

There is no change here from how the code was prior.

Jes
