Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:57667 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab3G1MMu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Jul 2013 08:12:50 -0400
Received: from [192.168.2.102] ([93.218.71.62]) by mail.gmx.com (mrgmx003)
 with ESMTPSA (Nemesis) id 0M4002-1UDNBV1kXK-00raTp for
 <linux-wireless@vger.kernel.org>; Sun, 28 Jul 2013 14:12:49 +0200
Message-ID: <51F50AB7.3030204@rempel-privat.de> (sfid-20130728_141255_052842_82A18F58)
Date: Sun, 28 Jul 2013 14:12:39 +0200
From: Oleksij Rempel <linux@rempel-privat.de>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: linux-wireless@vger.kernel.org,
	Sarah Sharp <sarah.a.sharp@linux.intel.com>,
	USB list <linux-usb@vger.kernel.org>,
	Seth Forshee <seth.forshee@canonical.com>,
	ath9k_htc_fw <ath9k_htc_fw@lists.infradead.org>
Subject: Re: FUSB200 xhci issue
References: <51ED4E12.8030006@rempel-privat.de> <5176750.ryksn4nuMW@blech> <51F4B128.3010901@rempel-privat.de> <201307281338.39157.chunkeey@googlemail.com>
In-Reply-To: <201307281338.39157.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.07.2013 13:38, schrieb Christian Lamparter:

>>>
>>> Anyway, I tried the -next branch.
>>>
>>> commit dbbb809d592dde0b3c9ecb97b3b387ff8e40e799
>>> Author: Oleksij Rempel <linux@rempel-privat.de>
>>> Date:   Wed Jul 24 10:26:18 2013 +0200
>>>
>>>       k2_fw_usb_api: workaround for EP4 bug.
>>>
>>> but still, the device won't show up after autosuspend.
>>
>> Hm... firmware probably didn't rebooted before suspend. Did interface
>> was up, before autosuspend? If no, you need latest wireles-testing -
>> there are patches to handle this issue. Or just make "ifconfig wlan1 up"
>>    before  rmmod.
> Oh, I it was on the latest wireless-testing. (And the "ath9k_htc" module
> had the patch "ath9k_htc: reboot firmwware if it was loaded").
>
> Furthermore, I did the same test with one of the ehci-only ports
> and it worked. Both, devices (one had a AR7015, the other a AR9271)
> came back after autosuspend there.

Grrr... so it brings us back to xhci issue. Even EP4 workaround wont 
work here :( Suddenly i have no more ideas.

Sarah, it's your turn now.
-- 
Regards,
Oleksij
