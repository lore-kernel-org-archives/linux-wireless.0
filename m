Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:61681 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbZDLE5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Apr 2009 00:57:40 -0400
Received: by bwz17 with SMTP id 17so1626719bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 11 Apr 2009 21:57:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E0C713.4040507@lwfinger.net>
References: <49dd785f.mp1oc4nY+m3n0uHL%Larry.Finger@lwfinger.net>
	 <3ace41890904091453o158f5c00ldad58da3d002180e@mail.gmail.com>
	 <49DE7E42.5020700@lwfinger.net>
	 <3ace41890904102123o3e280edau933c8235649879c5@mail.gmail.com>
	 <3ace41890904102129n2b62001clff35027088bedcd1@mail.gmail.com>
	 <49E0C713.4040507@lwfinger.net>
Date: Sun, 12 Apr 2009 05:57:38 +0100
Message-ID: <3ace41890904112157r2037946xddd8fca9222fd97e@mail.gmail.com> (sfid-20090412_065746_474811_BF903E8A)
Subject: Re: [RFT/RFC] rtl8187: Implement TX/RX blink for LED
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 11, 2009 at 5:36 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hin-Tak Leung wrote:
>> On Sat, Apr 11, 2009 at 5:23 AM, Hin-Tak Leung <hintak.leung@gmail.com> wrote:
>>
>> Oh, I forgot to mention that to test this code against
>> compat-wireless, appending "CONFIG_RTL8187_LEDS=y" to config.mk does
>> the job.
>>
>> I am wonder if we actually needs an extra Kconfig for this - at least
>> in my case, the code has no ill effect with device which hasn't got an
>> RX/TX LED. (other than possibly a small theoretical performance loss
>> from do extra non-useful work).
>
> I do have to compile the LED code only if the kernel has support for them,
> otherwise the registration entry points would be missing. The necessary
> conditions would be more complicated, thus I put them in one place in the
> Kconfig and let the source only be dependent on CONFIG_RTL8187_LEDS.

Thanks for the explanation. Depending (silently) on other kernel
requirements is certainly fine.
I am just thinking we can keep it simple, and wondering if we need
another user-configurable option.

BTW, I had a hard lock-up on suspend - it hasn't happened for
months... while the module doesn't suspend properly, I have
unload-on-sleep configured and it has work mostly fine for some
months.  The vendor code is quite lacking in suspend/resume support,
and if you are going to prepare another iteration of the LED patch,
please give this a thought.
on possible problem with this.
