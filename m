Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:33247 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750759Ab0AGXte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 18:49:34 -0500
Message-ID: <4B46730E.7000105@gmx.net>
Date: Fri, 08 Jan 2010 00:49:34 +0100
From: Rainer Koschnick <arkay@gmx.net>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath9k driver in kernel 2.6.33 problems
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been trying to use the last couple of 2.6.33 RCs up to rc3-git2 and
am experiencing connection issues with the ath9k driver.  It used to be
broken for me in kernel 2.6.31 (haven't tried earlier), then was
rock-solid in 2.6.32 and now it's broken again.  I can connect to my
300mbit router--which is in the same room--without problems, but after a
while the connection breaks.

Jan  7 22:36:27 gentoo kernel: [    5.819124] ath9k 0000:03:00.0: PCI
INT A -> GSI 18 (level, low) -> IRQ 18
Jan  7 22:36:27 gentoo kernel: [    5.819137] ath9k 0000:03:00.0:
setting latency timer to 64
Jan  7 22:36:27 gentoo kernel: [    5.869898] ath: EEPROM regdomain: 0x60
Jan  7 22:36:27 gentoo kernel: [    5.869900] ath: EEPROM indicates we
should expect a direct regpair map
Jan  7 22:36:27 gentoo kernel: [    5.869906] ath: Country alpha2 being
used: 00
Jan  7 22:36:27 gentoo kernel: [    5.869907] ath: Regpair used: 0x60
Jan  7 22:36:27 gentoo kernel: [    5.874261] phy0: Selected rate
control algorithm 'ath9k_rate_control'
Jan  7 22:36:27 gentoo kernel: [    5.875006] Registered led device:
ath9k-phy0::radio
Jan  7 22:36:27 gentoo kernel: [    5.875025] Registered led device:
ath9k-phy0::assoc
Jan  7 22:36:27 gentoo kernel: [    5.875074] Registered led device:
ath9k-phy0::tx
Jan  7 22:36:27 gentoo kernel: [    5.875098] Registered led device:
ath9k-phy0::rx
Jan  7 22:36:27 gentoo kernel: [    5.875113] phy0: Atheros AR9285 Rev:2
mem=0xffffc90011100000, irq=18

Jan  7 22:36:27 gentoo kernel: [   11.287482] ADDRCONF(NETDEV_UP):
wlan0: link is not ready
Jan  7 22:36:27 gentoo kernel: [   12.179291] Adding 8000328k swap on
/dev/sda5.  Priority:-1 extents:1 across:8000328k
Jan  7 22:36:27 gentoo kernel: [   13.014980] ath9k: Two wiphys trying
to scan at the same time
Jan  7 22:36:27 gentoo kernel: [   13.217106] wlan0: direct probe to AP
00:1f:3f:d3:4d:2a (try 1)
Jan  7 22:36:27 gentoo kernel: [   13.221958] wlan0: direct probe responded
Jan  7 22:36:27 gentoo kernel: [   13.221965] wlan0: authenticate with
AP 00:1f:3f:d3:4d:2a (try 1)
Jan  7 22:36:27 gentoo kernel: [   13.225266] wlan0: authenticated
Jan  7 22:36:27 gentoo kernel: [   13.225304] wlan0: associate with AP
00:1f:3f:d3:4d:2a (try 1)
Jan  7 22:36:27 gentoo kernel: [   13.229132] wlan0: RX AssocResp from
00:1f:3f:d3:4d:2a (capab=0x431 status=0 aid=1)
Jan  7 22:36:27 gentoo kernel: [   13.229137] wlan0: associated
Jan  7 22:36:27 gentoo kernel: [   13.237383] ADDRCONF(NETDEV_CHANGE):
wlan0: link becomes ready
Jan  7 22:36:27 gentoo dhcpcd: version 5.1.4 starting
Jan  7 22:36:27 gentoo dhcpcd: wlan0: rebinding lease of 192.168.1.120
Jan  7 22:36:31 gentoo dhcpcd: wlan0: reject NAK
Jan  7 22:36:37 gentoo kernel: [   24.189064] wlan0: no IPv6 routers present
Jan  7 22:36:37 gentoo dhcpcd: wlan0: broadcasting for a lease
Jan  7 22:36:37 gentoo dhcpcd: wlan0: offered 192.168.1.120 from 192.168.1.1
Jan  7 22:36:42 gentoo dhcpcd: wlan0: acknowledged 192.168.1.120 from
192.168.1.1
Jan  7 22:36:42 gentoo dhcpcd: wlan0: checking for 192.168.1.120
Jan  7 22:36:47 gentoo dhcpcd: wlan0: leased 192.168.1.120 for 864000
seconds
Jan  7 22:36:47 gentoo dhcpcd: forking to background

Jan  8 00:07:19 gentoo kernel: [ 5466.181635] wlan0: deauthenticated
from 00:1f:3f:d3:4d:2a (Reason: 2)
Jan  8 00:07:19 gentoo dhcpcd: wlan0: carrier lost
Jan  8 00:07:19 gentoo wpa_cli: interface wlan0 DISCONNECTED
Jan  8 00:07:21 gentoo kernel: [ 5467.472581] wlan0: direct probe to AP
00:1f:3f:d3:4d:2a (try 1)
Jan  8 00:07:21 gentoo kernel: [ 5467.477331] wlan0: direct probe responded
Jan  8 00:07:21 gentoo kernel: [ 5467.477338] wlan0: authenticate with
AP 00:1f:3f:d3:4d:2a (try 1)
Jan  8 00:07:21 gentoo kernel: [ 5467.480769] wlan0: authenticated
Jan  8 00:07:21 gentoo kernel: [ 5467.480802] wlan0: associate with AP
00:1f:3f:d3:4d:2a (try 1)
Jan  8 00:07:21 gentoo kernel: [ 5467.484611] wlan0: RX ReassocResp from
00:1f:3f:d3:4d:2a (capab=0x431 status=0 aid=1)
Jan  8 00:07:21 gentoo kernel: [ 5467.484616] wlan0: associated
Jan  8 00:07:21 gentoo dhcpcd: wlan0: carrier acquired
Jan  8 00:07:21 gentoo dhcpcd: wlan0: rebinding lease of 192.168.1.120
Jan  8 00:07:21 gentoo dhcpcd: wlan0: reject NAK
Jan  8 00:07:24 gentoo dhcpcd: received SIGTERM, stopping
Jan  8 00:07:24 gentoo dhcpcd: wlan0: removing interface
Jan  8 00:07:24 gentoo wpa_cli: interface wlan0 CONNECTED
Jan  8 00:07:24 gentoo dhcpcd: version 5.1.4 starting
Jan  8 00:07:24 gentoo dhcpcd: wlan0: rebinding lease of 192.168.1.120
Jan  8 00:07:24 gentoo dhcpcd: wlan0: reject NAK
Jan  8 00:07:28 gentoo dhcpcd: wlan0: reject NAK
Jan  8 00:07:32 gentoo dhcpcd: wlan0: reject NAK
Jan  8 00:07:34 gentoo dhcpcd: wlan0: broadcasting for a lease
Jan  8 00:07:34 gentoo dhcpcd: wlan0: offered 192.168.1.120 from 192.168.1.1
Jan  8 00:07:34 gentoo dhcpcd: wlan0: acknowledged 192.168.1.120 from
192.168.1.1
Jan  8 00:07:34 gentoo dhcpcd: wlan0: checking for 192.168.1.120
Jan  8 00:07:40 gentoo dhcpcd: wlan0: leased 192.168.1.120 for 864000
seconds
Jan  8 00:07:40 gentoo dhcpcd: forking to background

Is there anything else I could log?

Regards,
Rainer
