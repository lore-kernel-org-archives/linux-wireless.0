Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:37027 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab3C0QQJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Mar 2013 12:16:09 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: zajec5@gmail.com, linux-wireless@vger.kernel.org,
	b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 1/2] b43: mark some functions and structs static
Date: Wed, 27 Mar 2013 17:15:50 +0100
Message-Id: <1364400951-25488-1-git-send-email-hauke@hauke-m.de> (sfid-20130327_171747_663651_D1231364)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes some sparse warnings.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/b43/phy_n.c          |    6 ++++--
 drivers/net/wireless/b43/radio_2056.c     |    2 +-
 drivers/net/wireless/b43/sdio.h           |    4 ++--
 drivers/net/wireless/b43/tables_nphy.c    |    4 ++--
 drivers/net/wireless/b43/tables_phy_lcn.c |    6 +++---
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 1ec0d69..8d15878 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -2789,9 +2789,11 @@ static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
  * Tx and Rx
  **************************************************/
 
-void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
+#if 0
+static void b43_nphy_set_rxantenna(struct b43_wldev *dev, int antenna)
 {//TODO
 }
+#endif
 
 static void b43_nphy_op_adjust_txpower(struct b43_wldev *dev)
 {//TODO
@@ -4892,7 +4894,7 @@ static void b43_nphy_superswitch_init(struct b43_wldev *dev, bool init)
 }
 
 /* http://bcm-v4.sipsolutions.net/802.11/PHY/Init/N */
-int b43_phy_initn(struct b43_wldev *dev)
+static int b43_phy_initn(struct b43_wldev *dev)
 {
 	struct ssb_sprom *sprom = dev->dev->bus_sprom;
 	struct b43_phy *phy = &dev->phy;
diff --git a/drivers/net/wireless/b43/radio_2056.c b/drivers/net/wireless/b43/radio_2056.c
index ce037fb..ab1f55f 100644
--- a/drivers/net/wireless/b43/radio_2056.c
+++ b/drivers/net/wireless/b43/radio_2056.c
@@ -2980,7 +2980,7 @@ static const struct b2056_inittab_entry b2056_inittab_rev8_rx[] = {
 	.rx		= prefix##_rx,			\
 	.rx_length	= ARRAY_SIZE(prefix##_rx)
 
-struct b2056_inittabs_pts b2056_inittabs[] = {
+static struct b2056_inittabs_pts b2056_inittabs[] = {
 	[3] = { INITTABSPTS(b2056_inittab_rev3) },
 	[4] = { INITTABSPTS(b2056_inittab_rev4) },
 	[5] = { INITTABSPTS(b2056_inittab_rev5) },
diff --git a/drivers/net/wireless/b43/sdio.h b/drivers/net/wireless/b43/sdio.h
index fb63309..1e93926 100644
--- a/drivers/net/wireless/b43/sdio.h
+++ b/drivers/net/wireless/b43/sdio.h
@@ -25,12 +25,12 @@ void b43_sdio_exit(void);
 #else /* CONFIG_B43_SDIO */
 
 
-int b43_sdio_request_irq(struct b43_wldev *dev,
+static inline int b43_sdio_request_irq(struct b43_wldev *dev,
 			 void (*handler)(struct b43_wldev *dev))
 {
 	return -ENODEV;
 }
-void b43_sdio_free_irq(struct b43_wldev *dev)
+static inline void b43_sdio_free_irq(struct b43_wldev *dev)
 {
 }
 static inline int b43_sdio_init(void)
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index aaca60c..110510d 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2800,7 +2800,7 @@ static const struct nphy_rf_control_override_rev7
 	{ 0x0010, 0x344, 0x345, 0x0010, 4 },
 };
 
-struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_wa_phy6_radio11_ghz2 = {
+static struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_wa_phy6_radio11_ghz2 = {
 	{ 10, 14, 19, 27 },
 	{ -5, 6, 10, 15 },
 	{ 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA, 0xA },
@@ -2811,7 +2811,7 @@ struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_wa_phy6_radio11_ghz2 = {
 	0x18, 0x18, 0x18,
 	0x01D0, 0x5,
 };
-struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][4] = {
+static struct nphy_gain_ctl_workaround_entry nphy_gain_ctl_workaround[2][4] = {
 	{ /* 2GHz */
 		{ /* PHY rev 3 */
 			{ 7, 11, 16, 23 },
diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
index 5176363..e347b8d 100644
--- a/drivers/net/wireless/b43/tables_phy_lcn.c
+++ b/drivers/net/wireless/b43/tables_phy_lcn.c
@@ -313,7 +313,7 @@ static const u32 b43_lcntab_0x18[] = {
  * TX gain.
  **************************************************/
 
-const struct b43_lcntab_tx_gain_tbl_entry
+static const struct b43_lcntab_tx_gain_tbl_entry
 	b43_lcntab_tx_gain_tbl_2ghz_ext_pa_rev0[B43_LCNTAB_TX_GAIN_SIZE] = {
 	{ 0x03, 0x00, 0x1f, 0x0, 0x48 },
 	{ 0x03, 0x00, 0x1f, 0x0, 0x46 },
@@ -449,7 +449,7 @@ const struct b43_lcntab_tx_gain_tbl_entry
  * SW control.
  **************************************************/
 
-const u16 b43_lcntab_sw_ctl_4313_epa_rev0[] = {
+static const u16 b43_lcntab_sw_ctl_4313_epa_rev0[] = {
 	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
 	0x0004, 0x0001, 0x0002, 0x0008, 0x0004, 0x0001,
 	0x0002, 0x0008, 0x0004, 0x0001, 0x0002, 0x0008,
@@ -631,7 +631,7 @@ static void b43_phy_lcn_upload_static_tables(struct b43_wldev *dev)
 	lcntab_upload(dev, B43_LCNTAB32(0x18, 0), b43_lcntab_0x18);
 }
 
-void b43_phy_lcn_load_tx_gain_tab(struct b43_wldev *dev,
+static void b43_phy_lcn_load_tx_gain_tab(struct b43_wldev *dev,
 			const struct b43_lcntab_tx_gain_tbl_entry *gain_table)
 {
 	u32 i;
-- 
1.7.10.4

