Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f198.google.com ([209.85.221.198]:42651 "EHLO
	mail-qy0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZHZVkh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 17:40:37 -0400
Received: by qyk36 with SMTP id 36so225329qyk.22
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 14:40:39 -0700 (PDT)
Message-ID: <4A95AA64.20502@gmail.com>
Date: Wed, 26 Aug 2009 17:34:28 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: John W Linville <linville@tuxdriver.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix for kernel oops when unloading with LEDs
 enabled
References: <4a5cf0b4.F1C7R/E9sD5tpPd2%Larry.Finger@lwfinger.net> <4A94B01E.9040309@gmail.com> <4A94C3E9.6070409@lwfinger.net>
In-Reply-To: <4A94C3E9.6070409@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> Richard Farina wrote:
>   
>> Larry Finger wrote:
>>     
>>> When rtl8187 is unloaded and CONFIG_RTL8187_LEDS is set, the kernel
>>> may oops when the module is unloaded as the workqueue for led_on was
>>> not being cancelled.
>>>
>>> This patch fixes the problem reported in
>>> http://marc.info/?l=linux-wireless&m=124742957615781&w=2.
>>>
>>> Reported-by: Gábor Stefanik <netrolller.3d@gmail.com>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger>
>>> ---
>>>
>>> V2 - Do not create a new workqueue.
>>>
>>> John,
>>>
>>> This patch is 2.6.31 material. To the best of my knowledge, a formal bug
>>> report was never filed; however, it was reported in the reference
>>> given above.
>>>
>>>   
>>>       
>> Anyone know what happened here? This bug still seems very much alive in
>> compat-wireless-2.6.31-rc7.  I know the window is closed and this really
>> isn't "earthshattering" but a kernel panick is kind of "a big deal".  I
>> seems like it was tested doing a proper modprobe -r but not if you just
>> unplug the usb card.
>>     
>
> This kind of accusation is not the best way to get your problem solved.
>
>   
I apologize if you thought there was an accusation here, that certainly 
was not my intention. With all due respect assuming that I'm
a jerk is neither safe nor polite.  In your original patch for this I 
find the following text:

"Gábor,

I hope this version of the patch fixes your problem. On my system
I ran more than 20 rmmod/insmod cycles without a problem.

Larry"

My assumption in your testing manner was based only on what you said and the kernel panick I still experience

>> When I unplug the usb I get instadeath, very uncool.  If someone can
>> teach me how to get the kernel output from a non-functional system I am
>> happy to provide whatever.
>>     
>
> This patch has been in wireless testing since August 3. I have no idea
> why it wouldn't be in compat-wireless since then. In addition, I have
> unplugged/plugged my RTL8187B device many times with no problem.
>
> I just downloaded compat-wireless-2009-08-26 - it has the patch
> included. You certainly could have checked your source to determine that.
>
>   
Yes, I realize that, which is why I said the "bug is still alive" not 
"the patch is not applied".  I even went out of my way to describe how 
the testing was different...
> To get something from a system that is crashing, you should switch to
> the logging console by pressing CTRL/ALT/F10 before you do whatever it
> takes to crash it. You will not get a full dump, but hopefully, there
> will be enough of the stack visible when the panic occurs. Either copy
> down the stack list, or take a picture of the screen and post a link
> to it. FYI, you can get back to the graphical screen with CTRL/ALT/F7.
>
> If you have a wired connection in addition to the wireless one, and
> you have a second Linux host, you can also capture the dump using
> netconsole. Using this facility is not easy, so we'll go the other
> route first.
>
> When you report what info you have, please tell what architecture you
> are running (i386, x86_64, ppc,...) and whether your device is an
> RTL8187L or RTL8187B. It may not matter, but who knows.
>
>   
I will attempt to reproduce and take a picture with both x86 and x86_64, 
and I'll look into netconsole because that sounds very useful.

Thanks for the assistance,
Rick Farina

> Larry
>
>
>   

