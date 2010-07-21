Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35166 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab0GUWRT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jul 2010 18:17:19 -0400
Received: by ewy23 with SMTP id 23so2666151ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jul 2010 15:17:15 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 22 Jul 2010 00:17:12 +0200
Message-ID: <AANLkTimQ7O2nOmh2Rda3d_PKWbS2WlGVBHYMCuhxW10W@mail.gmail.com>
Subject: ath9k: performance regressions / tx semi-stuck somehow
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I just tried out compat-wireless-2010-07-16 on AR913x (with
openwrt/trunk@r22321) and saw some weird performance problems.

First, with the default 11n HT20 AP configuration I get really good
performance on an old 11g MacBook. 16Mbps downloads limited by WAN. :)

But then I try a newer 11n MacBook and performance absolutely sucks.
2-3Mbps downloads with erratic bursts and "hangs".

So, I start to think something is wrong with 11n and reconfigure for
11g only. Then the 11g MacBook performance also sucks. The same
2-3Mbps downloads with erratic bursts and "hangs". So 11n AP and 11g
client is good, but 11g AP and 11g client sucks. Looking at the
rc_stats it seems like tx completely breaks down from time to time:

root@OpenWrt:/sys/kernel/debug/ieee80211/phy0# cat stations/00\:17\:f2\:51\:b2\:
2d/rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt
success    attempts
 t   1         0.1       18.3        0.0          0( 19)         28         731
     2         0.0        0.0        0.0          0(  0)          0          18
     5.5       0.0        0.0        0.0          0(  0)          0          10
    11         0.0        0.0        0.0          0(  0)          0          14
     6         0.0        0.0        0.0          0(  0)          0          11
     9         0.0        0.0        0.0          0(  0)          0          18
    12         0.0        0.0        0.0          0(  0)          0          12
    18         0.0        0.0        0.0          0(  0)          0          16
    24         0.0        0.0        0.0          0(  0)          0          18
    36         0.1        0.4        0.0          0(  0)          2        1824
    48         0.0        0.0        0.0          0(  2)          0          16
T P 54        27.3       63.1        0.0          0(180)       4749       13896

Total packet count::    ideal 4780      lookaround 532

That's in exactly the same spot I was getting 16Mbps consistently with
AP was 11n!

Any debuging I can do to help? Bisecting is unfortunately a lot of
work on this embedded system...

/Björn
