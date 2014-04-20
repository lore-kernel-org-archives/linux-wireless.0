Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f45.google.com ([74.125.83.45]:58581 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755201AbaDTLGJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2014 07:06:09 -0400
Received: by mail-ee0-f45.google.com with SMTP id d17so2943978eek.32
        for <linux-wireless@vger.kernel.org>; Sun, 20 Apr 2014 04:06:07 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/9] b43: N-PHY: rev3+: complete workarounds
Date: Sun, 20 Apr 2014 13:05:44 +0200
Message-Id: <1397991951-13478-3-git-send-email-zajec5@gmail.com> (sfid-20140420_130647_936452_9D13189D)
In-Reply-To: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
References: <1397991951-13478-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_n.c | 87 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 84 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 24ccbe9..e9658ee 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2494,8 +2494,8 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 
 	/* TX to RX */
-	u8 tx2rx_events[8] = { 0x4, 0x3, 0x6, 0x5, 0x2, 0x1, 0x8, 0x1F };
-	u8 tx2rx_delays[8] = { 8, 4, 2, 2, 4, 4, 6, 1 };
+	u8 tx2rx_events[7] = { 0x4, 0x3, 0x5, 0x2, 0x1, 0x8, 0x1F };
+	u8 tx2rx_delays[7] = { 8, 4, 4, 4, 4, 6, 1 };
 	/* RX to TX */
 	u8 rx2tx_events_ipa[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0xF, 0x3,
 					0x1F };
@@ -2503,6 +2503,23 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	u8 rx2tx_events[9] = { 0x0, 0x1, 0x2, 0x8, 0x5, 0x6, 0x3, 0x4, 0x1F };
 	u8 rx2tx_delays[9] = { 8, 6, 6, 4, 4, 18, 42, 1, 1 };
 
+	u16 vmids[5][4] = {
+		{ 0xa2, 0xb4, 0xb4, 0x89, }, /* 0 */
+		{ 0xb4, 0xb4, 0xb4, 0x24, }, /* 1 */
+		{ 0xa2, 0xb4, 0xb4, 0x74, }, /* 2 */
+		{ 0xa2, 0xb4, 0xb4, 0x270, }, /* 3 */
+		{ 0xa2, 0xb4, 0xb4, 0x00, }, /* 4 and 5 */
+	};
+	u16 gains[5][4] = {
+		{ 0x02, 0x02, 0x02, 0x00, }, /* 0 */
+		{ 0x02, 0x02, 0x02, 0x02, }, /* 1 */
+		{ 0x02, 0x02, 0x02, 0x04, }, /* 2 */
+		{ 0x02, 0x02, 0x02, 0x00, }, /* 3 */
+		{ 0x02, 0x02, 0x02, 0x00, }, /* 4 and 5 */
+	};
+	u16 *vmid, *gain;
+
+	u8 pdet_range;
 	u16 tmp16;
 	u32 tmp32;
 
@@ -2561,7 +2578,71 @@ static void b43_nphy_workarounds_rev3plus(struct b43_wldev *dev)
 	b43_ntab_write(dev, B43_NTAB16(8, 0), 2);
 	b43_ntab_write(dev, B43_NTAB16(8, 16), 2);
 
-	/* TODO */
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		pdet_range = sprom->fem.ghz2.pdet_range;
+	else
+		pdet_range = sprom->fem.ghz5.pdet_range;
+	vmid = vmids[min_t(u16, pdet_range, 4)];
+	gain = gains[min_t(u16, pdet_range, 4)];
+	switch (pdet_range) {
+	case 3:
+		if (!(dev->phy.rev >= 4 &&
+		      b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ))
+			break;
+		/* FALL THROUGH */
+	case 0:
+	case 1:
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x08), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x18), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x0c), 4, gain);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x1c), 4, gain);
+		break;
+	case 2:
+		if (dev->phy.rev >= 6) {
+			if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+				vmid[3] = 0x94;
+			else
+				vmid[3] = 0x8e;
+			gain[3] = 3;
+		} else if (dev->phy.rev == 5) {
+			vmid[3] = 0x84;
+			gain[3] = 2;
+		}
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x08), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x18), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x0c), 4, gain);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x1c), 4, gain);
+		break;
+	case 4:
+	case 5:
+		if (b43_current_band(dev->wl) != IEEE80211_BAND_2GHZ) {
+			if (pdet_range == 4) {
+				vmid[3] = 0x8e;
+				tmp16 = 0x96;
+				gain[3] = 0x2;
+			} else {
+				vmid[3] = 0x89;
+				tmp16 = 0x89;
+				gain[3] = 0;
+			}
+		} else {
+			if (pdet_range == 4) {
+				vmid[3] = 0x89;
+				tmp16 = 0x8b;
+				gain[3] = 0x2;
+			} else {
+				vmid[3] = 0x74;
+				tmp16 = 0x70;
+				gain[3] = 0;
+			}
+		}
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x08), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x0c), 4, gain);
+		vmid[3] = tmp16;
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x18), 4, vmid);
+		b43_ntab_write_bulk(dev, B43_NTAB16(8, 0x1c), 4, gain);
+		break;
+	}
 
 	b43_radio_write(dev, B2056_RX0 | B2056_RX_MIXA_MAST_BIAS, 0x00);
 	b43_radio_write(dev, B2056_RX1 | B2056_RX_MIXA_MAST_BIAS, 0x00);
-- 
1.8.4.5

