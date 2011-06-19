Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52412 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab1FSKwH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 06:52:07 -0400
Received: by ewy4 with SMTP id 4so943905ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 03:52:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: N-PHY: move declarations of chantables functions to correct files
Date: Sun, 19 Jun 2011 13:30:21 +0200
Message-Id: <1308483021-7149-2-git-send-email-zajec5@gmail.com> (sfid-20110619_125219_169907_38EEC010)
In-Reply-To: <1308483021-7149-1-git-send-email-zajec5@gmail.com>
References: <1308483021-7149-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/radio_2055.h  |    5 +++++
 drivers/net/wireless/b43/radio_2056.h  |    5 +++++
 drivers/net/wireless/b43/tables_nphy.h |    8 --------
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/b43/radio_2055.h b/drivers/net/wireless/b43/radio_2055.h
index d9bfa0f..67f9612 100644
--- a/drivers/net/wireless/b43/radio_2055.h
+++ b/drivers/net/wireless/b43/radio_2055.h
@@ -251,4 +251,9 @@ struct b43_nphy_channeltab_entry_rev2 {
 void b2055_upload_inittab(struct b43_wldev *dev,
 			  bool ghz5, bool ignore_uploadflag);
 
+/* Get the NPHY Channel Switch Table entry for a channel.
+ * Returns NULL on failure to find an entry. */
+const struct b43_nphy_channeltab_entry_rev2 *
+b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel);
+
 #endif /* B43_RADIO_2055_H_ */
diff --git a/drivers/net/wireless/b43/radio_2056.h b/drivers/net/wireless/b43/radio_2056.h
index d601f6e..d52df6b 100644
--- a/drivers/net/wireless/b43/radio_2056.h
+++ b/drivers/net/wireless/b43/radio_2056.h
@@ -1117,4 +1117,9 @@ struct b43_nphy_channeltab_entry_rev3 {
 void b2056_upload_inittabs(struct b43_wldev *dev,
 			   bool ghz5, bool ignore_uploadflag);
 
+/* Get the NPHY Channel Switch Table entry for a channel.
+ * Returns NULL on failure to find an entry. */
+const struct b43_nphy_channeltab_entry_rev3 *
+b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq);
+
 #endif /* B43_RADIO_2056_H_ */
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 1856936..a81696b 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -60,16 +60,8 @@ struct nphy_gain_ctl_workaround_entry {
 struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 	struct b43_wldev *dev, bool ghz5, bool ext_lna);
 
-/* Get the NPHY Channel Switch Table entry for a channel.
- * Returns NULL on failure to find an entry. */
-const struct b43_nphy_channeltab_entry_rev2 *
-b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel);
-const struct b43_nphy_channeltab_entry_rev3 *
-b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq);
-
 
 /* The N-PHY tables. */
-
 #define B43_NTAB_TYPEMASK		0xF0000000
 #define B43_NTAB_8BIT			0x10000000
 #define B43_NTAB_16BIT			0x20000000
-- 
1.7.3.4

