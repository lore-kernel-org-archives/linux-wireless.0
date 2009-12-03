Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from outpost1.zedat.fu-berlin.de ([130.133.4.66]:44677 "EHLO
	outpost1.zedat.fu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753552AbZLCL1S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 06:27:18 -0500
Received: from inpost2.zedat.fu-berlin.de ([130.133.4.69])
          by outpost1.zedat.fu-berlin.de (Exim 4.69)
          for linux-wireless@vger.kernel.org with esmtp
          (envelope-from <mphilipp@inf.fu-berlin.de>)
          id <1NG9Q6-0006q0-Fj>; Thu, 03 Dec 2009 12:00:22 +0100
Received: from paracel.mi.fu-berlin.de ([160.45.111.20])
          by inpost2.zedat.fu-berlin.de (Exim 4.69)
          for linux-wireless@vger.kernel.org with esmtpsa
          (envelope-from <mphilipp@inf.fu-berlin.de>)
          id <1NG9Q6-0003AT-Dr>; Thu, 03 Dec 2009 12:00:22 +0100
Message-ID: <4B179A56.7010206@inf.fu-berlin.de>
Date: Thu, 03 Dec 2009 12:00:38 +0100
From: Matthias Philipp <mphilipp@inf.fu-berlin.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Non-deterministic regulatory domain intersection
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

we observe a strange regulatory issue in a setup with two Atheros cards 
in one machine. Occasionally after reboot the regulatory domain of the 
cards (AT) gets intersected with the world regulatory domain, resulting 
in a very restrictive setup. However, sometimes the regulatory domain is 
properly set on the very same machine.

We are using kernel 2.6.32 as was published today and two AR5414 based 
mini-PCI cards. Guessing from the dmesg output, the issue maybe related 
with the time when the regulatory daemon returns the requested domain 
and when ath5k recognizes the second card.

dmesg output of intersected regulatory domain:

[   26.458193] cfg80211: Calling CRDA to update world regulatory domain
[   27.402333] cfg80211: World regulatory domain updated:
[   27.412649]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   27.419978]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.426874]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   27.433773]  (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   27.440672]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.447570]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   27.834586] ath5k 0000:00:0c.0: registered as 'phy0'
[   28.026534] ath: EEPROM regdomain: 0x37
[   28.026534] ath: EEPROM indicates we should expect a direct regpair map
[   28.026534] ath: Country alpha2 being used: AT
[   28.026534] ath: Regpair used: 0x37
[   28.786601] eth0: no IPv6 routers present
[   28.801191] phy0: Selected rate control algorithm 'pid'
[   28.808034] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
[   28.820035] cfg80211: Calling CRDA for country: AT
[   28.827570] ath5k 0000:00:0e.0: registered as 'phy1'
[   29.020489] ath: EEPROM regdomain: 0x37
[   29.020489] ath: EEPROM indicates we should expect a direct regpair map
[   29.020489] ath: Country alpha2 being used: AT
[   29.020489] ath: Regpair used: 0x37
[   29.027343] phy1: Selected rate control algorithm 'pid'
[   29.034181] ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
[   29.044139] cfg80211: Calling CRDA for country: AT
[   29.119102] cfg80211: Current regulatory domain intersected:
[   29.119652]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   29.132342]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   29.133196]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   29.145384]  (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
[   29.146298]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   29.289911] cfg80211: Current regulatory domain intersected:
[   29.290114]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   29.303110]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   29.303952]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[   29.316119]  (2474000 KHz - 2482000 KHz @ 8000 KHz), (N/A, 2000 mBm)
[   29.317033]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)


dmesg output of normal behavior (same machine):

[   28.888452] cfg80211: Calling CRDA to update world regulatory domain
[   30.229001] cfg80211: World regulatory domain updated:
[   30.239410]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   30.247324]  (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   30.254235]  (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   30.261133]  (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   30.268032]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   30.274931]  (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   30.690239] ath5k 0000:00:0c.0: registered as 'phy0'
[   30.882182] ath: EEPROM regdomain: 0x37
[   30.882182] ath: EEPROM indicates we should expect a direct regpair map
[   30.882182] ath: Country alpha2 being used: AT
[   30.882182] ath: Regpair used: 0x37
[   31.183050] phy0: Selected rate control algorithm 'pid'
[   31.189902] ath5k phy0: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)
[   31.200300] cfg80211: Calling CRDA for country: AT
[   31.207977] ath5k 0000:00:0e.0: registered as 'phy1'
[   31.406746] ath: EEPROM regdomain: 0x37
[   31.406746] ath: EEPROM indicates we should expect a direct regpair map
[   31.406746] ath: Country alpha2 being used: AT
[   31.406746] ath: Regpair used: 0x37
[   31.420436] cfg80211: Regulatory domain changed to country: AT
[   31.426803]  (start_freq - end_freq @ bandwidth), (max_antenna_gain, 
max_eirp)
[   31.434139]  (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   31.435048]  (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   31.447141]  (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   31.448061]  (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   31.467813] phy1: Selected rate control algorithm 'pid'
[   31.515677] ath5k phy1: Atheros AR5414 chip found (MAC: 0xa5, PHY: 0x61)


Any hints how to resolve the issue would be very appreciated. We would 
also be happy to provide further information, if needed.

Best regards,
Matthias Philipp

-- 
http://www.des-testbed.net/
