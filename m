Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51310 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1KDK1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Nov 2011 06:27:08 -0400
Received: by wwi36 with SMTP id 36so3251692wwi.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Nov 2011 03:27:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4EB333E1.6000508@lwfinger.net>
References: <48883.148.106.128.38.1320319313.metamail@webmail.meta.ua>
	<4EB2AF44.7090102@lwfinger.net>
	<CACna6rx5eZ+JsS+X=FyPFo9J1+=tkzsujHMHCPFPY=+O_yxS1Q@mail.gmail.com>
	<4EB333E1.6000508@lwfinger.net>
Date: Fri, 4 Nov 2011 11:27:06 +0100
Message-ID: <CACna6ryKdReeSAP6W=PYBT3LnFBe-iL3daKFFxzK56TFNUW+Qw@mail.gmail.com> (sfid-20111104_112713_382761_EFCDC812)
Subject: Re: b43 scans wifi networks with old firmware only.
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <greg@kroah.com>, Larry Finger <Larry.Finger@lwfinger.net>
Cc: roman-vl@meta.ua, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 4 listopada 2011 01:37 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 11/03/2011 05:37 PM, Rafał Miłecki wrote:
>>
>> 2011/11/3 Larry Finger<Larry.Finger@lwfinger.net>:
>>>
>>> On 11/03/2011 06:21 AM, Roman V.Leon. wrote:
>>>>
>>>> Hello Gents.
>>>> I have problem with b43 driver 5.100.138, it's not scanning networks for
>>>> unknown reason. I have broadcom wifi card PCIID is 14e4:4315, linux kern
>>>> ver. is 3.0. When i'm trying to launch iwlist scan, i'm getting "no scan
>>>> results".
>>>>
>>>> for example:
>>>> sudo ifconfig wlan0 up
>>>> sudo iwlist wlan0 scan
>>>>     No scan results.
>>>>
>>>> With the older driver 5.10.56.2808, i see normal scan results. If you
>>>> need
>>>> any more information, i will send.
>>>
>>> The condition you report is known. Broadcom changed the TX/RX header
>>> structure with firmware versions greater than 600, as shown by a 'dmesg |
>>> grep firmware'. Those changes are not implemented in b43 until kernel
>>> 3.2.
>>>
>>> These numbers are not b43 driver numbers, nor are they firmware numbers
>>> reported by b43. They are the versions of Broadcom drivers.
>>>
>>> If you look at
>>> http://wireless.kernel.org/en/users/Drivers/b43#firmwareinstallation, you
>>> will see that firmware should be extracted from Broadcom driver 5.100.138
>>> "if you are using kernel 3.2 or newer". For older kernels you should
>>> extract
>>> firmware from the 5.10.56.27.3 of the Broadcom proprietary driver. Of
>>> course, 5.10.56.2808 will also work.
>>>
>>>  You could also get those changes by employing a bleeding-edge version of
>>> compat-wireless. In that case, firmware from 5.100.138 would work.
>>
>> Should we/can we send patch for at least 3.0.x and 3.1.x kernels
>> adding error on loading too new firmware?
>
> I think adding an error would have been appropriate. We certainly cannot
> prevent versionitis; however, getting a patch into those kernels that is not
> in mainline might be a problem.

Greg: the problem with b43 happens when kernels 3.1- users install
firmware supported by kernels 3.2+.

Is this possible to grab some separated patch for that older kernels?
The ideal way to do this was:
1) Commit error enabling patch with Cc: stable
2) Add support for new firmwares
3) Drop error
Unfortunately I didn't think about that, now it's too late.

-- 
Rafał
