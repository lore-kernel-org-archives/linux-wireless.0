Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:57869 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab3EMWu4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 May 2013 18:50:56 -0400
Received: by mail-la0-f50.google.com with SMTP id dz20so2788699lab.23
        for <linux-wireless@vger.kernel.org>; Mon, 13 May 2013 15:50:55 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 13 May 2013 17:50:55 -0500
Message-ID: <CAMP44s2WUTJPBF71R2h1hOhMm=ga4Znaq33DndZA7v8SmPe1EA@mail.gmail.com> (sfid-20130514_005114_778757_727910D7)
Subject: Unable to link the first time with iwlwifi
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Right after booting when I try to join a network I get nothing:

May 13 17:25:22 nysa kernel: iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
May 13 17:25:22 nysa kernel: iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0
May 13 17:25:22 nysa kernel: iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
May 13 17:25:22 nysa kernel: iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0
May 13 17:25:22 nysa kernel: IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
May 13 17:25:26 nysa kernel: wlan0: authenticate with e0:1d:3b:46:82:a0
May 13 17:25:26 nysa kernel: wlan0: send auth to e0:1d:3b:46:82:a0 (try 1/3)
May 13 17:25:26 nysa kernel: wlan0: authenticated
May 13 17:25:26 nysa kernel: wlan0: waiting for beacon from e0:1d:3b:46:82:a0
May 13 17:25:29 nysa kernel: wlan0: authenticate with e0:1d:3b:46:82:a0
May 13 17:25:29 nysa kernel: wlan0: send auth to e0:1d:3b:46:82:a0 (try 1/3)
May 13 17:25:29 nysa kernel: wlan0: authenticated

Over and over and over. It never authenticates.

Then if I enable ad-hoc mode in wpa_supplicant:

May 13 17:25:57 nysa kernel: iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
May 13 17:25:57 nysa kernel: iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0
May 13 17:25:57 nysa kernel: IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
May 13 17:26:00 nysa kernel: wlan0: Trigger new scan to find an IBSS to join
May 13 17:26:03 nysa kernel: wlan0: Trigger new scan to find an IBSS to join
May 13 17:26:07 nysa kernel: wlan0: Trigger new scan to find an IBSS to join
May 13 17:26:09 nysa kernel: wlan0: Creating new IBSS network, BSSID
86:d6:03:46:b5:54
May 13 17:26:09 nysa kernel: iwlwifi 0000:02:00.0: Unable to find TIM
Element in beacon
May 13 17:26:09 nysa kernel: iwlwifi 0000:02:00.0: Unable to find TIM
Element in beacon
May 13 17:26:09 nysa kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlan0:
link becomes ready
May 13 17:26:18 nysa kernel: iwlwifi 0000:02:00.0: REPLY_REMOVE_STA failed
May 13 17:26:18 nysa kernel: iwlwifi 0000:02:00.0: failed to remove
IBSS station 00:00:00:00:00:00

Of course, I'm not interested in ad-hoc mode, but when I disable it
and try again:

May 13 17:26:19 nysa kernel: iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
May 13 17:26:19 nysa kernel: iwlwifi 0000:02:00.0: Radio type=0x2-0x1-0x0
May 13 17:26:19 nysa kernel: IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
May 13 17:26:22 nysa kernel: wlan0: authenticate with e0:1d:3b:46:82:a0
May 13 17:26:22 nysa kernel: wlan0: send auth to e0:1d:3b:46:82:a0 (try 1/3)
May 13 17:26:23 nysa kernel: wlan0: send auth to e0:1d:3b:46:82:a0 (try 2/3)
May 13 17:26:23 nysa kernel: wlan0: authenticated
May 13 17:26:23 nysa kernel: wlan0: associating with AP with corrupt beacon
May 13 17:26:23 nysa kernel: wlan0: associate with e0:1d:3b:46:82:a0 (try 1/3)
May 13 17:26:23 nysa kernel: wlan0: associate with e0:1d:3b:46:82:a0 (try 2/3)
May 13 17:26:23 nysa kernel: wlan0: RX AssocResp from
e0:1d:3b:46:82:a0 (capab=0x31 status=0 aid=3)
May 13 17:26:23 nysa kernel: wlan0: associated
May 13 17:26:23 nysa kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlan0:
link becomes ready

It works this way _every single time_. So I have to with with mode=1,
then with mode=0, _every single time_. It's very annoying and I've
tried everything; I tried with older kernels as far as 3.6.0,
different versions of wpa_supplicant, different module options. It
never works correctly.

Right now I'm on v3.9.2, and the problem is still there. I believe if
I restart the AP, it works, but I haven't tried many times. Also, I
haven't tried other APs (I don't have one readily available).

Any pointers?

Cheers.

-- 
Felipe Contreras
