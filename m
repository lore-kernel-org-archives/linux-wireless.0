Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:39051 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751697AbdKTRNz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Nov 2017 12:13:55 -0500
Received: by mail-ot0-f170.google.com with SMTP id v15so8226555ote.6
        for <linux-wireless@vger.kernel.org>; Mon, 20 Nov 2017 09:13:55 -0800 (PST)
Subject: Re: Question on a RTL8812AU driver
To: James Hughes <james.hughes@raspberrypi.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
References: <CAE_XsML9q6=viKqG2TQCEb921reZBFuRC7=_vy87VDNqD5ONww@mail.gmail.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <97422981-e0ea-850f-beed-87dc6033cc0a@lwfinger.net> (sfid-20171120_181400_086078_37524072)
Date: Mon, 20 Nov 2017 11:13:53 -0600
MIME-Version: 1.0
In-Reply-To: <CAE_XsML9q6=viKqG2TQCEb921reZBFuRC7=_vy87VDNqD5ONww@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/20/2017 10:39 AM, James Hughes wrote:
> Hello all,
> 
> I know there been a lot of work done on Realtek drivers in the last
> few months, and was wondering whether this will be of use for my
> particular issue.
> 
> We have a Raspberry Pi that needs to use a USB wireless adaptor
> (2001:3314) which uses the rtl8812AU chipset. We have to use this
> device as it's the only one that has been qualified for this
> particular use case.
> 
> We have been using an out of tree driver, I think originally from
> Realtek, that works, but after a few days locks up, and often requires
> a reboot on the Pi. We do have some mitigation strategies, but it'
> would be better to have a working driver. The Pi is, on the whole,
> inaccessible.
> 
> The OoT driver is from here
> https://github.com/diederikdehaas/rtl8812AU and appear quite ancient.
> 
> So, I've been looking at the 4.14 staging drivers that do seem to have
> support for some realtek devices. However, none of the drivers I have
> built recognise the module. The source of rtlwifi does refer to the
> 8812AU, but only to ignore it. There are other references throughout
> the source.,
> 
> My question, eventually, is down to figuring out whether any of the
> new staging code is destined to work on this device, or am I going to
> have to stick with the driver we are currently using which clearly has
> a lockup issue that I, in all likelihood, not going to be able to
> track down since its takes days for it to occur.
> 
> Or if anyone has any suggestions for getting this working, I'm all ears.

To my knowledge, there are no plans to convert the buggy, and badly written, 
code for the RTL8812AU into a form that would be suitable for wireless. Even 
getting it into a form that would be acceptable for staging would be a 
formidable task.

If you want this device supported by an in-kernel driver, the easiest method 
would be to extend rtl8xxxu. Jes Sorensen, the author of that driver, might be 
able to help you with that extension.

I know nothing of that "diederikdehaas" repo; however, I have a separate one at 
https://github.com/lwfinger/rtl8812au that I keep up to date. Note that I do not 
have such a device. The repo is just for convenience.

Larry
