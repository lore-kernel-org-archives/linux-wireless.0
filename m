Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f227.google.com ([209.85.220.227]:34842 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab0BNNFF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 08:05:05 -0500
Received: by fxm27 with SMTP id 27so244354fxm.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2010 05:05:03 -0800 (PST)
MIME-Version: 1.0
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 14 Feb 2010 08:04:43 -0500
Message-ID: <cb0375e11002140504u4dd18ba9sb4c0790d2aade23@mail.gmail.com>
Subject: ath9k in AP mode got stuck
To: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all-

I have a new AP running OpenWrt trunk (Ubiquiti Routerstation Pro)
with hostapd and an AR9280-based NIC (Mikrotik R52n):

ath: EEPROM regdomain: 0x0
ath: EEPROM indicates default country code should be used
ath: doing EEPROM country->regdmn map search
ath: country maps to regdmn code: 0x3a
ath: Country alpha2 being used: US
ath: Regpair used: 0x3a
phy0: Selected rate control algorithm 'ath9k_rate_control'
Registered led device: ath9k-phy0::radio
Registered led device: ath9k-phy0::assoc
Registered led device: ath9k-phy0::tx
Registered led device: ath9k-phy0::rx
phy0: Atheros AR9280 Rev:2 mem=0xb0000000, irq=48

It works great, except that this morning I couldn't connect.  Some
quick tcpdump tests on the monitor interface show that it thinks it's
sending probe responses and deauthentication frames but all that's
really coming out (seen from my laptop, running a monitor interface on
iwlagn) are beacons and ACKs.

Running 'iwconfig wlan0 channel 10; iwconfig wlan0 channel 11' made it
work again, albeit very slowly -- the AP refused to transmit above
1Mbps and my laptop only hit 36Mbps.

Any ideas or things to look at next time this happens?

As far as I can tell, the board is running 2.6.32 with the wireless
bits from compat-wireless-2010-01-25.  The only suspicious patch I see
is this:

--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2087,7 +2087,7 @@ int ath9k_hw_reset(struct ath_hw *ah, st

        if (ah->config.rx_intr_mitigation) {
                REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_LAST, 500);
-               REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
+               REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 500);
        }

        ath9k_hw_init_bb(ah, chan);

which doesn't look like I should blame it.

Thanks,
Andy
