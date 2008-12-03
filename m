Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYLCJcu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2008 04:32:50 -0500
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: rework scan handling while
	associated
From: Zhu Yi <yi.zhu@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
In-Reply-To: <200812011110.02974.helmut.schaa@gmail.com>
References: <200811261805.39953.helmut.schaa@gmail.com>
	 <200811281031.04996.helmut.schaa@gmail.com>
	 <1228100318.2558.152.camel@debian.sh.intel.com>
	 <200812011110.02974.helmut.schaa@gmail.com>
Content-Type: text/plain
Date: Wed, 03 Dec 2008 17:33:13 +0800
Message-Id: <1228296794.2558.324.camel@debian.sh.intel.com> (sfid-20081203_103256_028002_BEE3C322)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-01 at 18:10 +0800, Helmut Schaa wrote:
> That only happens while associated. Scanning while not associated
> works like
> a charm.
> 
> Here are some more informations:
> If I load the unmodified module with debug=0x3FFF I get the following
> log
> when triggering a scan while associated:
> 
> ipw2200: U ipw_wx_set_scan Start scan
> 00000000 03 00 00 00 0D 24 28 2C  30 34 38 3C 40 95 99 9D   .....$(,
> 048<@...
> 00000010 A1 A5 4A 02 03 04 05 06  07 08 09 0A 0B 00 00
> 00   ..J..... ........
> 00000020 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
> 00   ........ ........
> 00000030 00 00 00 00 00 00 00 00  00 00 03 33 31 11 13
> 33   ........ ...31..3
> 00000040 33 03 33 33 33 33 30 00  00 00 00 00 00 00 00 00
> 3.33330. ........
> 00000050 00 00 00 00 00 00 00 00  78 00 14 00 14 00 14 00   ........
> x.......
> martian source 255.255.255.255 from 149.44.170.156, on dev eth1
> ll header: ff:ff:ff:ff:ff:ff:00:19:99:28:58:5b:08:00
> ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> ipw2200: I ipw_rx_notification Scan result for channel 36
> ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> ipw2200: I ipw_rx_notification Scan result for channel 40
> ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> ipw2200: I ipw_rx_notification Scan result for channel 44
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> ipw2200: I ipw_rx_notification Scan result for channel 48
> 
> The channels 36-48 are active 11a channels. The next channel would be
> 52 which
> is a passive channel.
> 
> martian source 255.255.255.255 from 149.44.170.66, on dev eth1
> ll header: ff:ff:ff:ff:ff:ff:00:0e:0c:aa:5c:c5:08:00
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> ipw2200: I ipw_rx_notification type = 17 (8 bytes)
> ipw2200: I ipw_handle_missed_beacon Aborting scan with missed beacon.
> ipw2200: I ipw_handle_missed_beacon Missed beacon: 1
> 
> Aha, the firmware noticed a beacon miss before the scan watchdog
> restarts the firmware (the log is without timestamps, sorry).
> 
> ipw2200: I ipw_rx_notification type = 13 (4 bytes)
> ipw2200: I ipw_rx_notification Scan completed: type 1, 5 channels, 2
> status
> 
> Status 2 -> Scan aborted.

We will look at this.

Thanks,
-yi

