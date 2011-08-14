Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1HNUsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 16:48:31 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3255053fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 13:48:30 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] b43: LCN-PHY: implement disabling radio
Date: Sun, 14 Aug 2011 23:27:29 +0200
Message-Id: <1313357250-8292-2-git-send-email-zajec5@gmail.com> (sfid-20110814_224835_872124_7ECFFD7B)
In-Reply-To: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
References: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wl reads radio version, then disables it. That's how we found it in MMIO
dump:
 radio_read(0x0000) -> 0x0031 <-- RADIO READ WITHOUT 0x200 SET!
 radio_read(0x0001) -> 0x0064 <-- RADIO READ WITHOUT 0x200 SET!
 radio_read(0x0002) -> 0x0020 <-- RADIO READ WITHOUT 0x200 SET!
 read32 0xfaafc120 -> 0x04000400
 phy_read(0x044d) -> 0x0000
phy_write(0x044d) <- 0x0000
 phy_read(0x044c) -> 0x1fff
phy_write(0x044c) <- 0x1fff
 phy_read(0x04b7) -> 0x0000
phy_write(0x04b7) <- 0x0000
 phy_read(0x04b1) -> 0x0000
phy_write(0x04b1) <- 0x0000
 phy_read(0x04b0) -> 0x7dff
phy_write(0x04b0) <- 0x7dff
 phy_read(0x04fa) -> 0x0000
phy_write(0x04fa) <- 0x0000
 phy_read(0x04f9) -> 0x007f
phy_write(0x04f9) <- 0x007f

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
OFC, MMIO hacks were used to find masks & sets.

Sets were taken from:
>>> Switch Radio(OFF) start
 phy_read(0x044d) -> 0x0000
phy_write(0x044d) <- 0x0000
 phy_read(0x044c) -> 0x0000
phy_write(0x044c) <- 0x1f00
 phy_read(0x04b7) -> 0x0000
phy_write(0x04b7) <- 0x0000
 phy_read(0x04b1) -> 0x0000
phy_write(0x04b1) <- 0x0000
 phy_read(0x04b0) -> 0x0000
phy_write(0x04b0) <- 0x0808
 phy_read(0x04fa) -> 0x0000
phy_write(0x04fa) <- 0x0000
 phy_read(0x04f9) -> 0x0000
phy_write(0x04f9) <- 0x0008
>>> Switch Radio(OFF) end

Masks were taken from:
 phy_read(0x044d) -> 0xffff
phy_write(0x044d) <- 0x83ff
 phy_read(0x044c) -> 0xffff
phy_write(0x044c) <- 0xffff
 phy_read(0x04b7) -> 0xffff
phy_write(0x04b7) <- 0x80ff
 phy_read(0x04b1) -> 0xffff
phy_write(0x04b1) <- 0xdfff
 phy_read(0x04b0) -> 0xffff
phy_write(0x04b0) <- 0xffff
 phy_read(0x04fa) -> 0xffff
phy_write(0x04fa) <- 0xfff7
 phy_read(0x04f9) -> 0xffff
phy_write(0x04f9) <- 0xffff
---
 drivers/net/wireless/b43/phy_lcn.c |   23 +++++++++++++++++++++++
 drivers/net/wireless/b43/phy_lcn.h |    9 +++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 03944ad..69a93b5 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -60,6 +60,27 @@ static void b43_phy_lcn_op_prepare_structs(struct b43_wldev *dev)
 	memset(phy_lcn, 0, sizeof(*phy_lcn));
 }
 
+static void b43_phy_lcn_op_software_rfkill(struct b43_wldev *dev,
+					bool blocked)
+{
+	if (b43_read32(dev, B43_MMIO_MACCTL) & B43_MACCTL_ENABLED)
+		b43err(dev->wl, "MAC not suspended\n");
+
+	if (blocked) {
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL2, ~0x7c00);
+		b43_phy_set(dev, B43_PHY_LCN_RF_CTL1, 0x1f00);
+
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL5, ~0x7f00);
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL4, ~0x2);
+		b43_phy_set(dev, B43_PHY_LCN_RF_CTL3, 0x808);
+
+		b43_phy_mask(dev, B43_PHY_LCN_RF_CTL7, ~0x8);
+		b43_phy_set(dev, B43_PHY_LCN_RF_CTL6, 0x8);
+	} else {
+		/* TODO */
+	}
+}
+
 static unsigned int b43_phy_lcn_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -92,7 +113,9 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.phy_maskset		= b43_phy_lcn_op_maskset,
 	.radio_read		= b43_phy_lcn_op_radio_read,
 	.radio_write		= b43_phy_lcn_op_radio_write,
+	*/
 	.software_rfkill	= b43_phy_lcn_op_software_rfkill,
+	/*
 	.switch_analog		= b43_phy_lcn_op_switch_analog,
 	.switch_channel		= b43_phy_lcn_op_switch_channel,
 	*/
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
index 9e1b291..89f13b2 100644
--- a/drivers/net/wireless/b43/phy_lcn.h
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -4,6 +4,15 @@
 #include "phy_common.h"
 
 
+#define B43_PHY_LCN_RF_CTL1			B43_PHY_OFDM(0x04C)
+#define B43_PHY_LCN_RF_CTL2			B43_PHY_OFDM(0x04D)
+#define B43_PHY_LCN_RF_CTL3			B43_PHY_OFDM(0x0B0)
+#define B43_PHY_LCN_RF_CTL4			B43_PHY_OFDM(0x0B1)
+#define B43_PHY_LCN_RF_CTL5			B43_PHY_OFDM(0x0B7)
+#define B43_PHY_LCN_RF_CTL6			B43_PHY_OFDM(0x0F9)
+#define B43_PHY_LCN_RF_CTL7			B43_PHY_OFDM(0x0FA)
+
+
 struct b43_phy_lcn {
 };
 
-- 
1.7.3.4

