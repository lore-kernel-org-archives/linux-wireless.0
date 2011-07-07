Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:42721 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab1GGR21 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 13:28:27 -0400
Received: by fxd18 with SMTP id 18so1287916fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jul 2011 10:28:26 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: HT-PHY: define dummy TX power functions
Date: Thu,  7 Jul 2011 20:06:56 +0200
Message-Id: <1310062016-3900-1-git-send-email-zajec5@gmail.com> (sfid-20110707_192831_138754_02A811CB)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Without them we get Oops with NULL pointer

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 30b19c6..2982103 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -373,6 +373,16 @@ static void b43_phy_ht_op_radio_write(struct b43_wldev *dev, u16 reg,
 	b43_write16(dev, B43_MMIO_RADIO24_DATA, value);
 }
 
+static enum b43_txpwr_result
+b43_phy_ht_op_recalc_txpower(struct b43_wldev *dev, bool ignore_tssi)
+{
+	return B43_TXPWR_RES_DONE;
+}
+
+static void b43_phy_ht_op_adjust_txpower(struct b43_wldev *dev)
+{
+}
+
 /**************************************************
  * PHY ops struct.
  **************************************************/
@@ -391,8 +401,6 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.switch_analog		= b43_phy_ht_op_switch_analog,
 	.switch_channel		= b43_phy_ht_op_switch_channel,
 	.get_default_chan	= b43_phy_ht_op_get_default_chan,
-	/*
 	.recalc_txpower		= b43_phy_ht_op_recalc_txpower,
 	.adjust_txpower		= b43_phy_ht_op_adjust_txpower,
-	*/
 };
-- 
1.7.3.4

