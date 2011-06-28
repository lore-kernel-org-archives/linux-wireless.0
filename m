Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:48580 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570Ab1F1H1y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 03:27:54 -0400
Received: by fxd18 with SMTP id 18so2529285fxd.11
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jun 2011 00:27:53 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: HT-PHY: basic PHY init
Date: Tue, 28 Jun 2011 09:28:39 +0200
Message-Id: <1309246119-6878-2-git-send-email-zajec5@gmail.com> (sfid-20110628_093049_186553_3930E7CF)
In-Reply-To: <1309246119-6878-1-git-send-email-zajec5@gmail.com>
References: <1309246119-6878-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/phy_ht.c        |    9 +++++++--
 drivers/net/wireless/b43/tables_phy_ht.h |    2 ++
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_ht.c b/drivers/net/wireless/b43/phy_ht.c
index 28fb746..69412d1 100644
--- a/drivers/net/wireless/b43/phy_ht.c
+++ b/drivers/net/wireless/b43/phy_ht.c
@@ -205,6 +205,13 @@ static void b43_phy_ht_op_prepare_structs(struct b43_wldev *dev)
 	memset(phy_ht, 0, sizeof(*phy_ht));
 }
 
+static int b43_phy_ht_op_init(struct b43_wldev *dev)
+{
+	b43_phy_ht_tables_init(dev);
+
+	return 0;
+}
+
 static void b43_phy_ht_op_free(struct b43_wldev *dev)
 {
 	struct b43_phy *phy = &dev->phy;
@@ -326,9 +333,7 @@ const struct b43_phy_operations b43_phyops_ht = {
 	.allocate		= b43_phy_ht_op_allocate,
 	.free			= b43_phy_ht_op_free,
 	.prepare_structs	= b43_phy_ht_op_prepare_structs,
-	/*
 	.init			= b43_phy_ht_op_init,
-	*/
 	.phy_read		= b43_phy_ht_op_read,
 	.phy_write		= b43_phy_ht_op_write,
 	.phy_maskset		= b43_phy_ht_op_maskset,
diff --git a/drivers/net/wireless/b43/tables_phy_ht.h b/drivers/net/wireless/b43/tables_phy_ht.h
index 6a13614..ea3be38 100644
--- a/drivers/net/wireless/b43/tables_phy_ht.h
+++ b/drivers/net/wireless/b43/tables_phy_ht.h
@@ -17,4 +17,6 @@ void b43_httab_write(struct b43_wldev *dev, u32 offset, u32 value);
 void b43_httab_write_bulk(struct b43_wldev *dev, u32 offset,
 			  unsigned int nr_elements, const void *_data);
 
+void b43_phy_ht_tables_init(struct b43_wldev *dev);
+
 #endif /* B43_TABLES_PHY_HT_H_ */
-- 
1.7.1

