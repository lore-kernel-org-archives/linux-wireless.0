Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41674 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab2GYChh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 22:37:37 -0400
Received: by qcro28 with SMTP id o28so149161qcr.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jul 2012 19:37:36 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Subject: iwl5300 very slow with excessive Tx retries
Date: Tue, 24 Jul 2012 22:37:34 -0400
Message-ID: <87haswbm6p.fsf@gmail.com> (sfid-20120725_043741_158472_B8735798)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My home network is hosted by hostapd (with HT enabled) on a
Ubiquiti SR-71-E (supported by ath9k). My laptop (running Ubuntu 12.04
with kernel 3.2.0, I can try 3.4 soon) has an iwl5300 (8086:4235) and
sadly performs quite poorly in transmission. Namely, a large transfer
over SSH will run at around 1.5 MB/s with iwconfig showing the
following,

     wlan0     IEEE 802.11abgn  ESSID:"LittleGreenMen"  
               Mode:Managed  Frequency:2.422 GHz  Access Point: 00:15:6D:85:22:E2   
               Bit Rate=39 Mb/s   Tx-Power=15 dBm   
               Retry  long limit:7   RTS thr:off   Fragment thr:off
               Power Management:off
               Link Quality=55/70  Signal level=-55 dBm  
               Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
               Tx excessive retries:21262  Invalid misc:63   Missed beacon:0

Note the high "Tx excessive retries" quantity, which increases at the
rate of about 1000 per second during the transfer. The "Invalid misc"
quantity also increases although at a much more modest rate.

A bit of Googling shows that I am not the first person to experience
this issue, with others reporting improvement after disabling power
management (iwconfig wlan0 power off) and disabling 11n (with the
11n_disable=1 module option). While the former changes nothing in my
case, disabling 11n stops the runaway Tx retries, although "invalid
misc" events remain and throughput does not improve.

Any ideas what might be causing this poor performance?

Cheers,

- Ben

