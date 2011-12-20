Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35859 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab1LTVEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 16:04:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so6950267eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 13:04:49 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: N-PHY: get idle TSSI values
Date: Tue, 20 Dec 2011 22:45:49 +0100
Message-Id: <1324417549-5545-3-git-send-email-zajec5@gmail.com> (sfid-20111220_220453_740960_EA79D2CF)
In-Reply-To: <1324417549-5545-1-git-send-email-zajec5@gmail.com>
References: <1324417549-5545-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c |  125 +++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_n.h |    6 ++
 2 files changed, 130 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index da6fa03..d3222b8 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2297,6 +2297,129 @@ static void b43_nphy_tx_power_fix(struct b43_wldev *dev)
 		b43_nphy_stay_in_carrier_search(dev, 0);
 }
 
+static void b43_nphy_ipa_internal_tssi_setup(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+
+	u8 core;
+	u16 r; /* routing */
+
+	if (phy->rev >= 7) {
+		for (core = 0; core < 2; core++) {
+			r = core ? 0x190 : 0x170;
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+				b43_radio_write(dev, r + 0x5, 0x5);
+				b43_radio_write(dev, r + 0x9, 0xE);
+				if (phy->rev != 5)
+					b43_radio_write(dev, r + 0xA, 0);
+				if (phy->rev != 7)
+					b43_radio_write(dev, r + 0xB, 1);
+				else
+					b43_radio_write(dev, r + 0xB, 0x31);
+			} else {
+				b43_radio_write(dev, r + 0x5, 0x9);
+				b43_radio_write(dev, r + 0x9, 0xC);
+				b43_radio_write(dev, r + 0xB, 0x0);
+				if (phy->rev != 5)
+					b43_radio_write(dev, r + 0xA, 1);
+				else
+					b43_radio_write(dev, r + 0xA, 0x31);
+			}
+			b43_radio_write(dev, r + 0x6, 0);
+			b43_radio_write(dev, r + 0x7, 0);
+			b43_radio_write(dev, r + 0x8, 3);
+			b43_radio_write(dev, r + 0xC, 0);
+		}
+	} else {
+		if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+			b43_radio_write(dev, B2056_SYN_RESERVED_ADDR31, 0x128);
+		else
+			b43_radio_write(dev, B2056_SYN_RESERVED_ADDR31, 0x80);
+		b43_radio_write(dev, B2056_SYN_RESERVED_ADDR30, 0);
+		b43_radio_write(dev, B2056_SYN_GPIO_MASTER1, 0x29);
+
+		for (core = 0; core < 2; core++) {
+			r = core ? B2056_TX1 : B2056_TX0;
+
+			b43_radio_write(dev, r | B2056_TX_IQCAL_VCM_HG, 0);
+			b43_radio_write(dev, r | B2056_TX_IQCAL_IDAC, 0);
+			b43_radio_write(dev, r | B2056_TX_TSSI_VCM, 3);
+			b43_radio_write(dev, r | B2056_TX_TX_AMP_DET, 0);
+			b43_radio_write(dev, r | B2056_TX_TSSI_MISC1, 8);
+			b43_radio_write(dev, r | B2056_TX_TSSI_MISC2, 0);
+			b43_radio_write(dev, r | B2056_TX_TSSI_MISC3, 0);
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+				b43_radio_write(dev, r | B2056_TX_TX_SSI_MASTER,
+						0x5);
+				if (phy->rev != 5)
+					b43_radio_write(dev, r | B2056_TX_TSSIA,
+							0x00);
+				if (phy->rev >= 5)
+					b43_radio_write(dev, r | B2056_TX_TSSIG,
+							0x31);
+				else
+					b43_radio_write(dev, r | B2056_TX_TSSIG,
+							0x11);
+				b43_radio_write(dev, r | B2056_TX_TX_SSI_MUX,
+						0xE);
+			} else {
+				b43_radio_write(dev, r | B2056_TX_TX_SSI_MASTER,
+						0x9);
+				b43_radio_write(dev, r | B2056_TX_TSSIA, 0x31);
+				b43_radio_write(dev, r | B2056_TX_TSSIG, 0x0);
+				b43_radio_write(dev, r | B2056_TX_TX_SSI_MUX,
+						0xC);
+			}
+		}
+	}
+}
+
+/*
+ * Stop radio and transmit known signal. Then check received signal strength to
+ * get TSSI (Transmit Signal Strength Indicator).
+ * http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxPwrCtrlIdleTssi
+ */
+static void b43_nphy_tx_power_ctl_idle_tssi(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u32 tmp;
+	s32 rssi[4] = { };
+
+	/* TODO: check if we can transmit */
+
+	if (b43_nphy_ipa(dev))
+		b43_nphy_ipa_internal_tssi_setup(dev);
+
+	if (phy->rev >= 7)
+		; /* TODO: Override Rev7 with 0x2000, 0, 3, 0, 0 as arguments */
+	else if (phy->rev >= 3)
+		b43_nphy_rf_control_override(dev, 0x2000, 0, 3, false);
+
+	b43_nphy_stop_playback(dev);
+	b43_nphy_tx_tone(dev, 0xFA0, 0, false, false);
+	udelay(20);
+	tmp = b43_nphy_poll_rssi(dev, 4, rssi, 1);
+	b43_nphy_stop_playback(dev);
+	b43_nphy_rssi_select(dev, 0, 0);
+
+	if (phy->rev >= 7)
+		; /* TODO: Override Rev7 with 0x2000, 0, 3, 1, 0 as arguments */
+	else if (phy->rev >= 3)
+		b43_nphy_rf_control_override(dev, 0x2000, 0, 3, true);
+
+	if (phy->rev >= 3) {
+		nphy->pwr_ctl_info[0].idle_tssi_5g = (tmp >> 24) & 0xFF;
+		nphy->pwr_ctl_info[1].idle_tssi_5g = (tmp >> 8) & 0xFF;
+	} else {
+		nphy->pwr_ctl_info[0].idle_tssi_5g = (tmp >> 16) & 0xFF;
+		nphy->pwr_ctl_info[1].idle_tssi_5g = tmp & 0xFF;
+	}
+	nphy->pwr_ctl_info[0].idle_tssi_2g = (tmp >> 24) & 0xFF;
+	nphy->pwr_ctl_info[1].idle_tssi_2g = (tmp >> 8) & 0xFF;
+}
+
 static void b43_nphy_tx_gain_table_upload(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -3986,7 +4109,7 @@ int b43_phy_initn(struct b43_wldev *dev)
 	tx_pwr_state = nphy->txpwrctrl;
 	b43_nphy_tx_power_ctrl(dev, false);
 	b43_nphy_tx_power_fix(dev);
-	/* TODO N PHY TX Power Control Idle TSSI */
+	b43_nphy_tx_power_ctl_idle_tssi(dev);
 	/* TODO N PHY TX Power Control Setup */
 	b43_nphy_tx_gain_table_upload(dev);
 
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 56ef97b..5de8f74 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -765,6 +765,11 @@ struct b43_phy_n_txpwrindex {
 	u16 locomp;
 };
 
+struct b43_phy_n_pwr_ctl_info {
+	u8 idle_tssi_2g;
+	u8 idle_tssi_5g;
+};
+
 struct b43_phy_n {
 	u8 antsel_type;
 	u8 cal_orig_pwr_idx[2];
@@ -798,6 +803,7 @@ struct b43_phy_n {
 	u16 txiqlocal_bestc[11];
 	bool txiqlocal_coeffsvalid;
 	struct b43_phy_n_txpwrindex txpwrindex[2];
+	struct b43_phy_n_pwr_ctl_info pwr_ctl_info[2];
 	struct b43_chanspec txiqlocal_chanspec;
 
 	u8 txrx_chain;
-- 
1.7.3.4

