Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:42086 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819AbaEaQaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 12:30:25 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so3374982wes.14
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 09:30:23 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [PATCH 2/3] rtl818x_pci: provide dBm signal information for rtl8185
Date: Sat, 31 May 2014 18:30:13 +0200
Message-Id: <1401553813-7647-1-git-send-email-andrea.merello@gmail.com> (sfid-20140531_183029_829066_5A30F3E4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the driver report signal information for rtl8185
boards using dBm instead of unspecified unit.
Rtl8180 remains untouched.

I did some tests to confirm the correctness of the measure performed
by the board and it seems reasonably correct.

The test setup has been made by connecting an AP with coax and
RF attenuators to the card antenna port.

In order to get a reference measure I tried with several cards with
different chipset I own. I found that many gave different results, and
I finally selected two cards that gave me consistent results to use
as reference: AR9271 and Prism54-usb (isl3887 with Frisbee radio).

Using this references I compared the RSSI information with my rtl8185
and I repeated tests with three different attenuation values, increasing
attenuation by 10dB each step.
I made only relative measures, making NO assumption about source power.

CCK measures seem very close to my references, OFDM are a little bit
less precise but, considering that these cards are not measuring
instrumentation, IMHO this is still fairly good.

CCK measures (1Mbps beacons)

 ATTENUATOR 1
p54usb:    -58dBm
ath9k_htc: -59dBm
rtl8185:   -59dBm

 ATTENUATOR 2
p54usb:    -67dBm
ath9k_htc: -68dBm
rtl8185:   -70dBm

 ATTENUATOR 3
p54usb:    -78dBm
ath9k_htc: -79dBm
rtl8185:   -79dBm

OFDM measures (54Mbps ping)

 ATTENUATOR 1
p54usb:    -58dBm
ath9k_htc: -57dBm
rtl8185:   -62dBm

 ATTENUATOR 2
p54usb:    -68dBm
rtl8185:   -71dBm

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index c2dd5e6..cd8c090 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -269,9 +269,9 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			switch (priv->chip_family) {
 			case RTL818X_CHIP_FAMILY_RTL8185:
 				if (rx_status.rate_idx > 3)
-					signal = 90 - clamp_t(u8, agc, 25, 90);
+					signal = -clamp_t(u8, agc, 25, 90) - 9;
 				else
-					signal = 95 - clamp_t(u8, agc, 30, 95);
+					signal = -clamp_t(u8, agc, 30, 95);
 				break;
 			case RTL818X_CHIP_FAMILY_RTL8180:
 				sq = flags2 & 0xff;
@@ -1754,8 +1754,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 	dev->wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
 
 	dev->flags = IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-		     IEEE80211_HW_RX_INCLUDES_FCS |
-		     IEEE80211_HW_SIGNAL_UNSPEC;
+		IEEE80211_HW_RX_INCLUDES_FCS;
 	dev->vif_data_size = sizeof(struct rtl8180_vif);
 	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 					BIT(NL80211_IFTYPE_ADHOC);
@@ -1812,6 +1811,11 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		pci_try_set_mwi(pdev);
 	}
 
+	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
+		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
+	else
+		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
+
 	rtl8180_eeprom_read(priv);
 
 	switch (priv->rf_type) {
-- 
1.9.1

