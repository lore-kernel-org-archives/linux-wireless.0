Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f180.google.com ([209.85.210.180]:62181 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab3B0TFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 14:05:06 -0500
Received: by mail-ia0-f180.google.com with SMTP id f27so757477iae.39
        for <linux-wireless@vger.kernel.org>; Wed, 27 Feb 2013 11:05:06 -0800 (PST)
Message-ID: <512E58DF.4050001@lwfinger.net> (sfid-20130227_200512_397463_B412AA6F)
Date: Wed, 27 Feb 2013 13:05:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>
Subject: Re: rtl8192cu goes silent/dead after some time...
References: <20130225185141.14193yyf1vunany8@www.dalek.fi>
In-Reply-To: <20130225185141.14193yyf1vunany8@www.dalek.fi>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/25/2013 10:51 AM, Jussi Kivilinna wrote:
> Hello,
>
> I've been trying to get rtl8192cu work on ARM board I got recently. While I
> don't get crashes anymore and I can connect to AP, open connections, do short
> transfers, eventually rtl8192cu goes silent (bulk-IN urbs stop completing, no
> packets received). Bringing interface down and back up does not help, I need to
> rmmod/modprobe to wake the device.
>
> I noticed that, when doing large transfer (with iperf), "signal avg" reading
> from iw started to behave interestingly...
>
> Idle (0.1 sec interval):
>          signal avg:     -75 dBm
>          signal avg:     -68 dBm
>          signal avg:     -72 dBm
>          signal avg:     -73 dBm
>          signal avg:     -74 dBm
>          signal avg:     -75 dBm
>          signal avg:     -75 dBm
>          signal avg:     -75 dBm
>          signal avg:     -75 dBm
>          signal avg:     -74 dBm
>
> While doing TCP transfer, rtl8192cu at RX side (0.1sec intervals):
>          signal avg:     -88 dBm
>          signal avg:     -13 dBm
>          signal avg:     -38 dBm
>          signal avg:     100 dBm
>          signal avg:     -11 dBm
>          signal avg:     122 dBm
>          signal avg:     51 dBm
>          signal avg:     77 dBm
>          signal avg:     -14 dBm
>          signal avg:     -18 dBm
>          signal avg:     78 dBm
>          signal avg:     46 dBm
>          signal avg:     -65 dBm
>          signal avg:     -103 dBm
>          signal avg:     -90 dBm
>          signal avg:     88 dBm
>          signal avg:     -43 dBm
>          signal avg:     -12 dBm
>
> This keeps on until rtl8129cu goes silent.
>
> I have attached kernel log with rtl8192cu loaded with debug=4. Connection stops
> working around timestamp 1377. (Log shows some BUGs which do appear with
> debugging on but not without.)
>
> Apparently triggering this hang becomes much harder to trigger when debug=4 is
> enabled... probably because debug logging increasing CPU usage, transfer rate
> drops to 1Mbit/s and above symptom mostly disappears. Without debug=4, RX runs
> at ~28Mbit/s.

Thanks for the log and the signal average data. All of the BUGs come from a 
single debug statement in the source. I will delete that trace call.

Realtek has apparently stopped development on the mac80211-based driver. The 
latest version is dated 2011.02.10. The latest driver with Realtek's softmac 
stack is 2012.06.22. As the two drivers are totally different, porting the fixes 
from one to the other are quite difficult.

My plan is to try to improve rtl8192cu; however, if that does not work, I will 
pull it in favor of the version with Realtek's stack. It will, of course, need 
to be placed in staging. The downside is that a number of distros do not install 
drivers from staging, and all the mac80211 features will be lost. That is the 
worst case outcome.

Larry

