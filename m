Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:57978 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966728Ab0B0MEa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Feb 2010 07:04:30 -0500
Received: by mail-fx0-f219.google.com with SMTP id 19so915402fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Feb 2010 04:04:30 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: bcm43xx-dev@lists.berlios.de,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V2 10/10] b43: N-PHY: switch to chanspec ops
Date: Sat, 27 Feb 2010 13:03:41 +0100
Message-Id: <1267272221-1873-11-git-send-email-zajec5@gmail.com>
In-Reply-To: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
References: <1267272221-1873-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
V2: fix typo
---
 drivers/net/wireless/b43/phy_n.c |   87 +++++++++++++++++++++++++++-----------
 drivers/net/wireless/b43/phy_n.h |    1 +
 2 files changed, 63 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 862223f..6fd140a 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -72,6 +72,7 @@ static void b43_nphy_rf_control_override(struct b43_wldev *dev, u16 field,
 						u16 value, u8 core, bool off);
 static void b43_nphy_rf_control_intc_override(struct b43_wldev *dev, u8 field,
 						u16 value, u8 core);
+static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel);
 
 static inline bool b43_empty_chanspec(struct b43_chanspec *chanspec)
 {
@@ -171,31 +172,6 @@ static void b43_radio_2055_setup(struct b43_wldev *dev,
 	udelay(300);
 }
 
-/* Tune the hardware to a new channel. */
-static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
-{
-	const struct b43_nphy_channeltab_entry *tabent;
-
-	tabent = b43_nphy_get_chantabent(dev, channel);
-	if (!tabent)
-		return -ESRCH;
-
-	//FIXME enable/disable band select upper20 in RXCTL
-	if (0 /*FIXME 5Ghz*/)
-		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x20);
-	else
-		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, 0x50);
-	b43_radio_2055_setup(dev, tabent);
-	if (0 /*FIXME 5Ghz*/)
-		b43_phy_set(dev, B43_NPHY_BANDCTL, B43_NPHY_BANDCTL_5GHZ);
-	else
-		b43_phy_mask(dev, B43_NPHY_BANDCTL, ~B43_NPHY_BANDCTL_5GHZ);
-	b43_chantab_phy_upload(dev, tabent);
-	b43_nphy_tx_power_fix(dev);
-
-	return 0;
-}
-
 static void b43_radio_init2055_pre(struct b43_wldev *dev)
 {
 	b43_phy_mask(dev, B43_NPHY_RFCTL_CMD,
@@ -3344,6 +3320,67 @@ static void b43_nphy_chanspec_setup(struct b43_wldev *dev,
 		b43_nphy_spur_workaround(dev);
 }
 
+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/SetChanspec */
+static int b43_nphy_set_chanspec(struct b43_wldev *dev,
+					struct b43_chanspec chanspec)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	const struct b43_nphy_channeltab_entry *tabent;
+
+	u8 tmp;
+	u8 channel = chanspec.channel;
+
+	if (dev->phy.rev >= 3) {
+		/* TODO */
+	}
+
+	nphy->radio_chanspec = chanspec;
+
+	if (chanspec.b_width != nphy->b_width)
+		; /* TODO: BMAC BW Set (chanspec.b_width) */
+
+	/* TODO: use defines */
+	if (chanspec.b_width == 3) {
+		if (chanspec.sideband == 2)
+			b43_phy_set(dev, B43_NPHY_RXCTL,
+					B43_NPHY_RXCTL_BSELU20);
+		else
+			b43_phy_mask(dev, B43_NPHY_RXCTL,
+					~B43_NPHY_RXCTL_BSELU20);
+	}
+
+	if (dev->phy.rev >= 3) {
+		tmp = (chanspec.b_freq == 1) ? 4 : 0;
+		b43_radio_maskset(dev, 0x08, 0xFFFB, tmp);
+		/* TODO: PHY Radio2056 Setup (chan_info_ptr[i]) */
+		/* TODO: N PHY Chanspec Setup (chan_info_ptr[i]) */
+	} else {
+		tabent = b43_nphy_get_chantabent(dev, channel);
+		if (!tabent)
+			return -ESRCH;
+
+		tmp = (chanspec.b_freq == 1) ? 0x0020 : 0x0050;
+		b43_radio_maskset(dev, B2055_MASTER1, 0xFF8F, tmp);
+		b43_radio_2055_setup(dev, tabent);
+		b43_nphy_chanspec_setup(dev, tabent, chanspec);
+	}
+
+	return 0;
+}
+
+/* Tune the hardware to a new channel */
+static int nphy_channel_switch(struct b43_wldev *dev, unsigned int channel)
+{
+	struct b43_phy_n *nphy = dev->phy.n;
+
+	struct b43_chanspec chanspec;
+	chanspec = nphy->radio_chanspec;
+	chanspec.channel = channel;
+
+	return b43_nphy_set_chanspec(dev, chanspec);
+}
+
 static int b43_nphy_op_allocate(struct b43_wldev *dev)
 {
 	struct b43_phy_n *nphy;
diff --git a/drivers/net/wireless/b43/phy_n.h b/drivers/net/wireless/b43/phy_n.h
index e7acae2..8b6d570 100644
--- a/drivers/net/wireless/b43/phy_n.h
+++ b/drivers/net/wireless/b43/phy_n.h
@@ -984,6 +984,7 @@ struct b43_phy_n {
 	u16 papd_epsilon_offset[2];
 	s32 preamble_override;
 	u32 bb_mult_save;
+	u8 b_width;
 	struct b43_chanspec radio_chanspec;
 
 	bool gain_boost;
-- 
1.6.4.2

