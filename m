Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f222.google.com ([209.85.218.222]:42007 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886AbZHRUIa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 16:08:30 -0400
Received: by bwz22 with SMTP id 22so3257769bwz.18
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 13:08:30 -0700 (PDT)
Message-ID: <4A8B0A3F.6040106@gmail.com>
Date: Tue, 18 Aug 2009 22:08:31 +0200
From: =?UTF-8?B?R8OhYm9yIFN0ZWZhbmlr?= <netrolller.3d@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	Larry Finger <Larry.Finger@lwfinger.net>
CC: Mark Huijgen <mark@huijgen.tk>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] b43: LP-PHY: Two small spec updates
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The specs are beginning to support rev3 LP-PHYs - implement one of
the changes needed for rev3 support.
Also, in the new MIPS driver, the "Japan TX filter" was renamed to
"analog TX filter init" - however, calling it "init" is confusing,
so name it "set analog filter", with a comment for easier future
identification.

Signed-off-by: Gábor Stefanik <netrolller.3d@gmail.com>
---
 drivers/net/wireless/b43/phy_lp.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lp.c b/drivers/net/wireless/b43/phy_lp.c
index 6c69cdb..65f0010 100644
--- a/drivers/net/wireless/b43/phy_lp.c
+++ b/drivers/net/wireless/b43/phy_lp.c
@@ -609,9 +609,14 @@ static void lpphy_2063_init(struct b43_wldev *dev)
 	b43_radio_write(dev, B2063_PA_SP7, 0);
 	b43_radio_write(dev, B2063_TX_RF_SP6, 0x20);
 	b43_radio_write(dev, B2063_TX_RF_SP9, 0x40);
-	b43_radio_write(dev, B2063_PA_SP3, 0xa0);
-	b43_radio_write(dev, B2063_PA_SP4, 0xa0);
-	b43_radio_write(dev, B2063_PA_SP2, 0x18);
+	if (dev->phy.rev == 2) {
+		b43_radio_write(dev, B2063_PA_SP3, 0xa0);
+		b43_radio_write(dev, B2063_PA_SP4, 0xa0);
+		b43_radio_write(dev, B2063_PA_SP2, 0x18);
+	} else {
+		b43_radio_write(dev, B2063_PA_SP3, 0x20);
+		b43_radio_write(dev, B2063_PA_SP2, 0x20);
+	}
 }
 
 struct lpphy_stx_table_entry {
@@ -1996,7 +2001,9 @@ static int lpphy_b2062_tune(struct b43_wldev *dev,
 	return err;
 }
 
-static void lpphy_japan_filter(struct b43_wldev *dev, int channel)
+
+/* This was previously called lpphy_japan_filter */
+static void lpphy_set_analog_filter(struct b43_wldev *dev, int channel)
 {
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 	u16 tmp = (channel == 14); //SPEC FIXME check japanwidefilter!
@@ -2165,7 +2172,7 @@ static int b43_lpphy_op_switch_channel(struct b43_wldev *dev,
 		err = lpphy_b2062_tune(dev, new_channel);
 		if (err)
 			return err;
-		lpphy_japan_filter(dev, new_channel);
+		lpphy_set_analog_filter(dev, new_channel);
 		lpphy_adjust_gain_table(dev, channel2freq_lp(new_channel));
 	}
 
-- 
1.6.2.4



