Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:52493 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755238Ab0C1VAa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Mar 2010 17:00:30 -0400
Received: from intrepid.localdomain (intrepid.localdomain [10.0.0.2])
	by khc.piap.pl (Postfix) with ESMTP id 8061C9393
	for <linux-wireless@vger.kernel.org>; Sun, 28 Mar 2010 22:52:40 +0200 (CEST)
From: Krzysztof Halasa <khc@pm.waw.pl>
To: linux-wireless@vger.kernel.org
Subject: CRDA and ath5k with no country code in EEPROM
Date: Sun, 28 Mar 2010 22:52:39 +0200
Message-ID: <m3tys0tbhk.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure I get it right:
I have an ath5k card without a country code in EEPROM. I think such card
is supposed to not force any additional restrictions, am I wrong?
The problem is "no country code" is effectively equal to US, i.e. it's
forcing additional US restrictions no matter what the actual regdomain
is.

Linux 2.6.33.

ath5k 0000:00:0d.0: registered as 'phy0'
ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'pid'
ath5k phy0: Atheros AR5213A chip found (MAC: 0x59, PHY: 0x43)
ath5k phy0: RF5112B multiband radio found (0x36)
cfg80211: Calling CRDA for country: US
cfg80211: Regulatory domain changed to country: US
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5490000 KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5650000 KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
    (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

Then I "iw reg set PL":

cfg80211: Calling CRDA for country: PL
cfg80211: Regulatory domain changed to country: PL
    (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
    (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
    (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

and I still get:
# iw list|grep disabled
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                        * 2484 MHz [14] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
while at least channels 12 and 13 should be enabled here (and they are
when I plug a card with European country code).

I'm told ath9k does the same.

Comments?
Please Cc: me, thanks.
--
Krzysztof Halasa
