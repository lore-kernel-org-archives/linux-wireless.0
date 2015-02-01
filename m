Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35833 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbbBAX2o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Feb 2015 18:28:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAKXHbyP10uukO7Y54OBTvWPUZ6RiVpG=8BcppzxfnJOMg+Mobw@mail.gmail.com>
References: <1422717177-5865-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <wrfjfvap1bk6.fsf@redhat.com> <CAKXHbyP10uukO7Y54OBTvWPUZ6RiVpG=8BcppzxfnJOMg+Mobw@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 2 Feb 2015 10:28:22 +1100
Message-ID: <CAGRGNgUDQWKLyj=U72iNmGQZVfushx2OR=qsjqQQ5C+LJirLQg@mail.gmail.com> (sfid-20150202_002900_711425_BC8AB2CC)
Subject: Re: [PATCH] staging: rtl8723au: hal: usb_ops_linux: Removed variables
 that is never used
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Joe Perches <joe@perches.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Rickard,

On Mon, Feb 2, 2015 at 10:17 AM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> 2015-02-02 0:01 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
>> Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> writes:
>>> Variable was assigned a value that was never used.
>>> I have also removed all the code that thereby serves no purpose.
>>>
>>> This was found using a static code analysis program called cppcheck
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/staging/rtl8723au/hal/usb_ops_linux.c |    9 +++------
>>>  1 file changed, 3 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/staging/rtl8723au/hal/usb_ops_linux.c b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>>> index a6d16ad..4ae0a8a 100644
>>> --- a/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>>> +++ b/drivers/staging/rtl8723au/hal/usb_ops_linux.c
>>> @@ -26,11 +26,10 @@ u8 rtl8723au_read8(struct rtw_adapter *padapter, u16 addr)
>>>  {
>>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>>> -     int len;
>>>       u8 data;
>>>
>>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>>                             addr, 0, &pdvobjpriv->usb_buf.val8, sizeof(data),
>>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>>> @@ -45,11 +44,10 @@ u16 rtl8723au_read16(struct rtw_adapter *padapter, u16 addr)
>>>  {
>>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>>> -     int len;
>>>       u16 data;
>>>
>>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>>                             addr, 0, &pdvobjpriv->usb_buf.val16, sizeof(data),
>>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>>> @@ -64,11 +62,10 @@ u32 rtl8723au_read32(struct rtw_adapter *padapter, u16 addr)
>>>  {
>>>       struct dvobj_priv *pdvobjpriv = adapter_to_dvobj(padapter);
>>>       struct usb_device *udev = pdvobjpriv->pusbdev;
>>> -     int len;
>>>       u32 data;
>>>
>>>       mutex_lock(&pdvobjpriv->usb_vendor_req_mutex);
>>> -     len = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>> +     usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
>>>                             REALTEK_USB_VENQT_CMD_REQ, REALTEK_USB_VENQT_READ,
>>>                             addr, 0, &pdvobjpriv->usb_buf.val32, sizeof(data),
>>>                             RTW_USB_CONTROL_MSG_TIMEOUT);
>>
>> Again, fix the formatting if you want to make this change.
>>
>> NACK
>>
>> Jes
>
>
> Hi
>
> I am sorry, please ignore this.
> I will not send any more patches.

The issue isn't you sending patches, the issue is that you don't spend
enough time on them.

As I understand it, the formatting for function calls is that if the
arguments flow onto a new line, they start in the column after the
opening bracket of the function call.

I.e.

do_something(arg, arg, arg,
/* 13 cols */arg, arg, arg);

(Using tabs and spaces instead of the comment of course)

In this case, you're dropping 6 characters from the line with the
function call. You then need to re-flow the arguments to suit.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
