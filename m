Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54933 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1DLOe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2011 10:34:28 -0400
Received: by vws1 with SMTP id 1so5086548vws.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2011 07:34:27 -0700 (PDT)
Message-ID: <4DA462F0.6090105@lwfinger.net>
Date: Tue, 12 Apr 2011 09:34:24 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2800usb: Add three new USB IDs
References: <4DA1E4ED.6080804@gmail.com> <20110411175810.GB2511@tuxdriver.com> <4DA43D3F.60204@gmail.com>
In-Reply-To: <4DA43D3F.60204@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/12/2011 06:53 AM, Xose Vazquez Perez wrote:
> On 04/11/2011 07:58 PM, John W. Linville wrote:
>
>> On Sun, Apr 10, 2011 at 07:12:13PM +0200, Xose Vazquez Perez wrote:
>>> Larry Finger wrote:
>>>
>>>> There are three USB IDs supported by staging/rt2870sta that are not in the
>>>> mainline driver rt2800usb.
>>>>
>>>> Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
>>>> Cc: Stable<stable@vger.kernel.org>
>>>> ---
>>>>
>>>> Index: wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> ===================================================================
>>>> --- wireless-testing.orig/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> +++ wireless-testing/drivers/net/wireless/rt2x00/rt2800usb.c
>>>> @@ -758,6 +758,8 @@ static struct usb_device_id rt2800usb_de
>>>> { USB_DEVICE(0x07d1, 0x3c0f), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> { USB_DEVICE(0x07d1, 0x3c11), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> { USB_DEVICE(0x07d1, 0x3c16), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> + { USB_DEVICE(0x2001, 0x3c09), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> + { USB_DEVICE(0x2001, 0x3c0a), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> /* Draytek */
>>>> { USB_DEVICE(0x07fa, 0x7712), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> /* Edimax */
>>>> @@ -828,6 +830,7 @@ static struct usb_device_id rt2800usb_de
>>>> /* Planex */
>>>> { USB_DEVICE(0x2019, 0xab25), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> { USB_DEVICE(0x2019, 0xed06), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> + { USB_DEVICE(0x2019, 0xed14), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> /* Quanta */
>>>> { USB_DEVICE(0x1a32, 0x0304), USB_DEVICE_DATA(&rt2800usb_ops) },
>>>> /* Ralink */
>>>
>>> NACK, unless they also be in the windows driver.
>>> They were eliminated in recent versions of ralink LiNUX drivers.
>>
>> OK, I already had this merged since Ivo and Gertjan had ACKed it.
>>
>> I need to rebase wireless-2.6 anyway, so I'll drop this one too
>> for now. Please come to a consensus on whether or not these should
>> be included and let me know...
>
> I did a search of 0x2001,0x3c09 0x2001,0x3c0a and 0x2019,0xed14 in
> latest windows drivers:
> USB (RT2870 /RT2770 /RT307X /RT2070 /RT357X /RT3370 /RT8070 /RT5370) 12/31/2010
> 3.1.8.0
> IS_AP_STA_RT2870_D-3.1.8.0_VA-3.1.8.0_W7-3.1.8.0_RU-4.0.4.0_AU-4.0.4.0_123110_1.5.11.0WP_Free.exe
>
> and I didn't find any of them
>
> Also I checked latest linux drivers:
> 2010_0709_RT2870_Linux_STA_v2.4.0.1.tar.bz2
> 2010_1215_RT3572_Linux_STA_v2.5.0.0.DPO.bz2
> 2011_0107_RT3070_RT3370_Linux_STA_v2.5.0.1_DPO.tar.bz2
> and there is no vestige of any of them.
>
> NACK.

John,

Kill the patch. It appears these are phantom devices, or their original 
inclusion was a mistake.

Thanks,

Larry
