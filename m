Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f228.google.com ([209.85.220.228]:50169 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787AbZHJWhX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 18:37:23 -0400
Received: by fxm28 with SMTP id 28so1208119fxm.17
        for <linux-wireless@vger.kernel.org>; Mon, 10 Aug 2009 15:37:23 -0700 (PDT)
Message-ID: <4A80A120.30607@gmail.com>
Date: Tue, 11 Aug 2009 00:37:20 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH RFC] b43: LP-PHY: Implement reading band SPROM
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the new variables in b43_phy_lp appear to be dead code in
the vendor driver; they will be removed if they remain unused when
LP-PHY implementation is finished.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
I've added a few FIXME comments, please review them.
Also please check that I used the correct types (e.g. u16) for the new variables.

Variable name mappings vs. the specification:
cckpo = tmp3
ofdmpo = tmp2
maxpwr = tmp1

The array txpwr_srom_max[3] has been broken up into 3 variables,
each called max_tx_pwr_{low|med|hi}_band. A struct holding 3 named u16s
may also be a good choice, but I am not fond of using an array for this.
 
 drivers/net/wireless/b43/phy_lp.c |   83 ++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_lp.h |   16 +++++++
 2 files changed, 98 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 43272a8..46fe476 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -59,6 +59,87 @@ static void b43_lpphy_op_free(struct b43_wldev *dev)
 	dev->phy.lp = NULL;
 }
 
+static void lpphy_read_band_sprom(struct b43_wldev *dev)
+{
+	struct b43_phy_lp *lpphy = dev->phy.lp;
+	struct ssb_bus *bus = dev->dev->bus;
+	u16 cckpo, maxpwr;
+	u32 ofdmpo;
+	int i;
+
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		lpphy->tx_isolation_med_band = bus->sprom.tri2g;
+		lpphy->bx_arch = bus->sprom.bxa2g;
+		lpphy->rssi_vf = bus->sprom.rssismf2g;
+		lpphy->rssi_vc = bus->sprom.rssismc2g;
+		lpphy->rssi_gs = bus->sprom.rssisav2g;
+		lpphy->txpa[0] = bus->sprom.pa0b0;
+		lpphy->txpa[1] = bus->sprom.pa0b1;
+		lpphy->txpa[2] = bus->sprom.pa0b2;
+		maxpwr = bus->sprom.maxpwr_bg;
+		lpphy->max_tx_pwr_med_band = maxpwr;
+		cckpo = bus->sprom.cck2gpo;
+		ofdmpo = bus->sprom.ofdm2gpo;
+		if (cckpo) {
+			for (i = 0; i < 4; i++) {
+				lpphy->tx_max_rate[i] =
+					maxpwr - (ofdmpo & 0xF) * 2;
+				ofdmpo << 4;
+			}
+			ofdmpo = bus->sprom.ofdm2gpo;
+			for (i = 4; i < 15; i++) {
+				lpphy->tx_max_rate[i] =
+					maxpwr - (ofdmpo & 0xF) * 2;
+				ofdmpo << 4;
+			}
+		} else {
+			ofdmpo &= 0xFF;
+			for (i = 0; i < 4; i++)
+				lpphy->tx_max_rate[i] = maxpwr;
+			for (i = 4; i < 15; i++)
+				lpphy->tx_max_rate[i] = maxpwr - ofdmpo;
+		}
+	} else { /* 5GHz */
+		lpphy->tx_isolation_low_band = bus->sprom.tri5gl;
+		lpphy->tx_isolation_med_band = bus->sprom.tri5g;
+		lpphy->tx_isolation_hi_band = bus->sprom.tri5gh;
+		lpphy->bx_arch = bus->sprom.bxa5g;
+		lpphy->rssi_vf = bus->sprom.rssismf5g;
+		lpphy->rssi_vc = bus->sprom.rssismc5g;
+		lpphy->rssi_gs = bus->sprom.rssisav5g;
+		lpphy->txpa[0] = bus->sprom.pa1b0;
+		lpphy->txpa[1] = bus->sprom.pa1b1;
+		lpphy->txpa[2] = bus->sprom.pa1b2;
+		lpphy->txpal[0] = bus->sprom.pa1lob0;
+		lpphy->txpal[1] = bus->sprom.pa1lob1;
+		lpphy->txpal[2] = bus->sprom.pa1lob2;
+		lpphy->txpah[0] = bus->sprom.pa1hib0;
+		lpphy->txpah[1] = bus->sprom.pa1hib1;
+		lpphy->txpah[2] = bus->sprom.pa1hib2;
+		maxpwr = bus->sprom.maxpwr_al;
+		ofdmpo = bus->sprom.ofdm5glpo;
+		lpphy->max_tx_pwr_low_band = maxpwr;
+		for (i = 4; i < 12; i++) {
+			lpphy->tx_max_ratel[i] = maxpwr - (ofdmpo & 0xF) * 2;
+			ofdmpo << 4;
+		}
+		maxpwr = bus->sprom.maxpwr_a;
+		ofdmpo = bus->sprom.ofdm5gpo;
+		lpphy->max_tx_pwr_med_band = maxpwr;
+		for (i = 4; i < 12; i++) {
+			lpphy->tx_max_rate[i] = maxpwr - (ofdmpo & 0xF) * 2;
+			ofdmpo << 4;
+		}
+		maxpwr = bus->sprom.maxpwr_ah;
+		ofdmpo = bus->sprom.ofdm5ghpo;
+		lpphy->max_tx_pwr_hi_band = maxpwr;
+		for (i = 4; i < 12; i++) {
+			lpphy->tx_max_rateh[i] = maxpwr - (ofdmpo & 0xF) * 2;
+			ofdmpo << 4;
+		}
+	}
+}
+
 static void lpphy_adjust_gain_table(struct b43_wldev *dev)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
@@ -694,7 +775,7 @@ static void lpphy_tx_pctl_init(struct b43_wldev *dev)
 
 static int b43_lpphy_op_init(struct b43_wldev *dev)
 {
-	/* TODO: band SPROM */
+	lpphy_read_band_sprom(dev); //FIXME should this be in prepare_structs?
 	lpphy_baseband_init(dev);
 	lpphy_radio_init(dev);
 	//TODO calibrate RC
diff --git a/drivers/net/wireless/b43/phy_lp.h b/drivers/net/wireless/b43/phy_lp.h
index 13d89ea..9d0443c 100644
--- a/drivers/net/wireless/b43/phy_lp.h
+++ b/drivers/net/wireless/b43/phy_lp.h
@@ -831,6 +831,22 @@ struct b43_phy_lp {
 	/* Transmit isolation high band */
 	u8 tx_isolation_hi_band; /* FIXME initial value? */
 
+	/* Max transmit power medium band */
+	u16 max_tx_pwr_med_band;
+	/* Max transmit power low band */
+	u16 max_tx_pwr_low_band;
+	/* Max transmit power high band */
+	u16 max_tx_pwr_hi_band;
+
+	/* FIXME What are these used for? */
+	/* FIXME Is 15 the correct array size? */
+	u16 tx_sprom_max_rate[15];
+	u16 tx_sprom_max_ratel[15];
+	u16 tx_sprom_max_rateh[15];
+
+	/* Transmit power arrays */
+	s16 txpa[3], txpal[3], txpah[3];
+
 	/* Receive power offset */
 	u8 rx_pwr_offset; /* FIXME initial value? */
 
-- 
1.6.2.4


