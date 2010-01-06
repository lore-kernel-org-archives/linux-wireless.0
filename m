Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47957 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932783Ab0AFUzw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 15:55:52 -0500
Received: by ewy19 with SMTP id 19so10054623ewy.21
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 12:55:50 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 2/5] b43: N-PHY: add b43_nphy_get_tx_gains (V2)
References: <op.u54a59c89lhzdc@linux-g0th.site>
 <43e72e891001060926s320bf403ya2edf2601ced5125@mail.gmail.com>
 <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
Date: Wed, 06 Jan 2010 21:57:12 +0100
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u54ptmwm9lhzdc@linux-g0th.site>
In-Reply-To: <b170af451001061018x6ff2404ajbdbb3cb96ceaf7f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

V2: adjust to renamed function, fill index array

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c |   81 ++++++++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/phy_n.h |    1 +
  2 files changed, 82 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 5252c0f..3663386 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -30,6 +30,8 @@
  #include "tables_nphy.h"


+struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
+
  void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
  {//TODO
  }
@@ -406,6 +408,85 @@ static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
  	}
  }

+static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	u16 curr_gain[2];
+	struct nphy_txgains target;
+	u32 *table = NULL;
+
+	if (nphy->txpwrctrl == 0) {
+		int i;
+
+		if (nphy->hang_avoid)
+			b43_nphy_stay_in_carrier_search(dev, true);
+		//TODO: Read an N PHY Table with ID 7, length 2, offset 0x110, width 16, and curr_gain
+		if (nphy->hang_avoid)
+			b43_nphy_stay_in_carrier_search(dev, false);
+
+		for (i = 0; i < 2; ++i) {
+			if (dev->phy.rev >= 3) {
+				target.ipa[i] = curr_gain[i] & 0x000F;
+				target.pad[i] = (curr_gain[i] & 0x00F0) >> 4;
+				target.pga[i] = (curr_gain[i] & 0x0F00) >> 8;
+				target.txgm[i] = (curr_gain[i] & 0x7000) >> 12;
+			} else {
+				target.ipa[i] = curr_gain[i] & 0x0003;
+				target.pad[i] = (curr_gain[i] & 0x000C) >> 2;
+				target.pga[i] = (curr_gain[i] & 0x0070) >> 4;
+				target.txgm[i] = (curr_gain[i] & 0x0380) >> 7;
+			}
+		}
+	} else {
+		int i;
+		u16 index[2];
+		index[0] = (b43_phy_read(dev, B43_NPHY_C1_TXPCTL_STAT) &
+			B43_NPHY_TXPCTL_STAT_BIDX) >>
+			B43_NPHY_TXPCTL_STAT_BIDX_SHIFT;
+		index[1] = (b43_phy_read(dev, B43_NPHY_C2_TXPCTL_STAT) &
+			B43_NPHY_TXPCTL_STAT_BIDX) >>
+			B43_NPHY_TXPCTL_STAT_BIDX_SHIFT;
+
+		for (i = 0; i < 2; ++i) {
+			if (dev->phy.rev >= 3) {
+				enum ieee80211_band band =
+					b43_current_band(dev->wl);
+
+				if ((nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
+				    (nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
+					table = NULL; //FIXME: = output of N PHY Get IPA GainTbl
+				} else {
+					if (band == IEEE80211_BAND_5GHZ) {
+						if (dev->phy.rev == 3)
+							table = NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev >= 3 (5 GHz)
+						else if (dev->phy.rev == 4)
+							table = NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev 4 (5 GHz)
+						else
+							table = NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev 5 (5 GHz)
+					} else {
+						table = NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev >= 3 (2.4 GHz)
+					}
+				}
+
+				target.ipa[i] = (table[index[i]] >> 16) & 0xF;
+				target.pad[i] = (table[index[i]] >> 20) & 0xF;
+				target.pga[i] = (table[index[i]] >> 24) & 0xF;
+				target.txgm[i] = (table[index[i]] >> 28) & 0xF;
+			} else {
+				table = NULL; //FIXME: N PHY TX Power Control - TX Gain Table Rev <= 2
+
+				target.ipa[i] = (table[index[i]] >> 16) & 0x3;
+				target.pad[i] = (table[index[i]] >> 18) & 0x3;
+				target.pga[i] = (table[index[i]] >> 20) & 0x7;
+				target.txgm[i] = (table[index[i]] >> 23) & 0x7;
+			}
+		}
+	}
+
+	return target;
+}
+
  enum b43_nphy_rf_sequence {
  	B43_RFSEQ_RX2TX,
  	B43_RFSEQ_TX2RX,
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index 6ab07fc..e63c371 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -930,6 +930,7 @@ struct b43_phy_n {
  	u8 phyrxchain;
  	u8 mphase_cal_phase_id;
  	u32 deaf_count;
+	bool hang_avoid;
  	bool mute;

  	u16 classifier_state;
-- 
1.6.4.2

