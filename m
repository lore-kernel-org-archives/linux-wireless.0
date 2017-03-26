Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f170.google.com ([74.125.82.170]:33815 "EHLO
        mail-ot0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751378AbdCZQH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 26 Mar 2017 12:07:59 -0400
Received: by mail-ot0-f170.google.com with SMTP id a5so17498103oth.1
        for <linux-wireless@vger.kernel.org>; Sun, 26 Mar 2017 09:07:58 -0700 (PDT)
Subject: Re: wlan0 keeps deauthenticating DEAUTH_LEAVING about every minute
To: Dennis New <dennisn@dennisn.mooo.com>,
        linux-wireless@vger.kernel.org
References: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <77d7e7a0-b529-ad29-9584-da51c68a5917@lwfinger.net> (sfid-20170326_180807_517928_A1991CE6)
Date: Sun, 26 Mar 2017 11:00:12 -0500
MIME-Version: 1.0
In-Reply-To: <20170324213237.6f122a9173fa464a5d936f9d@dennisn.mooo.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2017 08:32 PM, Dennis New wrote:
> Ever since I upgraded to the 4.10 kernels (I don't think this behavior
> existed in the 4.8 series), after I startup my laptop (either from cold
> boot, or from standby), my wlan0 interface keeps deauthenticating
>
> 19:24:29 kernel: wlan0: deauthenticating from 00:11:22:33:44:55 by
> local choice (Reason: 3=DEAUTH_LEAVING)
>
> usually exactly 60 seconds after it authenticates/associates (to my
> open wifi access point), but not always 60 seconds after -- sometimes
> it happens in less than 60 seconds. Although, if it somehow manages to
> pass the 60 second mark without deauthenticating, it remains stable --
> unless I decide to /etc/init.d/net.wlan0 restart it :s. I'm not sure
> what makes makes the deauthentications suddenly stop, but after various
> incantations and module unloading/reloading and a fair amount of
> cursing, or possibly just waiting some random amount of time, the
> problem goes away for the day ... and returns the next day when I boot
> up again, and I have to go through this torturous process all over
> again, of praying and restarting my wlan0 interface.

When you file a bug report such as this, you need to provide information 
regarding what specific card you have. The appropriate stanza from "lspci -nn" 
has that information.

I do not normally run a b43 wireless NIC, but I did pull out an ancient laptop 
that uses the PCMCIA version of a BCM4318 with PCI ID of 14e4:4318. Running 
kernel 4.10.0, I do see periodic drops. My period is 120 sec and the drop is a 
reason 7, not reason 3 as you see. Another difference is that I see the drops 
with kernel 4.8.0 as well. With the earlier kernel, the drop period is closer to 
60 sec, but it is not as regular. I will be checking even earlier kernels to see 
if I can find a "good" value for bisection.

Larry
