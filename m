Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:58121 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab0AOT7Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jan 2010 14:59:24 -0500
Received: by bwz27 with SMTP id 27so913793bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jan 2010 11:59:23 -0800 (PST)
Message-ID: <4B50C916.7090303@lwfinger.net>
Date: Fri, 15 Jan 2010 13:59:18 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jochen Friedrich <jochen@scram.de>,
	Daniel Schmitt <daniel@schmitt-united.de>
CC: OpenWrt Development List <openwrt-devel@lists.openwrt.org>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: PHY Transmission error and radio turned off with b43legacy
References: <51ab59276e22ee681f29560ebac67004.squirrel@unimail.uni-dortmund.de> <4B505B94.3020509@scram.de>
In-Reply-To: <4B505B94.3020509@scram.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/15/2010 06:12 AM, Jochen Friedrich wrote:
> Daniel Schmitt wrote:
> 
>> hostapd doesn't continue to work after controller is restarted.
>> I also have the problem that the wlan0-interface shall not be upped with
>> "ifconfig wlan0 0.0.0.0 up" before starting hostapd, otherwise no beacons
>> will be send. The interface must be down before starting hostapd.
>> If I terminate a not daemonized hostapd with CTRL+C and restart if
>> without
>> rmmod+modprobe b43legacy, no beacons are sent, too. And I cannot connect
>> the AP.
>> This happens with the bleeding-edge wireless drivers 2009-11-13.
> 
> I noticed the same on MN700 hardware running OpenWrt bleeding edge. The
> init scripts enable and disable wlan0 once before starting hostapd.
> Here, beacons are still being sent, but hostapd is unable to transmit
> any packet. When reloading b43legacy and starting hostapd manually it
> works, but only once.
> 
> The attached patch resolves the problem for me.

Daniel: Does this patch fix your problem as well?

Has this problem been reported in the kernel bugzilla? If so, what is the number?

How far back does this problem go? From the date of your compat-wireless
package, it seems that 2.6.32 would be affected. How about 2.6.31?

I have tested the patch on my system where it does no harm. I do not run that
system as an AP and had not seen the problem.

As soon as I have the answers to these questions, I will push the patch to
wireless testing.

Thanks for resolving this issue.

Larry
