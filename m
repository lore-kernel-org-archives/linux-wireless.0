Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ws-mr1.cc.emory.edu ([170.140.50.231]:55805 "EHLO
	ws-mr1.cc.emory.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab2LAOYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Dec 2012 09:24:17 -0500
Received: from mail-la0-f46.google.com (emoryfloatdmz.cc.emory.edu [170.140.52.254])
	(authenticated bits=0)
	by ws-mr1.cc.emory.edu (8.13.8/8.13.8) with ESMTP id qB1EOEjm020287
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sat, 1 Dec 2012 09:24:15 -0500
Received: by mail-la0-f46.google.com with SMTP id p5so1103274lag.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Dec 2012 06:24:13 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG5aqJWesPyfRrRHpzxorGaHf6d79Yrau84JLuSJBMi07Gg-_A@mail.gmail.com>
References: <CAG5aqJX6h7-aOBrq5pTNfBru7zmZji8hO+JqRC3eN0uXthAbLw@mail.gmail.com>
 <CAG5aqJV62_8eFJNQx=8R9gTYCRR4RbiaUks48oPRNm-Pq5DO=A@mail.gmail.com>
 <CAG5aqJWdxLf3X1+DsEiz4cpSnfo7JMsuEsMYPND8TPhUVag-Ww@mail.gmail.com> <CAG5aqJWesPyfRrRHpzxorGaHf6d79Yrau84JLuSJBMi07Gg-_A@mail.gmail.com>
From: =?UTF-8?Q?Cengiz_G=C3=BCnay?= <cgunay@emory.edu>
Date: Sat, 1 Dec 2012 06:23:53 -0800
Message-ID: <CAG5aqJVR1T-zcUkFaqJ3Cbgp62xrNXkdRn03Tf9deqZf4P0v6w@mail.gmail.com> (sfid-20121201_152519_830514_C63DB980)
Subject: rtl8723e droping the AP continuously for low signals; is there a
 threshold parameter?
To: linux-wireless <linux-wireless@vger.kernel.org>,
	cengique@users.sf.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(Resending original message because Text/HTML content was rejected)

Hi,

I am trying to use the Linux kernel driver for the RTL8723E wifi card.
While the card works flawlessly in Windows, it is unusable under Linux. For
low-signal APs, such as in public places, the kernel continuously drops the
AP connection and reconnects. This brings the transfer rate almost to a
stop. I compiled the sources of the unofficial kernel driver distributed by
Realtek to get this card working.

My question to you: is there a threshold parameter in the driver source
code that I can play with to stop the driver from dropping AP connections
even though the signal is low?

I would really appreciate any suggestions as this problem is rendering the
wifi card unusable.

Here are my system specifics:

# uname -a
Linux cenlap 3.4-trunk-amd64 #1 SMP Tue Jun 26 17:23:03 UTC 2012 x86_64
GNU/Linux

It's a Debian (Testing level). From dmesg:
Linux version 3.4-trunk-amd64 (Debian 3.4.4-1~experimental.1) (
debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-1) ) #1
SMP Tue Jun 26 17:23:03 UTC 2012

# lspci -v -s 03:00.0
03:00.0 Network controller: Realtek Semiconductor Co., Ltd. Device 8723
    Subsystem: Realtek Semiconductor Co., Ltd. Device 0726
    Flags: bus master, fast devsel, latency 0, IRQ 18
    I/O ports at d000 [size=256]
    Memory at f7900000 (64-bit, non-prefetchable) [size=16K]
    Capabilities: [40] Power Management version 3
    Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit+
    Capabilities: [70] Express Endpoint, MSI 00
    Capabilities: [100] Advanced Error Reporting
    Capabilities: [140] Virtual Channel
    Capabilities: [160] Device Serial Number 01-23-87-fe-ff-4c-e0-00
    Kernel driver in use: rtl8723e

Using driver rtl_92ce_92se_92de_8723ae_
linux_mac80211_0006.0514.2012

I did have to comment out IEEE80211_HW_BEACON_FILTER (line 320 in base.c)
to be able to compile your kernel driver for my 3.4 kernel, following the
description here:
http://askubuntu.com/questions/139632/wireless-card-realtek-rtl8723ae-bt-is-not-recognized

Here are the errors I'm getting on dmesg and I can see WPA_GUI continuously
reconnecting every few seconds:
[ 7316.486880] wlan0: Connection to AP 00:0a:06:05:01:53 lost.
[ 7316.487711] cfg80211: Calling CRDA to update world regulatory domain
[ 7317.519557] wlan0: authenticate with 00:0a:06:05:01:53
[ 7317.551189] wlan0: send auth to 00:0a:06:05:01:53 (try 1/3)
[ 7317.754273] wlan0: send auth to 00:0a:06:05:01:53 (try 2/3)
[ 7317.958152] wlan0: send auth to 00:0a:06:05:01:53 (try 3/3)
[ 7318.162085] wlan0: authentication with 00:0a:06:05:01:53 timed out
[ 7329.506332] wlan0: authenticate with 00:0a:06:05:01:97
[ 7329.519585] wlan0: send auth to 00:0a:06:05:01:97 (try 1/3)
[ 7329.521128] wlan0: authenticated
[ 7329.536739] wlan0: associate with 00:0a:06:05:01:97 (try 1/3)
[ 7329.538853] wlan0: RX AssocResp from 00:0a:06:05:01:97 (capab=0x421
status=0 aid=1)
[ 7329.538858] wlan0: associated
[ 7332.527325] wlan0: Connection to AP 00:0a:06:05:01:97 lost.
[ 7332.531547] cfg80211: Calling CRDA for country: US

Thanks,
Cengiz
