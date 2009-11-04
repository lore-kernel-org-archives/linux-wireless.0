Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:7923 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712AbZKDB2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 20:28:46 -0500
Message-ID: <4AF0D54D.4090303@irobot.com>
Date: Tue, 03 Nov 2009 17:13:49 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: nbd@openwrt.org, derek@indranet.co.nz
Subject: compat-wireless and minstrel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have two systems under test, both Dell laptops (a Latitude D630 and an 
Inspiron 600m) both running Ubuntu 9.10 with the latest updates, and 
bleeding edge compat-wireless-2009-11-02.  I'm using identical AR9170 
based D-Link DWA-160 USB 802.11adapters.  I'm using nuttcp to measure 
throughput.  I'm running in ad-hoc mode.  Both machines have the same 
ar9170 files in /lib/firmware.  The machines are sitting about 5 feet 
apart in my office.

I'm having occasional problems where throughput drops through the floor 
(0.5Mbps - 1.5Mbps).  When I cat 
/sys/kernel/debug/ieee80211/*/stations/*/rc_stats, one of the machines 
lists the full set of rates, but the other only lists 1M and 54M.  After 
a period of time, that machine drops 54M and lists only one rate 
(1Mbps), and the throughput listed by nuttcp drops accordingly.  I 
assume that, for whatever reason, the rates drop off the list and 
minstrel uses the only one left available to it.

If I modify include/net/mac80211.h and force the inline function 
rate_supported to always return 1, this fixes the problem.  However, I 
think this is a band aid around some other issue.

Any clues or ideas what the real issue might be here?
