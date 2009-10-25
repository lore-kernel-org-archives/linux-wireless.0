Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:56085 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZJYSzJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2009 14:55:09 -0400
Received: by pwj9 with SMTP id 9so964595pwj.21
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2009 11:55:14 -0700 (PDT)
Message-ID: <4AE49F0F.1060901@lwfinger.net>
Date: Sun, 25 Oct 2009 13:55:11 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
Subject: Rate-setting problem with Broadcom 4315
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When my BCM4312 (ID 4315) runs in auto rate mode, the rate stays at
1Mb/s. If I manually set the rate, I see a tcpperf throughput ~1/2 the
rate that I set through a rate of 12 Mb/s. At 36 Mb/s, the rate is
best at 15.7 Mb/s. Why does mistrel not increase the rate?

The output of /sys/..../rc_stats is:

finger@larrylap:~> cat
/sys/kernel/debug/ieee80211/phy0/stations/00:14:bf:85:49:fa/rc_stats
rate     throughput  ewma prob   this prob  this succ/attempt
success    attempts
     1         0.9       99.1      100.0          0(  0)       3244
     3282
     2         1.8       95.7      100.0          0(  0)         12
       12
     5.5       4.8       95.7      100.0          0(  0)         12
       12
    11         9.2       96.8      100.0          0(  0)         12
       12
  P  6         5.6       99.9      100.0          0(  0)         58
       58
     9         8.0       95.7      100.0          0(  0)         11
       11
    12        10.6       95.7      100.0          0(  0)         12
       12
    18        15.7       96.6      100.0          0(  0)         14
       15
    24        20.3       95.7      100.0          0(  0)         11
       11
    36        29.0       95.4       94.5          0(  0)       1602
     1670
T   48        38.7       99.2      100.0          1(  1)      32147
    37752
 t  54        32.9       75.9      100.0          0(  0)       8775
    12788

Total packet count::    ideal 2570      lookaround 135
