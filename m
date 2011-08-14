Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34162 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1HNUsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 16:48:25 -0400
Received: by fxh19 with SMTP id 19so3255053fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 13:48:24 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] b43: LCN-PHY: add very basic PHY ops
Date: Sun, 14 Aug 2011 23:27:28 +0200
Message-Id: <1313357250-8292-1-git-send-email-zajec5@gmail.com> (sfid-20110814_224830_370100_29AFD277)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_lcn.c |   54 ++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/phy_lcn.h |    2 +-
 2 files changed, 53 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_lcn.c b/drivers/net/wireless/b43/phy_lcn.c
index 9f7dbbd..03944ad 100644
--- a/drivers/net/wireless/b43/phy_lcn.c
+++ b/drivers/net/wireless/b43/phy_lcn.c
@@ -28,14 +28,64 @@
 #include "main.h"
 
 /**************************************************
+ * Basic PHY ops.
+ **************************************************/
+
+static int b43_phy_lcn_op_allocate(struct b43_wldev *dev)
+{
+	struct b43_phy_lcn *phy_lcn;
+
+	phy_lcn = kzalloc(sizeof(*phy_lcn), GFP_KERNEL);
+	if (!phy_lcn)
+		return -ENOMEM;
+	dev->phy.lcn = phy_lcn;
+
+	return 0;
+}
+
+static void b43_phy_lcn_op_free(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_lcn *phy_lcn = phy->lcn;
+
+	kfree(phy_lcn);
+	phy->lcn = NULL;
+}
+
+static void b43_phy_lcn_op_prepare_structs(struct b43_wldev *dev)
+{
+	struct b43_phy *phy = &dev->phy;
+	struct b43_phy_lcn *phy_lcn = phy->lcn;
+
+	memset(phy_lcn, 0, sizeof(*phy_lcn));
+}
+
+static unsigned int b43_phy_lcn_op_get_default_chan(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ)
+		return 1;
+	return 36;
+}
+
+static enum b43_txpwr_result
+b43_phy_lcn_op_recalc_txpower(struct b43_wldev *dev, bool ignore_tssi)
+{
+	return B43_TXPWR_RES_DONE;
+}
+
+static void b43_phy_lcn_op_adjust_txpower(struct b43_wldev *dev)
+{
+}
+
+/**************************************************
  * PHY ops struct.
  **************************************************/
 
 const struct b43_phy_operations b43_phyops_lcn = {
-	/*
 	.allocate		= b43_phy_lcn_op_allocate,
 	.free			= b43_phy_lcn_op_free,
 	.prepare_structs	= b43_phy_lcn_op_prepare_structs,
+	/*
 	.init			= b43_phy_lcn_op_init,
 	.phy_read		= b43_phy_lcn_op_read,
 	.phy_write		= b43_phy_lcn_op_write,
@@ -45,8 +95,8 @@ const struct b43_phy_operations b43_phyops_lcn = {
 	.software_rfkill	= b43_phy_lcn_op_software_rfkill,
 	.switch_analog		= b43_phy_lcn_op_switch_analog,
 	.switch_channel		= b43_phy_lcn_op_switch_channel,
+	*/
 	.get_default_chan	= b43_phy_lcn_op_get_default_chan,
 	.recalc_txpower		= b43_phy_lcn_op_recalc_txpower,
 	.adjust_txpower		= b43_phy_lcn_op_adjust_txpower,
-	*/
 };
diff --git a/drivers/net/wireless/b43/phy_lcn.h b/drivers/net/wireless/b43/phy_lcn.h
index c046c2a..9e1b291 100644
--- a/drivers/net/wireless/b43/phy_lcn.h
+++ b/drivers/net/wireless/b43/phy_lcn.h
@@ -11,4 +11,4 @@ struct b43_phy_lcn {
 struct b43_phy_operations;
 extern const struct b43_phy_operations b43_phyops_lcn;
 
-#endif /* B43_PHY_LCN_H_ */
\ No newline at end of file
+#endif /* B43_PHY_LCN_H_ */
-- 
1.7.3.4

