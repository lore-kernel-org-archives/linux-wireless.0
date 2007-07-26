Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:34841 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663AbXGZL3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 07:29:55 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id EC10C8CAD8
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 13:29:50 +0200 (CEST)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id D6245104BA
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jul 2007 11:31:33 +0000 (UTC)
Message-ID: <46A885A1.8000702@warmcat.com>
Date: Thu, 26 Jul 2007 12:29:37 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Bogus double self-monitoring with multiple interfaces
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

iwl3945 with wlan0 associated on to WPA and a secondary mon0 interface
set into monitor mode.

packetspammer is running on mon0 as well in another session.

Notice that tcpdump has -XX so the radiotap header is visible.

# tcpdump -i mon0 -s0 -XX ether host 13:22:33:44:55:66
...
12:01:04.673737 0us tsft 18.0 Mb/s 2417 MHz (0x00c0) -34dB signal 0dB
noise antenna 1 13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 >
13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags
[Response], length 77
        0x0000:  0000 1900 6f08 0000 0000 0000 0000 0000  ....o...........
        0x0010:  0024 7109 c000 de00 0108 0100 00ff ffff  .$q.............
        0x0020:  ffff ff13 2233 4455 6613 2233 4455 6610  ...."3DUf."3DUf.
        0x0030:  8650 6163 6b65 7473 7061 6d6d 6572 2031  .Packetspammer.1
        0x0040:  3862 726f 6164 6361 7374 2070 6163 6b65  8broadcast.packe
        0x0050:  7423 3030 3138 3020 2d2d 203a 2d44 202d  t#00180.--.:-D.-
        0x0060:  2d6d 6565 726b 6174 2e68 6f6d 652e 7761  -meerkat.home.wa
        0x0070:  726d 6361 742e 636f 6d20 2d2d 2d2d       rmcat.com.----
12:01:04.673755 [0x0000000f] 13:22:33:44:55:66 (oui Unknown) Unknown
SSAP 0x60 > 13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50
Unnumbered, ua, Flags [Response], length 77
        0x0000:  0000 0b00 0080 0200 0000 0008 0100 00ff  ................
        0x0010:  ffff ffff ff13 2233 4455 6613 2233 4455  ......"3DUf."3DU
        0x0020:  6610 8650 6163 6b65 7473 7061 6d6d 6572  f..Packetspammer
        0x0030:  2031 3862 726f 6164 6361 7374 2070 6163  .18broadcast.pac
        0x0040:  6b65 7423 3030 3138 3020 2d2d 203a 2d44  ket#00180.--.:-D
        0x0050:  202d 2d6d 6565 726b 6174 2e68 6f6d 652e  .--meerkat.home.
        0x0060:  7761 726d 6361 742e 636f 6d20 2d2d 2d2d  warmcat.com.----

Well as we noticed before in this mode with two interfaces we cannot
monitor external packetspammer traffic, so this traffic is actually our
transmit action inappropriately reflected into monitor mode.

Each injected transmit packet appears twice on the monitor interface,
once with a good radiotap header

0000 1900 6f08 0000 0000 0000 0000 0000 0024 7109 c000 de00 01

and then the same packet again (it was only transmitted once!  Each
packetspammer payload has an incrementing number and the rate it was
transmitted at) with a bogus radiotap header

0000 0b00 0080 0200 0000 00


I decided to try this test with only wlan0 interface set to monitor mode
and packetspammer on wlan0 as well.  But I was able to see only one
packet.....


# tcpdump -i wlan0 -s0 -XX ether host 13:22:33:44:55:66
tcpdump: WARNING: wlan0: no IPv4 address assigned
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on wlan0, link-type IEEE802_11_RADIO (802.11 plus BSD radio
information header), capture size 65535 bytes
12:03:38.477118 0us tsft 54.0 Mb/s 2417 MHz (0x00c0) -34dB signal 0dB
noise antenna 1 13:22:33:44:55:66 (oui Unknown) Unknown SSAP 0x60 >
13:22:33:44:55:66 (oui Unknown) Unknown DSAP 0x50 Unnumbered, ua, Flags
[Response], length 77
        0x0000:  0000 1900 6f08 0000 0000 0000 0000 0000  ....o...........
        0x0010:  006c 7109 c000 de00 0108 0100 00ff ffff  .lq.............
        0x0020:  ffff ff13 2233 4455 6613 2233 4455 6610  ...."3DUf."3DUf.
        0x0030:  8650 6163 6b65 7473 7061 6d6d 6572 2035  .Packetspammer.5
        0x0040:  3462 726f 6164 6361 7374 2070 6163 6b65  4broadcast.packe
        0x0050:  7423 3030 3030 3020 2d2d 203a 2d44 202d  t#00000.--.:-D.-
        0x0060:  2d6d 6565 726b 6174 2e68 6f6d 652e 7761  -meerkat.home.wa
        0x0070:  726d 6361 742e 636f 6d20 2d2d 2d2d       rmcat.com.----

... before the tcpdump and packetspammer processes froze, and on
modprobe -r iwl3945 the whole machine froze.  Repeating the test got me
another freeze just from running packetspammer on wlan0 alone.

-Andy
