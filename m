Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56328 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752694Ab3FZR3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 13:29:50 -0400
Received: by mail-ee0-f48.google.com with SMTP id b47so7470222eek.21
        for <linux-wireless@vger.kernel.org>; Wed, 26 Jun 2013 10:29:49 -0700 (PDT)
Message-ID: <51CB250A.3060900@gmail.com> (sfid-20130626_192954_336095_6577E0ED)
Date: Wed, 26 Jun 2013 19:29:46 +0200
From: "shiki.biomernok" <shiki.biomernok@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Fwd: Re: TP-Link 8200ND - rtl8192cu module not loading / working
References: <51A77433.2060702@lwfinger.net> <51CAD0B8.3010303@gmail.com> <51CB1356.80306@lwfinger.net>
In-Reply-To: <51CB1356.80306@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry/Mailing list!

I have compiled and installed the new wireless-testing kernel from git.
I'm sure I used the new kernel, as the device lighted up as soon as I 
plugged in. (And I got some new atheros ac module at "make oldconfig".)
There was no need for manual echo or modprobe.

Yet, the device is not working. It dies at the very same step.
Here is the dmesg: http://pastebin.com/C1MNdFiw

Please, let me know if I can help with anything.
Any debug option, patch or things like that.

My offer is still there Larry, I'm willing to give you a full SSH access 
to the machine with this stuff plugged in.
Besides that, I have no other idea.


! My router runs OpenWRT (latest stable), so I could also gather info 
from there. If it's possible.
(I checked dmesg but there is nothing. Only some non-crucial info about 
the generic eth ports and such.)

Thank you for the help.

(By the way if the chip is rare (no other people will benefit), then I 
can just get it back and ask for a refund. But if others use it as well, 
then it's not a waste of time... I guess.)

On 2013-06-26 18:14, Larry Finger wrote:
> On 06/26/2013 06:30 AM, shiki.biomernok wrote:
>> Hello everyone!
>>
>> CC'ing my original message that I sent to Larry.
>> It's been a while, but I've been busy and I couldn't fiddle with the 
>> wireless
>> device.
>>
>> Basically it's a 8192cu device. Larry suspected it's not, but I think 
>> he saw the
>> advertisement displayed on top of the TP-Link page.
>> I even mailed TP-Link, and here is the reply:
>>
>>     The chipset is Realtek RTL8192CU and you can download the driver
>>     from
>>
>> http://www.realtek.com/downloads/downloadsView.aspx?Langid=1&PNid=21&PFid=48&Level=5&Conn=4&DownTypeID=3&GetDown=false&Downloads=true. 
>>
>>
>>     Thank you.
>>
>> Tested with many kernels, but none of them worked.
>> Ubuntu 13.04 (both stock + updated), Fedora (Schrodinger-1), Fedora Beta
>> (Schrodinger), openSUSE (normal+tumbleweed).
>> I even tried the latest kernels since 3.10-rc4. (latest I tried is -rc7)
>>
>> Basically this device *should* work with the 8192cu driver, but it 
>> just won't.
>> If you just plug it in, nothing happens.
>> You have to first:
>> $ modprobe 8192cu
>> $ echo 2357 0100 > /sys/bus/usb/drivers/rtl8192cu/new_id
>>
>> Then it lights up, it shows up in NM-Applet. But it won't work.
>> I tried enabling the realtek debug option at the kernel driver, but 
>> it didn't help.
>> Even with that, I only see the authentication failed messages.
>>
>> Dmesg shows the errors: http://pastebin.com/QCfXYCZ1
>>
>>
>> Hope you guys can come up with some tips/ideas.
>> Ps.: I hope you don't mind the CC Larry.
>
> No, that is what I told you to do.
>
> A patch has been submitted to add that device to the USB_DEVICE table. 
> It is included in the wireless-testing git tree, but it is not in the 
> mainline code (yet). After that patch was applied, the device worked 
> for that reported.
>
> I noticed that you are getting an oops from iwlwifi, and an ehci-hcd 
> error. Are you also exploring these problems?
>
> If possible, could you use the wireless-testing repo? That will get 
> you the latest code for all wireless drivers, and the USB code will 
> match mainline.
>
> Larry
>
>

