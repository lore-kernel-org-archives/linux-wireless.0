Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f13.google.com ([209.85.218.13]:44459 "EHLO
	mail-bw0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454AbYLJJMN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Dec 2008 04:12:13 -0500
Received: by bwz6 with SMTP id 6so946508bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 10 Dec 2008 01:12:11 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: rework scan handling while associated
Date: Wed, 10 Dec 2008 10:11:28 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
References: <200811261805.39953.helmut.schaa@gmail.com> <1228296794.2558.324.camel@debian.sh.intel.com> <1228888289.2558.585.camel@debian.sh.intel.com>
In-Reply-To: <1228888289.2558.585.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812101011.30058.helmut.schaa@gmail.com> (sfid-20081210_101218_040941_FB26DAC7)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Mittwoch, 10. Dezember 2008 schrieb Zhu Yi:
> On Wed, 2008-12-03 at 17:33 +0800, Zhu Yi wrote:
> > On Mon, 2008-12-01 at 18:10 +0800, Helmut Schaa wrote:
> > > That only happens while associated. Scanning while not associated
> > > works like
> > > a charm.
> > > 
> > > Here are some more informations:
> > > If I load the unmodified module with debug=0x3FFF I get the following
> > > log
> > > when triggering a scan while associated:
> > > 
> > > ipw2200: U ipw_wx_set_scan Start scan
> > > 00000000 03 00 00 00 0D 24 28 2C  30 34 38 3C 40 95 99 9D   .....$(,
> > > 048<@...
> > > 00000010 A1 A5 4A 02 03 04 05 06  07 08 09 0A 0B 00 00
> > > 00   ..J..... ........
> > > 00000020 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00
> > > 00   ........ ........
> > > 00000030 00 00 00 00 00 00 00 00  00 00 03 33 31 11 13
> > > 33   ........ ...31..3
> > > 00000040 33 03 33 33 33 33 30 00  00 00 00 00 00 00 00 00
> > > 3.33330. ........
> > > 00000050 00 00 00 00 00 00 00 00  78 00 14 00 14 00 14 00   ........
> > > x.......
> > > martian source 255.255.255.255 from 149.44.170.156, on dev eth1
> > > ll header: ff:ff:ff:ff:ff:ff:00:19:99:28:58:5b:08:00
> > > ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> > > ipw2200: I ipw_rx_notification Scan result for channel 36
> > > ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> > > ipw2200: I ipw_rx_notification Scan result for channel 40
> > > ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> > > ipw2200: I ipw_rx_notification Scan result for channel 44
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 12 (46 bytes)
> > > ipw2200: I ipw_rx_notification Scan result for channel 48
> > > 
> > > The channels 36-48 are active 11a channels. The next channel would be
> > > 52 which
> > > is a passive channel.
> > > 
> > > martian source 255.255.255.255 from 149.44.170.66, on dev eth1
> > > ll header: ff:ff:ff:ff:ff:ff:00:0e:0c:aa:5c:c5:08:00
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 25 (4 bytes)
> > > ipw2200: I ipw_rx_notification type = 17 (8 bytes)
> > > ipw2200: I ipw_handle_missed_beacon Aborting scan with missed beacon.
> > > ipw2200: I ipw_handle_missed_beacon Missed beacon: 1
> > > 
> > > Aha, the firmware noticed a beacon miss before the scan watchdog
> > > restarts the firmware (the log is without timestamps, sorry).
> > > 
> > > ipw2200: I ipw_rx_notification type = 13 (4 bytes)
> > > ipw2200: I ipw_rx_notification Scan completed: type 1, 5 channels, 2
> > > status
> > > 
> > > Status 2 -> Scan aborted.
> > 
> > We will look at this.
> 
> Sorry for the late reply.

No problem.

> We look at the firmware. If the dwell time is set longer than the time
> remaining for firmware to switch back before DTIM TBTT, the firmware
> will discard this request without feeding back any notifications. So if
> we set passive dwell to 120, it is possible the scan request is ignored
> by firmware (assume beacon interval is 100, DTIM for every other
> beacon). But the firmware is not stuck in this case, it just won't send
> us scan notifications any more.

I see! Thanks for the explanation.

> So your patch is correct. Can you please remove the scan watchdog part
> and resend it?

Sure, will do.

Helmut
