Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:54573 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753974Ab3EPN1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 09:27:18 -0400
Received: from mailout-de.gmx.net ([10.1.76.27]) by mrigmx.server.lan
 (mrigmx002) with ESMTP (Nemesis) id 0MXTLc-1UyMR11bWg-00WUxy for
 <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 15:27:17 +0200
Message-ID: <5194DEB3.2060407@rempel-privat.de> (sfid-20130516_152721_653837_09D3C43D)
Date: Thu, 16 May 2013 15:27:15 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Ignacy Gawedzki <i@lri.fr>, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
References: <20130515134258.GA9033@zenon.in.qult.net>
In-Reply-To: <20130515134258.GA9033@zenon.in.qult.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 15.05.2013 15:42, schrieb Ignacy Gawedzki:
> Hi everyone,
>
> This is an old issue, about which it seems the first posts date back to 2009.
> With the latest possible version of the firmware for AR9271 and the latest
> possible wireless drivers, the issue is still there.  Whether this is still
> the exact same problem every time remains to be checked, but it is annoying
> enough to deserve some consideration.
>
> The problem is that the driver can't talk to the device if the following
> conditions are met:
>
>   - The system cold boots with the USB dongle inserted or the USB dongle is
>     inserted on a running system.
>
>   - The interface is *not* brought up.
>
>   - The system (warm) reboots.
>
> Then the driver complains about the target being unresponsive after uploading
> the firmware.  Apparently the only way to make it work again is to unplug and
> then plug the USB dongle back, physically.  It seems that if the USB port is
> not powered down during reboot (which happens with at least two different
> setups that I've tested it with), the device is left in a broken state.
>
> I would gladly help in tracing down this bug if only I knew where to start.
>
> Thanks for any suggestion.

Hi Ignacy,

i can't reproduce this issue on my system. I tested it with 4 different 
ath9_htc adapter. Without luck. Please provide as match information as 
possible:
- Usb host controller
- Adapter manufacture and version, or even better add it to the wiki, 
and upload some images:
http://wikidevi.com/wiki/Main_Page
- your kernel version

I assume it is not firmware. May be there are some issue with boot 
loader on adapter. Are you sure that UART pins are not soldered?
Current ath9k_htc do not have mechanism to reset an adapter. I will 
start to work on it after some other issues are done.

PS: please find some way to enable uart, at least TX pin.

-- 
Regards,
Oleksij
