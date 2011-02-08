Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33802 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114Ab1BHILo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:11:44 -0500
Received: by bwz15 with SMTP id 15so5756918bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Feb 2011 00:11:43 -0800 (PST)
Message-ID: <4D50FABC.90401@googlemail.com>
Date: Tue, 08 Feb 2011 09:11:40 +0100
From: Dennis Borgmann <dennis.borgmann@googlemail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ath5k: AP throughput and signal strength problem
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello linux-wireless!
Hello hostapd-users!

I observe some remarkable behavior of the ath5k-driver/nl80211/hostapd -
I don't know, which one makes me sad. Maybe, it's even me being the
problem, so I would have a problem configuring or a problem with cfg80211.

All the following bases on antennas used with 5dBi gain.

I have an AP using ath5k in version 0.6.0 running on kernel 2.6.33.7, iw
in version 0.9.21 and using hostapd 0.7.3. The wireless card is a
AWPC085 from AlfaNetwork with an AR5414 chip. There are two things, I
observe:

1. Thoughput measurements:
I have tried several setups with wireless interfaces. My reference was a
LinksysWRT54GL(http://www.linksysbycisco.com/DE/de/products/WRT54GL)
with DD-WRT(http://www.dd-wrt.com) being installed. I ran "iperf" on two
laptops associated wireless with the Linksys-AP, one laptop running the
old madwifi-driver, one running ath5k. Both reached around 27Mbit/s with
iperf and the Linksys-AP, while the iperf-server was on another machine
for not blasting the AP with CPU-load due to iperf.
Then - same setup with an AP based on an ALIX-board from
PC-Engines(http://pcengines.ch/alix3d2.htm). Data rates with iperf only
up to 6Mbit/s. The AP shows:

# iw dev wlan0 station
dump


Station xx:xx:xx:xx:xx:xx (on
wlan0)


        inactive time:  23559
ms


        rx bytes:
15480534


        rx packets:
10217


        tx bytes:
20534


        tx packets:
112


        signal:         -33
dBm


        tx bitrate:     11.0 MBit/s

So the bitrate is far too low to gain higher values, but the AP is
placed 3m line-of-sight next to the laptop and still the value for tx
bitrate is this bad. I would suggest it being higher. How come? And why
is the Linksys so much faster with the same laptops associated?

2. Signal strength measurements:
In addition, the signal levels are in general about 10dBm lower than the
ones of the Linksys if I start moving around. I made no adjustments at
the tx power rates - neither at the Linksys nor at the Atheros-device.
And still, I observe this:

I am using a program called airview from Ubiquity to analyze the traffic
and strength of signals in the air: http://www.ubnt.com/airview

What I can observe is, that as long as the Atheros-AP only transmits
beacons, its output power is around 5dBm below the power measured once
there is traffic on the interface (I am doing a simple "ping <IP> -f").
The client is situated far away from both the AP and the measuring
Laptop with "airview" in order not to disturb the measurement.

The problem I would suggest from this measurement is, that I a client
standing quite far away from the AP not finding the AP as long as it
only transmits beacons - although the signal would still be good enough
since the output power would be higher, if there was traffic.

And in fact - I can observe this problem. If I move far away from the
AP, at a certain point I can still receive beacons from the
Linksys-machine, but no more beacons from the Atheros-AP with ath5k. So
the client won't associate with the Atheros ath5k-AP, but with the
Linksys. If I associate with the Atheros-AP before, there will still be
a connection with data throughput possible.

Am I wrong? How to put up the output power while transmitting beacons?
In general, the Linksys is according to my tests more powerful than the
Atheros-AP. At least with my current setup. I'd like to turn this around
and make the Atheros-AP become stronger ;-)

Thanks for any hint,
Dennis Borgmann
