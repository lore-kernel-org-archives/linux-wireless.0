Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:56139 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759801AbZKFWRW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:17:22 -0500
Received: by ewy3 with SMTP id 3so1534811ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:17:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <200911062245.51445.chunkeey@googlemail.com>
References: <167ae39b0910071400n218d3d9ey7711b1011f290a73@mail.gmail.com>
	 <200911062133.38842.chunkeey@googlemail.com>
	 <167ae39b0911061252x790d69fei9e798e8c6080f175@mail.gmail.com>
	 <200911062245.51445.chunkeey@googlemail.com>
Date: Fri, 6 Nov 2009 16:17:26 -0600
Message-ID: <167ae39b0911061417y3628d8a4ub8f8d3eaae3c971a@mail.gmail.com>
Subject: Re: Prism54/p54pci
From: James Grossmann <cctsurf@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sorry I forgot about that, I'm using a wrt54gs 1.0 with dd-wrt
(legacy, if I remember correctly -- DD-WRT v24 (05/20/08) vpn - build
9517M Eko ) firmware.  Uptime of 4 days, it has had its problems, but
not so much of recent, the wireless was crashing fairly often a while
back, but I last rebooted it before that 2 months ago.
I've been using it without any wep/wpa of recent, I ran into some
access devices that were fighting with it, and in the small town I
live in, I doubt anyone else knows enough about computers to hack
wifi...I hope...haven't seen anything in the logs.
Hope that's helpful
James

On Fri, Nov 6, 2009 at 3:45 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Friday 06 November 2009 21:52:42 James Grossmann wrote:
>> my caps lock & scroll lock leds are not blinking, and yet the computer
>> is frozen.  (I'm not the best at terminology, I guess that might not
>> be defined as a hard lock.)  I get no odd messages in my syslog.  I am
>> using Ubuntu right now, so I'm guessing that they have all the
>> prettyness going that they can, covering the important messages, but
>> as it's not an actual oops, I'm not certain that's hurting us.
>
> Ubuntu's kernel team provide some helpful texts about getting more
> informations out of the crashes: (a bit of a hassle)
> https://wiki.ubuntu.com/KernelTeam/CrashdumpRecipe
> https://help.ubuntu.com/community/DebuggingSystemCrash
>
> but maybe you can save you some time:
> 1. if possible update your compat-wireless
>   a crash bug (affects compat-wireless, wireless-testing and even -rcX series)
>   has been fixed. This bug is known to strike on configurations with a
>   high number of auth/assoc/deauth - cycles.
>
>        http://thread.gmane.org/gmane.linux.kernel/908831/focus=41872
>
> 2. Quintin Pitts had/has problems with the reliability of his
>   p54pci <-> pci-bus and wrote a patch:
>       http://patchwork.kernel.org/patch/53004/raw/
>
>    unfortunately for him, his pci-bridge is known to be faulty,
>    but maybe he found some real bugs after all.
>
> 3. replace firmware:
>        http://daemonizer.de/prism54/prism54-fw/fw-softmac/2.13.1.0.arm
>        http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm
>
>> I am using network-manager, so it does reconnect, however, I find that
>> to be less than optimal.
> yeah, normally you can see such phenomena when you have a funky AP and
> enable wifi powersaving... but this is unlikely, as the ps is disabled
> (can be enabled with iwconfig wlanX power on) for this reason.
>
> can you please tell me more about your AP?
> e.g: Product Name, Vendor, firmware revision,
> is it 802.11 a/b/g/n, is WEP/WPA(2) enabled, or is it just an open ap?
>
