Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:32790 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbbAOBPj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jan 2015 20:15:39 -0500
Received: by mail-oi0-f42.google.com with SMTP id g201so10192838oib.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jan 2015 17:15:38 -0800 (PST)
Message-ID: <54B714B8.4020904@lwfinger.net> (sfid-20150115_021542_253329_A472FEE1)
Date: Wed, 14 Jan 2015 19:15:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bryan Quigley <gquigs@gmail.com>, linux-wireless@vger.kernel.org
Subject: Re: Packet loss on rtl8188ee
References: <CAAWf5=sCKA3w_snEqJzNSCk8DSCVc5Bv1HXooGLicg3GFX9xBQ@mail.gmail.com>
In-Reply-To: <CAAWf5=sCKA3w_snEqJzNSCk8DSCVc5Bv1HXooGLicg3GFX9xBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/14/2015 04:20 PM, Bryan Quigley wrote:
> Hi there,
>
> I've been seeing packet loss on this laptop using a rtl8188ee wireless
> card on Ubuntu 14.10 with compat-wireless 3.19rc4 kernel. I've tried
> it with two routers and many different settings.  My test case is ping
> -i 0.02 -c 100 with the laptop next to the router, and I run it at
> least 3 times to be certain.
>
> On other devices I can do this over and over again with no packet loss
> to the same router.
>
> I've been debugging it here:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1401741
>
> I've tried enabling debug options (but nothing obvious when packets
> are dropped), changing channels (6 seemed to be best), changing Wifi
> Security, changing module options, but still get some dropped packets.
> it does *seem* better running compat-wireless 3.19rc4, but that might
> be in my head..
>
> Is there a better test case for packet loss?  Just ping for longer?
> The debug logs I've been able to generate don't appear to do anything
> special on packet loss.  Any suggestions?
>
> The packet loss greatly effects web apps during light to moderate
> usage (think Email and a few websites) to the point of making it
> unusable.

The drivers in compat-wireless will match the ones in the wireless-drivers git 
repo. There are some newer parts than found in mainline where a lot of 3.20 
stuff is accumulating.

You might try the drivers found at http://github.com/lwfinger/rtlwifi_new.git. 
That is the version that came from Realtek. It should be the same as 
wireless-drivers, but errors might have crept in. In addition, some of the 
Realtek devices have problems with power saving. Try loading the driver with the 
"ips=0" option. The debug options only control the amount of stuff that gets logged.

For me, rtl8188ee works fine. Possible reasons for my result being different 
could be the noisiness of the environment.

Larry


