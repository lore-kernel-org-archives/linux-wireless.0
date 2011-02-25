Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35549 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab1BYL3C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 06:29:02 -0500
Received: by eyx24 with SMTP id 24so553002eyx.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 03:29:00 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: fill PHY ctl word1 in TX header for N-PHY
Date: Fri, 25 Feb 2011 12:34:11 +0100
Message-Id: <1298633651-5641-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes tramissing on OFDM rates for PHYs 1 and 2. There is
still something wrong with PHYs 3+. Tests has shown decreasing of
performance on CCK rates by 1-2%, we have to live with that.
Additionaly this noticeably reduces amount of PHY errors. They were
mostly produced by auto-switching to higher rate for better
performanced, which resulted in no transmit at all and PHY errors.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/xmit.c |   73 +++++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/b43/xmit.h |    6 +++
 2 files changed, 79 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/xmit.c b/drivers/net/wireless/b43/xmit.c
index e6b0528..9866686 100644
--- a/drivers/net/wireless/b43/xmit.c
+++ b/drivers/net/wireless/b43/xmit.c
@@ -32,6 +32,36 @@
 #include "dma.h"
 #include "pio.h"
 
+static const struct b43_tx_legacy_rate_phy_ctl_entry b43_tx_legacy_rate_phy_ctl[] = {
+	{ B43_CCK_RATE_1MB,	0x0,			0x0 },
+	{ B43_CCK_RATE_2MB,	0x0,			0x1 },
+	{ B43_CCK_RATE_5MB,	0x0,			0x2 },
+	{ B43_CCK_RATE_11MB,	0x0,			0x3 },
+	{ B43_OFDM_RATE_6MB,	B43_TXH_PHY1_CRATE_1_2,	B43_TXH_PHY1_MODUL_BPSK },
+	{ B43_OFDM_RATE_9MB,	B43_TXH_PHY1_CRATE_3_4,	B43_TXH_PHY1_MODUL_BPSK },
+	{ B43_OFDM_RATE_12MB,	B43_TXH_PHY1_CRATE_1_2,	B43_TXH_PHY1_MODUL_QPSK },
+	{ B43_OFDM_RATE_18MB,	B43_TXH_PHY1_CRATE_3_4,	B43_TXH_PHY1_MODUL_QPSK },
+	{ B43_OFDM_RATE_24MB,	B43_TXH_PHY1_CRATE_1_2,	B43_TXH_PHY1_MODUL_QAM16 },
+	{ B43_OFDM_RATE_36MB,	B43_TXH_PHY1_CRATE_3_4,	B43_TXH_PHY1_MODUL_QAM16 },
+	{ B43_OFDM_RATE_48MB,	B43_TXH_PHY1_CRATE_2_3,	B43_TXH_PHY1_MODUL_QAM64 },
+	{ B43_OFDM_RATE_54MB,	B43_TXH_PHY1_CRATE_3_4,	B43_TXH_PHY1_MODUL_QAM64 },
+};
+
+static const struct b43_tx_legacy_rate_phy_ctl_entry *
+b43_tx_legacy_rate_phy_ctl_ent(u8 bitrate)
+{
+	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(b43_tx_legacy_rate_phy_ctl); i++) {
+		e = &(b43_tx_legacy_rate_phy_ctl[i]);
+		if (e->bitrate == bitrate)
+			return e;
+	}
+
+	B43_WARN_ON(1);
+	return NULL;
+}
 
 /* Extract the bitrate index out of a CCK PLCP header. */
 static int b43_plcp_get_bitrate_idx_cck(struct b43_plcp_hdr6 *plcp)
@@ -145,6 +175,34 @@ void b43_generate_plcp_hdr(struct b43_plcp_hdr4 *plcp,
 	}
 }
 
+static u16 b43_generate_tx_phy_ctl1(struct b43_wldev *dev, u8 bitrate)
+{
+	const struct b43_phy *phy = &dev->phy;
+	const struct b43_tx_legacy_rate_phy_ctl_entry *e;
+	u16 control = 0;
+	u16 bw;
+
+	if (phy->type == B43_PHYTYPE_LP)
+		bw = B43_TXH_PHY1_BW_20;
+	else /* FIXME */
+		bw = B43_TXH_PHY1_BW_20;
+
+	if (0) { /* FIXME: MIMO */
+	} else if (b43_is_cck_rate(bitrate) && phy->type != B43_PHYTYPE_LP) {
+		control = bw;
+	} else {
+		control = bw;
+		e = b43_tx_legacy_rate_phy_ctl_ent(bitrate);
+		if (e) {
+			control |= e->coding_rate;
+			control |= e->modulation;
+		}
+		control |= B43_TXH_PHY1_MODE_SISO;
+	}
+
+	return control;
+}
+
 static u8 b43_calc_fallback_rate(u8 bitrate)
 {
 	switch (bitrate) {
@@ -437,6 +495,14 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 			extra_ft |= B43_TXH_EFT_RTSFB_OFDM;
 		else
 			extra_ft |= B43_TXH_EFT_RTSFB_CCK;
+
+		if (rates[0].flags & IEEE80211_TX_RC_USE_RTS_CTS &&
+		    phy->type == B43_PHYTYPE_N) {
+			txhdr->phy_ctl1_rts = cpu_to_le16(
+				b43_generate_tx_phy_ctl1(dev, rts_rate));
+			txhdr->phy_ctl1_rts_fb = cpu_to_le16(
+				b43_generate_tx_phy_ctl1(dev, rts_rate_fb));
+		}
 	}
 
 	/* Magic cookie */
@@ -445,6 +511,13 @@ int b43_generate_txhdr(struct b43_wldev *dev,
 	else
 		txhdr->new_format.cookie = cpu_to_le16(cookie);
 
+	if (phy->type == B43_PHYTYPE_N) {
+		txhdr->phy_ctl1 =
+			cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate));
+		txhdr->phy_ctl1_fb =
+			cpu_to_le16(b43_generate_tx_phy_ctl1(dev, rate_fb));
+	}
+
 	/* Apply the bitfields */
 	txhdr->mac_ctl = cpu_to_le32(mac_ctl);
 	txhdr->phy_ctl = cpu_to_le16(phy_ctl);
diff --git a/drivers/net/wireless/b43/xmit.h b/drivers/net/wireless/b43/xmit.h
index d4cf9b3..42debb5 100644
--- a/drivers/net/wireless/b43/xmit.h
+++ b/drivers/net/wireless/b43/xmit.h
@@ -73,6 +73,12 @@ struct b43_txhdr {
 	} __packed;
 } __packed;
 
+struct b43_tx_legacy_rate_phy_ctl_entry {
+	u8 bitrate;
+	u16 coding_rate;
+	u16 modulation;
+};
+
 /* MAC TX control */
 #define B43_TXH_MAC_USEFBR		0x10000000 /* Use fallback rate for this AMPDU */
 #define B43_TXH_MAC_KEYIDX		0x0FF00000 /* Security key index */
-- 
1.7.3.4

