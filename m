Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:36010 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235AbZHQWfr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 18:35:47 -0400
Received: from list by lo.gmane.org with local (Exim 4.50)
	id 1MdAAS-0007Rz-OY
	for linux-wireless@vger.kernel.org; Mon, 17 Aug 2009 23:55:04 +0200
Received: from lister.visitors.farnz.org.uk ([81.187.250.196])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 23:55:04 +0200
Received: from simon by lister.visitors.farnz.org.uk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 23:55:04 +0200
To: linux-wireless@vger.kernel.org
From: Simon Farnsworth <simon@farnz.org.uk>
Subject: Regulatory problems with ath5k in AP mode
Date: Mon, 17 Aug 2009 21:27:06 +0100
Message-ID: <h6ced0$hoi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello,

I'm facing problems using two ath5k miniPCI cards in a single box as a
dual-band access point. I'm using wireless-testing as of commit
d5a88a192e556a7c30f9d425bb6673b5bff5e3f3.

As I'm trying to use the cards for AP mode, I cannot rely on beacons with
regulatory data being present; instead, I have modprobe configured to run
"iw reg set GB" after cfg80211 is loaded, and hostapd.conf files containing
the line "country_code=GB".

My cards both have a regdomain in the EEPROM of 0x0, which my vendor assures
me is the correct regdomain for cards which don't claim any particular
regulatory compliance, and which rely on the host OS getting regulatory
compliance right. I am seeing two problems; firstly, the regulatory
infrastructure insists that I'm in the United States, thus preventing legal
use of the WiFi bands, but allowing me illegal use.

Secondly, I'm seeing different regulatory settings on each card. "iw list"
shows me that in the 2GHz band, phy1 is being allowed to use 27.0 dBm on
channels 1-11, whereas I'm only allowed to use 20.0 dBm, but I'm allowed
channels 1-13. In the 5GHz band, phy1 is allowed 17.0 dBm on channels 36-48,
to my local regulation's 20.0 dBm, reduced power in the (unusable as yet due
to driver limitations) DFS-only channels between 5.490 GHz and 5.710 GHz,
and 30 dBm in the illegal channels for my region of 149 to 165.

On phy0, I see that I'm being permitted 20.0 dBm in the 2GHz band (but still
only channels 1-11, and no beaconing permitted in the 5GHz band.

How do I persuade the Atheros drivers that, since I'm using AP mode, the
user-set regulatory domain is correct, and that the domain it selects for
EEPROM regdomain 0x0 is wrong?

Ideally, I would expect both cards to have the same regulatory rules
applied; I would further expect to be able to select a different country's
regulations to the ones selected by default, without losing the card's
calibration settings (which I believe are stored in a way that depends on
the EEPROM regdomain setting). I should note that I'm happy to run a
privately patched kernel, if that's the only way to do what I want, but I'm
still concerned about the differing regulatory rules between the two cards.

The relevant chunk of dmesg follows, and I can provide any other needed
information upon request:

[    1.857433] cfg80211: Calling CRDA to update world regulatory domain
[    1.891579] cfg80211: Calling CRDA for country: GB
[    2.015975] ath5k 0000:02:04.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    2.016204] ath5k 0000:02:04.0: registered as 'phy0'
[    2.152564] ath: EEPROM regdomain: 0x0
[    2.152574] ath: EEPROM indicates default country code should be used
[    2.152580] ath: doing EEPROM country->regdmn map search
[    2.152589] ath: country maps to regdmn code: 0x3a
[    2.152595] ath: Country alpha2 being used: US
[    2.152601] ath: Regpair used: 0x3a
[    2.264328] phy0: Selected rate control algorithm 'minstrel'
[    2.264822] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
[    2.265041]   alloc irq_desc for 17 on node -1
[    2.265048]   alloc kstat_irqs on node -1
[    2.265066] ath5k 0000:02:08.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    2.265276] ath5k 0000:02:08.0: registered as 'phy1'
[    2.400795] ath: EEPROM regdomain: 0x0
[    2.400805] ath: EEPROM indicates default country code should be used
[    2.400812] ath: doing EEPROM country->regdmn map search
[    2.400821] ath: country maps to regdmn code: 0x3a
[    2.400827] ath: Country alpha2 being used: US
[    2.400832] ath: Regpair used: 0x3a
[    2.400924] cfg80211: Calling CRDA for country: US
[    2.403133] phy1: Selected rate control algorithm 'minstrel'
[    2.403636] ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
[    2.403867] cfg80211: Calling CRDA for country: US
[    3.076972] cfg80211: Current regulatory domain intersected:
[    3.077089]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    3.077277]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.077386]  (2457000 KHz - 2472000 KHz @ 15000 KHz), (300 mBi, 2000 mBm)
[    3.077494]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    3.077602]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.082954] cfg80211: Current regulatory domain intersected:
[    3.083078]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    3.083278]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[    3.083392]  (2457000 KHz - 2472000 KHz @ 15000 KHz), (300 mBi, 2000 mBm)
[    3.083504]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
[    3.083616]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)

- -- 
Thanks in advance for your help,

Simon Farnsworth
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqJvRoACgkQSWe+XpRKvi0LrwCfVEMPoShTcFGE3SMTJyv0tT6u
IHQAnjCelYIVpCaxEoZIvKpUzQB9tJn1
=FGOO
-----END PGP SIGNATURE-----


