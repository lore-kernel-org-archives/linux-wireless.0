Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web24715.mail.ird.yahoo.com ([212.82.104.188]:24776 "HELO
	web24715.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753990Ab0BMT6A convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Feb 2010 14:58:00 -0500
Message-ID: <137999.4336.qm@web24715.mail.ird.yahoo.com>
Date: Sat, 13 Feb 2010 19:51:19 +0000 (GMT)
From: John Murdoch <weejoker@yahoo.com>
Subject: ath9k in AP mode - stuck beacon
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

After downloading compat-wireless 2010-02-12, my previously unexplained issues with hostapd failing to send out further beacons after a period of time is now starting to yield useful debug messages along the lines of:

[ 9999.505740] ath: missed 35 consecutive beacons
[ 9999.507501] ath: AR_INTR_SYNC_LOCAL_TIMEOUT
...
[ 9999.531153] ath: AR_INTR_SYNC_LOCAL_TIMEOUT
[ 9999.531339] ath: beacon is officially stuck
[ 9999.531352] ath: 0xf0010071 => 0x0
[ 9999.531361] ath: disable IER
[ 9999.531372] ath: new IMR 0x0
[ 9999.535487] ath: ath9k_hw_stoptxdma: Num of pending TX Frames 1 on Q 9
[ 9999.539691] ath: Failed to Failed to stop TX DMA in 10
0 msec after killing last frame
[ 9999.539759] ath: Disable MIB counters
[ 9999.551236] ath: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x40000020

It looks like this is the "Stuck Beacon" issue I used to see with Madwifi a few years ago with my old Atheros wireless cards, as the local neighborhood is pretty noisy. Back then, I could could remedy this with a few iwpriv/iwconfig changes. 

Are there any plans to stabilize this on ath9k or are there any things I can try to negate this issue?

Regards,
John


      
