Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:42798 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3EPLcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 07:32:22 -0400
Received: by mail-lb0-f175.google.com with SMTP id v10so3006000lbd.34
        for <linux-wireless@vger.kernel.org>; Thu, 16 May 2013 04:32:20 -0700 (PDT)
MIME-Version: 1.0
From: Randy Li <randylxr@gmail.com>
Date: Thu, 16 May 2013 19:32:00 +0800
Message-ID: <CAA0gq323=szmTKKRQW_jJp3hV4aHmaHRDm-Y6LMCsET94yPCLQ@mail.gmail.com> (sfid-20130516_133225_167957_ECFC8C8E)
Subject: Re: AR6003 SDIO can't received data if you didn't send any date for a while
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

About error number, it is -110. erro message is below
Compat-wireless backport release: compat-wireless-v3.5.4-1
Backport based on linux-stable.git v3.5.4
compat.git: linux-stable.git
cfg80211: Calling CRDA to update world regulatory domain
ath6kl: Unable to decrement the command credit count register: -110
ath6kl: Unable to send get target info: -110
ath6kl: Failed to init ath6kl core
ath6kl_sdio: probe of mmc0:0001:1 failed with error -110
cfg80211: World regulatory domain updated:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain,
max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

About sending large data problem, I add more kernel network buffer to fix
it, it seems work.
sysctl -w net.core.wmem_max=12582912

==============================
============================
I use this WNIC in a s3c6410 devboard called OK6410 made by
forlinx(http://www.forlinx.net/Other/6.htm)

The kernel is 3.0.1, the driver in the kernel source can't work. So I
tried compat-wireless-3.3-2-n and
compat-wireless-3.5.4-1. 3.3-2 is eaier to get -101 error when I load
the modules, in this time I have to replug WNIC card.

When networking is connected, I can't ping ar6003 in the other place,
if ar6003 didn't send any data
recently.Once ar6003 stoped sending, I can't send to ar6003 after a
very little while.

But if I send large data like video both of them still stop working
after a while, 3.3-2(about 5 minutes) seems to work more longer than
3.5.4-1(about 1 mintue). But both ip link and iw wlan0 link show my
link is up. I have to ifdown and ifup to use wireless again.

kvalo said it cause by irq problem.But when I compiled compat-wireless
