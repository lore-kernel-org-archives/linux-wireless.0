Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62833 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491Ab3J1Ibk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 04:31:40 -0400
Received: from [192.168.1.100] ([93.218.124.130]) by mail.gmx.com (mrgmx001)
 with ESMTPSA (Nemesis) id 0LaooK-1Vz1QA3Kh6-00kR5i for
 <linux-wireless@vger.kernel.org>; Mon, 28 Oct 2013 09:31:39 +0100
Message-ID: <526E20EA.9090203@rempel-privat.de> (sfid-20131028_093144_115697_9D464C3A)
Date: Mon, 28 Oct 2013 09:31:38 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	ilw@linux.intel.com, hostap@lists.shmoo.com
Subject: Re: I always need a miracle to connect with iwlwifi
References: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
In-Reply-To: <CAMP44s1XJRHV8bAX=_-TkSKMkY8Nw1=eHorqTCZ2QmtR5m8uJA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.10.2013 07:24, schrieb Felipe Contreras:
> Hi,
> 
> I already reported this problem [1] and I got no feedback whatsoever
> at all. The issue keeps happening and I've tried many things.
> 
> First of all, when Linux is failing, my phone connects fine, other
> computers connect fine, and this machine with Windows 7 as well. I've
> tried reloading the driver, rebooting, different module parameters,
> nothing works.
> 
> I logged a session [2] where I waited 30 minutes for the link to come
> up, but it never did. You can see the same thing happening over and
> over:
> 
> 1382936199.582861: nl80211: Association request send successfully
> 1382936199.797063: nl80211: Event message available
> 1382936199.797097: nl80211: Delete station e0:1d:3b:46:82:a0
> 1382936199.797881: nl80211: Event message available
> 1382936199.797905: nl80211: MLME event 38; timeout with e0:1d:3b:46:82:a0
> 1382936199.797915: wlan0: Event ASSOC_TIMED_OUT (15) received
> 1382936199.797920: wlan0: SME: Association timed out
> 1382936199.797924: Added BSSID e0:1d:3b:46:82:a0 into blacklist
> 
> If I reboot the router, it works immediately, another thing that works
> is connecting with ad-hoc mode (mode=1), and then back to normal mode
> (mode=0).
> 
> Here's a log [3] where I tried reloading the module multiple times and
> finally tried ad-hoc mode, after which the link came up.
> 
> Clearly the Linux kernel has a bug. Can somebody point out what needs
> to be done to get this fixed?
> 
> Cheers.
> 
> [1] http://article.gmane.org/gmane.linux.kernel.wireless.general/108004
> [2] http://people.freedesktop.org/~felipec/wpa/wpa-bad-30-min-wait.log
> [3] http://people.freedesktop.org/~felipec/wpa/wpa-good-nothing-worked-except-mode-switch.log
> 

Heh... this logs look like miracle :)
My first assumption would be buggy router. There is no answer in
wpa_supplicant log.
Take wireshark and capture working and not working associational request.

-- 
Regards,
Oleksij
