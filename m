Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65170 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761257Ab0GUTT1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 15:19:27 -0400
Received: by pzk26 with SMTP id 26so2210467pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 12:19:27 -0700 (PDT)
Message-ID: <4C474851.4000809@lwfinger.net>
Date: Wed, 21 Jul 2010 14:19:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Gamari <bgamari.foss@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Master mode in rtl8187
References: <87vd88n1i8.fsf@gmail.com>
In-Reply-To: <87vd88n1i8.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2010 01:17 PM, Ben Gamari wrote:
> Hey all,
>
> I recently purchased a Netgear WG111v2 (based on rtl8187b) and after
> seeing scattered reports[1] that master mode may be supported by the
> rtl8187 driver. Unfortunately, hostapd throws up when it attempts to put
> the card into master mode. Is master mode supported by this driver? I've
> tried both 2.6.34 as well as the latest wireless-testing tree and
> neither seem to work.

My WG111V2 has an RTL8187L chip in it, not an RTL8187B. No, master mode is NOT 
supported by this driver. Adding that feature has been on my list of things to 
do, but the priority is very low. I really have little desire to convert my $600 
laptop into a $40 access point.

> I noticed there was a patch[2] sent out a few years back, but it seems
> no one followed up. While I don't have much experience working with
> wireless hardware I've done kernel driver work before, so with some
> guidance I might be able to finish up that patch. Any input would be
> greatly appreciated. Thanks!

> [1] http://osdir.com/ml/linux.kernel.wireless.general/2007-07/msg00289.html
> [2] http://osdir.com/ml/linux.kernel.wireless.general/2007-06/msg00455.html

That patch is useless. The rtl8187 driver and mac80211 have changed so much that 
it cannot be made to apply, and would not be likely to work.

One other thing to consider. The RTL8187L has only a single transmit queue. Will 
the device be able to transmit beacons with an appropriate timing accuracy?

To modify the driver, you will need to study some other driver that does work in 
master mode.

Larry
