Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from SpacedOut.fries.net ([67.64.210.234]:39837 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2B0DSk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Feb 2012 22:18:40 -0500
Date: Sun, 26 Feb 2012 21:12:32 -0600
From: David Fries <david@fries.net>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Subject: ath5k phy0: gain calibration timeout
Message-ID: <20120227031232.GA1190@spacedout.fries.net> (sfid-20120227_041906_901574_31E6AB7D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wireless network stopped working after 22 hours with ath5k, I have the
following message repeating, suspending to ram and back was enough to
get it talking again.
ath5k phy0: gain calibration timeout (2462MHz)

I previously was running 3.2-rc5 for a month and a half straight
without any wireless issues, I just upgraded to 3.3-rc1, the message
started 22 hours after booting the newer kernel.  This ath5k is
running hostapd 1:0.7.3-4 with WPA-EAP and had no clients for the 12
hours before the calibration message started, and had no clients for
hours after until I tried to connect and found I couldn't.
While I was unable to connect, I flipped
the laptop rfkill switch and the gain calibration timeouts continued,
disabling rfkill and they still continued.  That's when I did a
suspend to memory and resume and found it recovered.  While it was
working I tried rfkill and it no longer was talking after disabling
rfkill, I thought it was resuming previously, but I don't use that
very often.

I revered the following two comments and will see if I run into any
more problems.  I can test patches.
ath5k: We always do full calibration on AR5210
dafae6af0336958e9e2eb67cc5e4e31d6d13b308
ath5k: Calibration re-work
ce169aca0d823d38465127023e3d571816e6666c

Feb 24 21:54:23 Pulsar kernel: ath5k 0000:06:02.0: registered as 'phy0'
Feb 24 21:54:23 Pulsar kernel: ath: EEPROM regdomain: 0x63
Feb 24 21:54:23 Pulsar kernel: ath: EEPROM indicates we should expect a direct regpair map
Feb 24 21:54:23 Pulsar kernel: ath: Country alpha2 being used: 00
Feb 24 21:54:23 Pulsar kernel: ath: Regpair used: 0x63
Feb 24 21:54:23 Pulsar kernel: ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Feb 24 21:54:23 Pulsar kernel: ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
Feb 24 21:54:23 Pulsar kernel: device wlan0 entered promiscuous mode
Feb 24 21:54:23 Pulsar kernel: br0: port 2(wlan0) entering forwarding state
Feb 24 21:54:23 Pulsar kernel: br0: port 2(wlan0) entering forwarding state
Feb 24 21:58:59 Pulsar kernel: ath5k 0000:06:02.0: registered as 'phy0'
Feb 24 21:58:59 Pulsar kernel: ath: EEPROM regdomain: 0x63
Feb 24 21:58:59 Pulsar kernel: ath: EEPROM indicates we should expect a direct regpair map
Feb 24 21:58:59 Pulsar kernel: ath: Country alpha2 being used: 00
Feb 24 21:58:59 Pulsar kernel: ath: Regpair used: 0x63
Feb 24 21:58:59 Pulsar kernel: ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Feb 24 21:58:59 Pulsar kernel: ath5k phy0: Atheros AR2413 chip found (MAC: 0x78, PHY: 0x45)
Feb 24 21:58:59 Pulsar kernel: device wlan0 entered promiscuous mode
Feb 24 21:58:59 Pulsar kernel: br0: port 2(wlan0) entering forwarding state
Feb 24 21:58:59 Pulsar kernel: br0: port 2(wlan0) entering forwarding state
Feb 24 23:02:31 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 1
Feb 24 23:02:31 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 2
Feb 24 23:02:40 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 3
Feb 24 23:15:37 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 2
Feb 24 23:15:37 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 1
Feb 24 23:15:37 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 0
Feb 25 08:48:40 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 1
Feb 25 08:48:40 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 2
Feb 25 08:48:46 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 3
Feb 25 08:56:35 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 2
Feb 25 08:56:35 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 1
Feb 25 08:56:35 Pulsar kernel: wlan0: moving STA xx:xx:xx:xx:xx:xx to state 0
Feb 25 19:52:50 Pulsar kernel: ath5k phy0: gain calibration timeout (2462MHz)
Feb 25 19:52:51 Pulsar kernel: ath5k phy0: calibration of channel 11 failed
Feb 25 19:52:52 Pulsar kernel: ath5k phy0: gain calibration timeout (2462MHz)

iw wlan0 survey dump
Survey data from wlan0
        frequency:                      2462 MHz
        noise:                          -96 dBm
        channel active time:            79250 ms
        channel busy time:              118644 ms
        channel receive time:           48278 ms
        channel transmit time:          5285 ms

-- 
David Fries <david@fries.net>    PGP pub CB1EE8F0
http://fries.net/~david/
