Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f43.google.com ([209.85.161.43]:65165 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab0LNVyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Dec 2010 16:54:22 -0500
Received: by fxm18 with SMTP id 18so1297159fxm.2
        for <linux-wireless@vger.kernel.org>; Tue, 14 Dec 2010 13:54:21 -0800 (PST)
Message-ID: <4D07E7A9.5010207@lwfinger.net>
Date: Tue, 14 Dec 2010 15:54:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Eduardo Costa <ecosta.tmp@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: another device working
References: <AANLkTimQQ5dbFjiZD993OGTHp8Qvb9+N6n4ZhGuG3HTQ@mail.gmail.com> <4D07D678.8030903@lwfinger.net> <1292361712.26726.31.camel@Joe-Laptop> <20101214213348.GD2389@tuxdriver.com>
In-Reply-To: <20101214213348.GD2389@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/14/2010 03:33 PM, John W. Linville wrote:
> On Tue, Dec 14, 2010 at 01:21:52PM -0800, Joe Perches wrote:
>> On Tue, 2010-12-14 at 14:41 -0600, Larry Finger wrote:
>>> On 12/14/2010 11:09 AM, Eduardo Costa wrote:
>>>>  {USB_DEVICE (0x15a9, 0x0002)},   /* Gemtek WUBI-100GW 802.11g */
>>>> And about the firmware, it does work with stock p54's
>>>> `2.13.24.0.lm87.arm' found on the website, so I just had to copy it to
>>>> `/lib/firmware' while renaming it to `isl3887usb'.
>>> Thanks for the report. I just submitted a patch to wireless-testing with a copy
>>> to you for this change to be included in kernel 2.6.37, and to be backported to
>>> all stable and long-term kernels.
>>
>> Perhaps it'd be sensible to add a
>> module_param option like usb_device=x,y
>> so new devices could be supported without recompilation.
> 
> Isn't that what new_id is for?
> 
> At any rate, it isn't a great substitute for a device id in the driver's table. :-)

NACK on any attempt to add the above module option. Having new_id is fine for
testing, but John is right that there is no substitute for testing and updating
the driver's table as it "just works" for any user. For p54usb, the user still
needs to install the firmware, but having the device recognized is a big step.

Larry
