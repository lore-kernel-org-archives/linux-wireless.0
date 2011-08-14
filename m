Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1HNUsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 16:48:37 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3255053fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 13:48:36 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 3/3] b43: LCN-PHY: switch analog
Date: Sun, 14 Aug 2011 23:27:30 +0200
Message-Id: <1313357250-8292-3-git-send-email-zajec5@gmail.com> (sfid-20110814_224841_393127_CAB5FE57)
In-Reply-To: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
References: <1313357250-8292-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Analog is switched on right after reading PHY version:
 read16 0xfaafc3e0 -> 0xa801
 phy_read(0x043b) -> 0x0000
phy_write(0x043b) <- 0x0000
Switched off after after killing radio:
>>> Switch Radio(OFF) end
 phy_read(0x043c) -> 0x0000
phy_write(0x043c) <- 0x0007
 phy_read(0x043b) -> 0x0000
phy_write(0x043b) <- 0x0007

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
Again, MMIO hacks to find masks & sets.

Sets came from:
>>> analog(OFF) start
 phy_read(0x043c) -> 0x0000
phy_write(0x043c) <- 0x0007
 phy_read(0x043b) -> 0x0000
phy_write(0x043b) <- 0x0007
>>> analog(OFF) end

There is no masking for OFF:
>>> analog(OFF) start
 phy_read(0x043c) -> 0xffff
phy_write(0x043c) <- 0xffff
 phy_read(0x043b) -> 0xffff
phy_write(0x043b) <- 0xffff
>>> analog(OFF) end

Mask for ON came from
 phy_read(0x043b) -> 0xffff
phy_write(0x043b) <- 0xfff8
(there was not masking for ON).
---
 drivers/net/wireless/b43/phy_lcn.c |   12 +++++++++++-
 drivers/net/wireless/b43/phy_lcn.h |    2 ++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 69a93b5..0fd72c1 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -81,6 +81,16 @@ static void b43_phy_lcn_op_software_rfkill(struct b43_wldev *dev,
 	}
 }
 
+static void b43_phy_lcn_op_switch_analog(struct b43_wldev *dev, bool on)
+{
+	if (on) {
+		b43_phy_mask(dev, B43_PHY_LCN_AFE_CTL1, ~0x7);
+	} else {
+		b43_phy_set(dev, B43_PHY_LCN_AFE_CTL2, 0x7);
+		b43_phy_set(dev, B43_PHY_LCN_AFE_CTL1, 0x7);
+	}
+}
+
 static unsigned int b43_phy_lcn_op_get_default_chan(struct b43_wldev *dev)
 {
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
@@ -115,8 +125,8 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.radio_write		= b43_phy_lcn_op_radio_write,
 	*/
 	.software_rfkill	= b43_phy_lcn_op_software_rfkill,
-	/*
 	.switch_analog		= b43_phy_lcn_op_switch_analog,
+	/*
 	.switch_channel		= b43_phy_lcn_op_switch_channel,
 	*/
 	.get_default_chan	= b43_phy_lcn_op_get_default_chan,
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
index 89f13b2..371e07d 100644
--- a/drivers/net/wireless/b43/phy_lcn.h
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -4,6 +4,8 @@
 #include "phy_common.h"
 
 
+#define B43_PHY_LCN_AFE_CTL1			B43_PHY_OFDM(0x03B)
+#define B43_PHY_LCN_AFE_CTL2			B43_PHY_OFDM(0x03C)
 #define B43_PHY_LCN_RF_CTL1			B43_PHY_OFDM(0x04C)
 #define B43_PHY_LCN_RF_CTL2			B43_PHY_OFDM(0x04D)
 #define B43_PHY_LCN_RF_CTL3			B43_PHY_OFDM(0x0B0)
-- 
1.7.3.4

