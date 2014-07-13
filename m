Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [199.83.51.51] ([199.83.51.51]:52543 "EHLO mantis.wzyboy.im"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaGMHWf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Jul 2014 03:22:35 -0400
Received: from mail-ob0-f173.google.com (mail-ob0-f173.google.com [209.85.214.173])
	by mantis.wzyboy.im (Postfix) with ESMTPSA id 0E73D88048
	for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 15:21:59 +0800 (CST)
Received: by mail-ob0-f173.google.com with SMTP id vb8so2681311obc.4
        for <linux-wireless@vger.kernel.org>; Sun, 13 Jul 2014 00:21:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P0uf66J_k9FNV6AaJedq9PE==dHaOBsNXqc58T1L+qv1A@mail.gmail.com>
References: <CALkVjQbNMNs__LsNG450fCpTNmAR3kfDFn2o7xxrdLjSi1wu=w@mail.gmail.com>
 <CALkVjQbmrypdzG9B2nQ1oCPGuzO2Va0_vcpvkQmdtOsWP2HHZA@mail.gmail.com> <CANUX_P0uf66J_k9FNV6AaJedq9PE==dHaOBsNXqc58T1L+qv1A@mail.gmail.com>
From: Sascha Weaver <wzyboy@wzyboy.org>
Date: Sun, 13 Jul 2014 15:21:42 +0800
Message-ID: <CALkVjQbGr2b6xzMM9ES6H+7eTVyPVp=ZH3ct0tF7RO2asqf9=w@mail.gmail.com> (sfid-20140713_092241_287125_5D66B297)
Subject: Re: [iwlwifi] Wireless-AC 7260 disconnects every half and hour
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-07-13 12:58 GMT+08:00 Emmanuel Grumbach <egrumbach@gmail.com>:
> Please try the patch attached.
> Thanks


Thanks Emmanuel. I tried this patch but it seems that this patch does not work.

I applied the patch, installed the kernel and rebooted my laptop.
After conencting to the AP and I wait for 25 minutes, then I start to
ping my gateway. At exactly 30 minutes, it re-associates, and the
network connection is lost for about 9 seconds:

64 bytes from 192.168.108.254: icmp_seq=116 ttl=255 time=1.84 ms
64 bytes from 192.168.108.254: icmp_seq=117 ttl=255 time=2.45 ms
64 bytes from 192.168.108.254: icmp_seq=118 ttl=255 time=8.38 ms
64 bytes from 192.168.108.254: icmp_seq=119 ttl=255 time=3.92 ms
64 bytes from 192.168.108.254: icmp_seq=120 ttl=255 time=5.33 ms
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
ping: sendmsg: Network is unreachable
64 bytes from 192.168.108.254: icmp_seq=131 ttl=255 time=4.90 ms
64 bytes from 192.168.108.254: icmp_seq=132 ttl=255 time=5.42 ms
64 bytes from 192.168.108.254: icmp_seq=133 ttl=255 time=2.38 ms
64 bytes from 192.168.108.254: icmp_seq=134 ttl=255 time=16.4 ms
64 bytes from 192.168.108.254: icmp_seq=135 ttl=255 time=29.7 ms


You can see there is nine pings which produce "Network is unreachable"
error. That's about nine seconds I suppose.


The dmesg seems the same:

Jul 13 14:46:47 xenien kernel: wlan0: authenticate with c0:7b:bc:1a:85:ff
Jul 13 14:46:47 xenien kernel: wlan0: send auth to c0:7b:bc:1a:85:ff (try 1/3)
Jul 13 14:46:47 xenien kernel: wlan0: authenticated
Jul 13 14:46:47 xenien kernel: wlan0: associate with c0:7b:bc:1a:85:ff (try 1/3)
Jul 13 14:46:47 xenien kernel: wlan0: RX AssocResp from
c0:7b:bc:1a:85:ff (capab=0x11 status=0 aid=2)
Jul 13 14:46:47 xenien kernel: wlan0: associated
Jul 13 14:46:47 xenien kernel: IPv6: ADDRCONF(NETDEV_CHANGE): wlan0:
link becomes ready
Jul 13 14:46:48 xenien kernel: psmouse serio2: trackpoint: IBM
TrackPoint firmware: 0x0e, buttons: 3/3
Jul 13 14:46:48 xenien kernel: input: TPPS/2 IBM TrackPoint as
/devices/platform/i8042/serio1/serio2/input/input16
Jul 13 14:46:52 xenien kernel: fuse init (API version 7.23)
Jul 13 14:47:28 xenien kernel: snd_hda_intel 0000:00:1b.0: IRQ timing
workaround is activated for card #1. Suggest a bigger bdl_pos_adj.
Jul 13 15:16:57 xenien kernel: wlan0: deauthenticated from
c0:7b:bc:1a:85:ff (Reason: 2=PREV_AUTH_NOT_VALID)
Jul 13 15:16:57 xenien kernel: cfg80211: Calling CRDA for country: CN
Jul 13 15:17:00 xenien kernel: wlan0: authenticate with 18:9c:5d:97:76:1f
Jul 13 15:17:00 xenien kernel: wlan0: send auth to 18:9c:5d:97:76:1f (try 1/3)
Jul 13 15:17:00 xenien kernel: wlan0: authenticated
Jul 13 15:17:00 xenien kernel: wlan0: associate with 18:9c:5d:97:76:1f (try 1/3)
Jul 13 15:17:00 xenien kernel: wlan0: RX AssocResp from
18:9c:5d:97:76:1f (capab=0x11 status=0 aid=11)
Jul 13 15:17:00 xenien kernel: wlan0: associated


-- 
Sascha Weaver
