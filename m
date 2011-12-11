Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61077 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084Ab1LKBOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 20:14:50 -0500
Received: by mail-ee0-f46.google.com with SMTP id c4so976078eek.19
        for <linux-wireless@vger.kernel.org>; Sat, 10 Dec 2011 17:14:50 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 4/7] b43: N-PHY: add table for antenna software control
Date: Sun, 11 Dec 2011 02:55:32 +0100
Message-Id: <1323568535-2816-5-git-send-email-zajec5@gmail.com> (sfid-20111211_021454_051708_1BE9D791)
In-Reply-To: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
References: <1323568535-2816-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/tables_nphy.c |   50 +++++++++++++++++++++++++++++++-
 drivers/net/wireless/b43/tables_nphy.h |    3 ++
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 05ab6a4..691839e 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2171,6 +2171,48 @@ static const u16 b43_ntab_loftlt1_r3[] = {
 	0x0000, 0x0000,
 };
 
+/* volatile  tables, PHY revision >= 3 */
+
+/* indexed by antswctl2g */
+static const u16 b43_ntab_antswctl2g_r3[4][32] = {
+	{
+		0x0082, 0x0082, 0x0211, 0x0222, 0x0328,
+		0x0000, 0x0000, 0x0000, 0x0144, 0x0000,
+		0x0000, 0x0000, 0x0188, 0x0000, 0x0000,
+		0x0000, 0x0082, 0x0082, 0x0211, 0x0222,
+		0x0328, 0x0000, 0x0000, 0x0000, 0x0144,
+		0x0000, 0x0000, 0x0000, 0x0188, 0x0000,
+		0x0000, 0x0000,
+	},
+	{
+		0x0022, 0x0022, 0x0011, 0x0022, 0x0022,
+		0x0000, 0x0000, 0x0000, 0x0011, 0x0000,
+		0x0000, 0x0000, 0x0022, 0x0000, 0x0000,
+		0x0000, 0x0022, 0x0022, 0x0011, 0x0022,
+		0x0022, 0x0000, 0x0000, 0x0000, 0x0011,
+		0x0000, 0x0000, 0x0000, 0x0022, 0x0000,
+		0x0000, 0x0000,
+	},
+	{
+		0x0088, 0x0088, 0x0044, 0x0088, 0x0088,
+		0x0000, 0x0000, 0x0000, 0x0044, 0x0000,
+		0x0000, 0x0000, 0x0088, 0x0000, 0x0000,
+		0x0000, 0x0088, 0x0088, 0x0044, 0x0088,
+		0x0088, 0x0000, 0x0000, 0x0000, 0x0044,
+		0x0000, 0x0000, 0x0000, 0x0088, 0x0000,
+		0x0000, 0x0000,
+	},
+	{
+		0x0022, 0x0022, 0x0011, 0x0022, 0x0000,
+		0x0000, 0x0000, 0x0000, 0x0011, 0x0000,
+		0x0000, 0x0000, 0x0022, 0x0000, 0x0000,
+		0x03cc, 0x0022, 0x0022, 0x0011, 0x0022,
+		0x0000, 0x0000, 0x0000, 0x0000, 0x0011,
+		0x0000, 0x0000, 0x0000, 0x0022, 0x0000,
+		0x0000, 0x03cc,
+	}
+};
+
 /* TX gain tables */
 const u32 b43_ntab_tx_gain_rev0_1_2[] = {
 	0x03cc2b44, 0x03cc2b42, 0x03cc2a44, 0x03cc2a42,
@@ -3006,6 +3048,8 @@ void b43_nphy_rev0_1_2_tables_init(struct b43_wldev *dev)
 	} while (0)
 void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev)
 {
+	struct ssb_sprom *sprom = dev->dev->bus_sprom;
+
 	/* Static tables */
 	ntab_upload_r3(dev, B43_NTAB_FRAMESTRUCT_R3, b43_ntab_framestruct_r3);
 	ntab_upload_r3(dev, B43_NTAB_PILOT_R3, b43_ntab_pilot_r3);
@@ -3036,7 +3080,11 @@ void b43_nphy_rev3plus_tables_init(struct b43_wldev *dev)
 	ntab_upload_r3(dev, B43_NTAB_C1_LOFEEDTH_R3, b43_ntab_loftlt1_r3);
 
 	/* Volatile tables */
-	/* TODO */
+	if (sprom->fem.ghz2.antswlut < ARRAY_SIZE(b43_ntab_antswctl2g_r3))
+		ntab_upload_r3(dev, B43_NTAB_ANT_SW_CTL_R3,
+			       b43_ntab_antswctl2g_r3[sprom->fem.ghz2.antswlut]);
+	else
+		B43_WARN_ON(1);
 }
 
 struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index ddca0dd..97038c4 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -126,6 +126,9 @@ struct nphy_gain_ctl_workaround_entry *b43_nphy_get_gain_ctl_workaround_ent(
 #define B43_NTAB_C1_LOFEEDTH		B43_NTAB16(0x1B, 0x1C0) /* Local Oscillator Feed Through Lookup Table Core 1 */
 #define B43_NTAB_C1_LOFEEDTH_SIZE	128
 
+/* Volatile N-PHY tables, PHY revision >= 3 */
+#define B43_NTAB_ANT_SW_CTL_R3		B43_NTAB16( 9,   0) /* antenna software control */
+
 /* Static N-PHY tables, PHY revision >= 3 */
 #define B43_NTAB_FRAMESTRUCT_R3		B43_NTAB32(10,   0) /* frame struct  */
 #define B43_NTAB_PILOT_R3		B43_NTAB16(11,   0) /* pilot  */
-- 
1.7.3.4

