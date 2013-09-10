Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:43625 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab3IJPOd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 11:14:33 -0400
Received: by mail-ob0-f176.google.com with SMTP id uz19so7210559obc.21
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 08:14:32 -0700 (PDT)
Message-ID: <522F3757.8030600@lwfinger.net> (sfid-20130910_171446_846462_875BBF7B)
Date: Tue, 10 Sep 2013 10:14:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: RTL8192CU continually reconnecting
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net> <522E5D83.9060103@ilande.co.uk> <522E896E.7000607@lwfinger.net> <522EB51A.2080004@ilande.co.uk>
In-Reply-To: <522EB51A.2080004@ilande.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/10/2013 12:58 AM, Mark Cave-Ayland wrote:
>
> No worries - disk space is reasonably cheap these days ;)
>
> dmesg output:
> http://www.ilande.co.uk/tmp/rtl8192cu_patch-4-dmesg.txt
>
> wpa_supplicant output:
> http://www.ilande.co.uk/tmp/rtl8192cu_patch-4-wpa_supplicant.txt
>
> I noticed that I got several re-authentication attempts in the dmesg output
> without the corresponding rtl_watchdog_wq_callback() line being emitted - this
> is again something I don't see with zd1211rw and iwlwifi. Once these drivers are
> associated, they seem to stay in that state for hours.

Those disconnects do happen for reasons that I do not understand. They will be 
worse on your system without a network manager as it appears that you need to 
manually reconnect at that point, or at least it took a long time for the system 
to react. With NetworkManager, that reconnect is automatic, and relatively quick.

> Whilst checking various parts of my kernel, I noticed for the first time during
> testing that my current kernel configuration doesn't have SMP enabled. This got
> me thinking that perhaps there are other build options which could have an
> effect on the driver. Hence I also uploaded a copy of my .config file to
> http://www.ilande.co.uk/tmp/rtl8192cu-config in the hope that maybe this can
> help you recreate the issue locally?

As I have a dual-core CPU, thus I always have SMP set. That should not be a 
problem. In fact, the concurrent operation of 2 CPUs usually causes more 
problems. I will review that configuration.

You can now disable the logging. When the watchdog reports that contact with the 
AP has been lost, that is certainly true, and the watchdog is doing its job. In 
addition, nothing was received from any AP, which leads me to conclude that the 
receiver has locked up for some reason. I need to check to see what the code 
does to recover. Perhaps that will help me understand the problem. In my current 
run that has run for 20 hours, I have had two disconnects for Reason 3, but more 
importantly, I have had two watchdog restarts. It does happen on my system, just 
a lot less frequently. BTW, my ping loss rate is about 3%. That is too high, but 
not as bad as yours.

Larry


