Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:47503 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab2FKNZI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 09:25:08 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Se4cC-0001c0-GC
	for linux-wireless@vger.kernel.org; Mon, 11 Jun 2012 15:25:04 +0200
Received: from 194.42.38.169 ([194.42.38.169])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 15:25:04 +0200
Received: from contact by 194.42.38.169 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 15:25:04 +0200
To: linux-wireless@vger.kernel.org
From: Antonis Hadjiantonis <contact@antonis.mobi>
Subject: Fixed rate for ath9k 
Date: Mon, 11 Jun 2012 13:21:46 +0000 (UTC)
Message-ID: <loom.20120611T150700-482@post.gmane.org> (sfid-20120611_152517_200109_C0406714)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am experimenting with Rate Control of ath9k (minstrel_ht) and tried to fix the
rate to a value. I fix it to an index (e.g. 2) using the relevant patch and
debugfs and confirm the value is changed:
echo 2 > /sys/kernel/debug/ieee80211/phy0/rc/fixed_rate_idx

It seems though the value is ignored, and minstrel RC works unaffected:
>From the rcstat file:
rate     throughput  ewma prob   this prob  this succ/attempt success  attempts
     1         0.1       15.5       50.0          0(  0)         23         121
     2         0.4       25.0      100.0          0(  0)          1           1
     5.5       0.0        0.0        0.0          0(  0)          0           0
  P 11         4.5       47.9       85.7         24( 28)        334         737
     6         1.3       24.6        0.0          0(  0)          2           8
     9         1.5       18.7        0.0          0(  0)          1           5
    12         2.1       19.2        0.0          0(  0)          3          22
    18         1.8       11.0        0.0          0(  0)         96         311
 t  24         6.5       30.9      100.0          1(  1)         14         151
T   36         8.7       28.8      100.0          1(  1)        157         822
    48         1.4        3.8        0.0          0(  0)         85         421
    54         1.9        4.3        0.0          0(  0)      18336       19723

I am using OpenWrt Backfire (10.03.1, r29592) on a WRT160nl and connect with it
over 802.11g using iperf on a smartphone.

As this is my first ever post on the list, please be nice :)

Thanks in advance,
Antonis

