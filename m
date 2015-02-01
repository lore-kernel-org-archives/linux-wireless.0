Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34940 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbbBAXRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:17:34 -0500
Received: by mail-ie0-f174.google.com with SMTP id vy18so14162982iec.5
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:17:33 -0800 (PST)
Received: from mail-ie0-f177.google.com (mail-ie0-f177.google.com. [209.85.223.177])
        by mx.google.com with ESMTPSA id x3sm5065087ioi.34.2015.02.01.15.17.32
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 01 Feb 2015 15:17:32 -0800 (PST)
Received: by mail-ie0-f177.google.com with SMTP id vy18so14123074iec.8
        for <linux-wireless@vger.kernel.org>; Sun, 01 Feb 2015 15:17:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjfvap1bk6.fsf@redhat.com>
References: <1422717177-5865-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<wrfjfvap1bk6.fsf@redhat.com>
Date: Mon, 2 Feb 2015 00:17:32 +0100
Message-ID: <CAKXHbyP10uukO7Y54OBTvWPUZ6RiVpG=8BcppzxfnJOMg+Mobw@mail.gmail.com> (sfid-20150202_001749_992598_D8178EEC)
Subject: Re: [PATCH] staging: rtl8723au: hal: usb_ops_linux: Removed variables
 that is never used
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-02-02 0:01 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>> Variable was assigned a value that was never used.
>> I have also removed all the code that thereby serves no purpose.
>>
>> This was found using a static code analysis program called cppcheck
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/hal/usb_ops_linux.c |    9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>> index a6d16ad..4ae0a8a 100644
>> --- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>> +++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>> @@ -26,11 +26,10 @@ u8 rtl8723au_read8(struct rtw_adapter *padapter, u16 addr)
>>  {
>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>> -     int len;
>>       u8 data;
>>
>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>                             addr, 0, &pdvobjpriv->usb_buf.val8, sizeof(data),
>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>> @@ -45,11 +44,10 @@ u16 rtl8723au_read16(struct rtw_adapter *padapter, u16 addr)
>>  {
>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>> -     int len;
>>       u16 data;
>>
>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>                             addr, 0, &pdvobjpriv->usb_buf.val16, sizeof(data),
>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>> @@ -64,11 +62,10 @@ u32 rtl8723au_read32(struct rtw_adapter *padapter, u16 addr)
>>  {
>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>> -     int len;
>>       u32 data;
>>
>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>                             addr, 0, &pdvobjpriv->usb_buf.val32, sizeof(data),
>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>
> Again, fix the formatting if you want to make this change.
>
> NACK
>
> Jes


Hi

I am sorry, please ignore this.
I will not send any more patches.

Kind regards
Rickard Strandqvist
