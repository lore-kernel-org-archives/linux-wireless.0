Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.186]:7887 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYLAKKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 05:10:30 -0500
Received: by fk-out-0910.google.com with SMTP id 18so2411148fkq.5
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 02:10:28 -0800 (PST)
To: Zhu Yi <yi.zhu@intel.com>
Subject: Re: [Ipw2100-devel] [PATCH] ipw2200: rework scan handling while associated
Date: Mon, 1 Dec 2008 11:10:02 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
References: <200811261805.39953.helmut.schaa@gmail.com> <200811281031.04996.helmut.schaa@gmail.com> <1228100318.2558.152.camel@debian.sh.intel.com>
In-Reply-To: <1228100318.2558.152.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812011110.02974.helmut.schaa@gmail.com> (sfid-20081201_111036_702987_2E180CF5)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Dezember 2008 schrieb Zhu Yi:
> On Fri, 2008-11-28 at 17:31 +0800, Helmut Schaa wrote:
> > Hmm, I was able to reproduce the firmware looping endlessly reasonably
> > reliable (turned off the beacon-miss-cancels-scan-behaviour and increased the
> > scan watchdog timeout) and the ABORT_SCAN command was processed in that case
> > and canceled the scan which resulted in a
> > HOST_NOTIFICATION_STATUS_SCAN_COMPLETED notification with status 2 (not sure
> > if it really was 2). 
> 
> '2' is SCAN_COMPLETED_STATUS_ABORTED.

Right. That's what I got.

> > So, at least the failure I noticed here could be corrected
> > by aborting the scan instead of restarting the adapter.
> >
> > What about the following:
> > After the first scan timeout we try to cancel the scan and if that does not
> > succeed in a few seconds we can still restart the fw.
> 
> A watchdog is used to prevent unpredictable firmware hangs. In your
> report, the firmware hang has a predictable pattern. We should focus on
> resolving the real problem than workaround this issue.

Agreed. This part of the patch should not be necessary when either the third
part of the patch is applied or the firmware's behavior is fixed.

> > I see the timeout because the firmware will never stop scanning until either
> > the beacon miss notification cancels the scan or the IPW_SCAN_CHECK_WATCHDOG
> > timeout restarts the adapter. I already tried a scan timeout of 25 seconds but
> > the firmware insists on scanning the first passive channel (in my setup 52)
> > over and over again.
> 
> >From what you are saying, it looks like we have a real bug here. Why the
> firmware keep sticking in the passive channel if dwell >
> beacon_interval? I didn't see this in our testing environment. Normally
> my scan for 24 channels takes about 1 second.

That only happens while associated. Scanning while not associated works like
a charm.

Here are some more informations:
If I load the unmodified module with debug=0x3FFF I get the following log
when triggering a scan while associated:

ipw2200: U ipw_wx_set_scan Start scan
00000000 03 00 00 00 0D 24 28 2C  30 34 38 3C 40 95 99 9D   .....$(, 048<@...
00000010 A1 A5 4A 02 03 04 05 06  07 08 09 0A 0B 00 00 00   ..J..... ........
00000020 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00   ........ ........
00000030 00 00 00 00 00 00 00 00  00 00 03 33 31 11 13 33   ........ ...31..3
00000040 33 03 33 33 33 33 30 00  00 00 00 00 00 00 00 00   3.33330. ........
00000050 00 00 00 00 00 00 00 00  78 00 14 00 14 00 14 00   ........ x.......
martian source 255.255.255.255 from 149.44.170.156, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:19:99:28:58:5b:08:00
ipw2200: I ipw_rx_notification type = 12 (46 bytes)
ipw2200: I ipw_rx_notification Scan result for channel 36
ipw2200: I ipw_rx_notification type = 12 (46 bytes)
ipw2200: I ipw_rx_notification Scan result for channel 40
ipw2200: I ipw_rx_notification type = 12 (46 bytes)
ipw2200: I ipw_rx_notification Scan result for channel 44
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 12 (46 bytes)
ipw2200: I ipw_rx_notification Scan result for channel 48

The channels 36-48 are active 11a channels. The next channel would be 52 which
is a passive channel.

martian source 255.255.255.255 from 149.44.170.66, on dev eth1
ll header: ff:ff:ff:ff:ff:ff:00:0e:0c:aa:5c:c5:08:00
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 25 (4 bytes)
ipw2200: I ipw_rx_notification type = 17 (8 bytes)
ipw2200: I ipw_handle_missed_beacon Aborting scan with missed beacon.
ipw2200: I ipw_handle_missed_beacon Missed beacon: 1

Aha, the firmware noticed a beacon miss before the scan watchdog
restarts the firmware (the log is without timestamps, sorry).

ipw2200: I ipw_rx_notification type = 13 (4 bytes)
ipw2200: I ipw_rx_notification Scan completed: type 1, 5 channels, 2 status

Status 2 -> Scan aborted.

The log shows the lucky situation that a beacon is missed as otherwise the
firmware is restarted and the association is lost. However in most cases at
least one beacon is missed and therefore the association is not lost but of
course the scan results only contain APs on channel 36-48.

> See above. I ack your idea 2. But 1 and 3 are workaround for a firmware
> stuck problem on scan. Let's try to solve the real problem before 
> considering these workarounds.

Sure. However if it is not possible to fix the firmware the driver should work
around this issue.

> Would you like to test some debug patches?

Sure, no problem. 

> We only send an empty scan event when the scan is completed successfully
> (vs. aborted). But user is still able to read the partial scan result
> even if the scan is aborted. The ieee->network_list is updated anyway.

Right, but a user space application should not poll the scan results if the
driver normally reports the scan results.

Helmut
