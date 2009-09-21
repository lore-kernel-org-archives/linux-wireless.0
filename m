Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f210.google.com ([209.85.218.210]:65090 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbZIUSTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2009 14:19:33 -0400
Received: by bwz6 with SMTP id 6so2124080bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2009 11:19:35 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 21 Sep 2009 14:19:35 -0400
Message-ID: <76516bfc0909211119i4362ca35k13fc1f87857fb393@mail.gmail.com>
Subject: p54spi: dbm_antsignal value, is it RSSI or dbm?
From: Andre K <andrekdeen@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I've been using the new p54spi driver on a couple of n800s. Some specifics:
Kernel : 2.6.29-omap1
Wireless-compat: compat-wireless-2009-08-22
OS: Maemo
Options:  disabled CONFIG_RFKILL_BACKPORT_LEDS because it didn't compile

The driver loads and functions normally. However, the values for the
dbm_antsignal (from RadioTap header), are they RSSI or dbm? Initially
I thought they were dbm since tcpdump showed negative values, which
makes sense:

14:05:39.458831 8602124us tsft 1.0 Mb/s 2412 MHz (0x00a0) -46dB signal
-60dB noise antenna 0 [0x0000000e] Beacon (**SSID_REMOVED**) [1.0*
2.0* 5.5* 11.0* 6.0 9.0 12.0 18.0 Mbit] ESS CH: 1, PRIVACY
14:05:39.461090 8603807us tsft 1.0 Mb/s 2412 MHz (0x00a0) -52dB signal
-60dB noise antenna 0 [0x0000000e] Beacon (**SSID_REMOVED**) [1.0*
2.0* 5.5* 11.0* 6.0 12.0 24.0 36.0 Mbit] ESS CH: 1, PRIVACY
14:05:39.506713 8652588us tsft 1.0 Mb/s 2412 MHz (0x00a0) -52dB signal
-60dB noise antenna 0 [0x0000000e] Beacon (**SSID_REMOVED**) [1.0*
2.0* 5.5* 11.0* Mbit] ESS CH: 1, PRIVACY
14:05:39.541900 8687877us tsft 1.0 Mb/s 2412 MHz (0x00a0) -47dB signal
-60dB noise antenna 0 [0x0000000e] Beacon (**SSID_REMOVED**)[|802.11]

Output of iwconfig:
          wlan0     IEEE 802.11bg  Mode:Monitor  Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off

However, when I select a channel (6 in this case) its starts to behave
strangely:
Output of iwconfig:
          wlan0     IEEE 802.11bg  Mode:Monitor  Frequency:2.437 GHz
Tx-Power=27 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Power Management:off

Tcpdump:
14:08:25.312988 4469382526us tsft 2.0 Mb/s 2437 MHz (0x00a0) -49dB
signal -41dB noise antenna 0 [0x0000000e] Acknowledgment
RA:00:1d:e0:3d:5a:53 (oui Unknown)
14:08:25.313903 4469383345us tsft 1.0 Mb/s 2437 MHz (0x00a0) 4dB
signal -41dB noise antenna 0 [0x0000000e] 04:c2:08:00:07:07 (oui
Unknown) Unknown SSAP 0x0a >

Which shows up the first positive dbm value. Next I set up another
n800 to broadcast ping packets (using hping3, since busybox's ping
doesn't allow broadcast).

14:12:22.066192 13296010370us tsft 1.0 Mb/s 2437 MHz (0x00a0) 87dB
signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
192.168.10.255: ICMP echo request, id 6662, seq 40704, length 8
14:12:22.092376 13296036864us tsft 18.0 Mb/s 2437 MHz (0x00c0) 82dB
signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
192.168.10.255: ICMP echo request, id 6662, seq 40960, length 8
14:12:22.094787 13296037678us tsft 1.0 Mb/s 2437 MHz (0x00a0) 112dB
signal -62dB noise antenna 0 [0x0000000e] IP 192.168.10.11 >
192.168.10.255: ICMP echo request, id 6662, seq 40960, length 8


I get strange dbm values, in the range of 50 - 100dbm, which doesn't
make much sense.

Does anyone have an idea what value is being returned and if there is
an error in the dbm calculation?

Thanks,
Andre.

P.S. Would be happy to provide more info. and feedback.
