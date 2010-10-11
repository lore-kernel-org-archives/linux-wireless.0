Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56276 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0JKBTQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 21:19:16 -0400
Received: by bwz15 with SMTP id 15so1405937bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 18:19:15 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] b43: N-PHY: prepare for rev3+ channel tables
Date: Mon, 11 Oct 2010 03:19:22 +0200
Message-Id: <1286759962-374-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
After not getting help with channel numbering on linux-wireless@ plus some
talks on IRC where few ppl claimed channel numbers are messy I decided to
check for freq. Maybe I'll switch rev2 tables to freq as well (later).

This patch makes two lines over 80 chars wide. I found it nicer to read them
when comparing to line breaking. However if this is any problem, just let me
know.
---
 drivers/net/wireless/b43/phy_n.c       |    3 ++-
 drivers/net/wireless/b43/tables_nphy.c |   24 +++++++++++++++++++++---
 drivers/net/wireless/b43/tables_nphy.h |    4 +++-
 3 files changed, 26 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 21cfd42..814127e 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -3399,7 +3399,8 @@ static int b43_nphy_set_channel(struct b43_wldev *dev,
 	u8 tmp;
 
 	if (dev->phy.rev >= 3) {
-		/* TODO */
+		tabent_r3 = b43_nphy_get_chantabent_rev3(dev,
+							channel->center_freq);
 		tabent_r3 = NULL;
 		if (!tabent_r3)
 			return -ESRCH;
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index d96e870..e74b8eb 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -325,7 +325,7 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 	.phy_regs.phy_bw5	= r4,	\
 	.phy_regs.phy_bw6	= r5
 
-static const struct b43_nphy_channeltab_entry_rev2 b43_nphy_channeltab[] = {
+static const struct b43_nphy_channeltab_entry_rev2 b43_nphy_channeltab_rev2[] = {
   {	.channel		= 184,
 	.freq			= 4920, /* MHz */
 	.unk2			= 3280,
@@ -1326,8 +1326,8 @@ b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel)
 	const struct b43_nphy_channeltab_entry_rev2 *e;
 	unsigned int i;
 
-	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab); i++) {
-		e = &(b43_nphy_channeltab[i]);
+	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab_rev2); i++) {
+		e = &(b43_nphy_channeltab_rev2[i]);
 		if (e->channel == channel)
 			return e;
 	}
@@ -1335,6 +1335,24 @@ b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel)
 	return NULL;
 }
 
+static const struct b43_nphy_channeltab_entry_rev3 b43_nphy_channeltab_rev3[] = {
+};
+
+const struct b43_nphy_channeltab_entry_rev3 *
+b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq)
+{
+	const struct b43_nphy_channeltab_entry_rev3 *e;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(b43_nphy_channeltab_rev3); i++) {
+		e = &(b43_nphy_channeltab_rev3[i]);
+		if (e->freq == freq)
+			return e;
+	}
+
+	return NULL;
+}
+
 
 static const u8 b43_ntab_adjustpower0[] = {
 	0x00, 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01,
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 8fc1da9..3eedb86 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -90,10 +90,12 @@ void b2055_upload_inittab(struct b43_wldev *dev,
 			  bool ghz5, bool ignore_uploadflag);
 
 
-/* Get the NPHY Channel Switch Table entry for a channel number.
+/* Get the NPHY Channel Switch Table entry for a channel.
  * Returns NULL on failure to find an entry. */
 const struct b43_nphy_channeltab_entry_rev2 *
 b43_nphy_get_chantabent_rev2(struct b43_wldev *dev, u8 channel);
+const struct b43_nphy_channeltab_entry_rev3 *
+b43_nphy_get_chantabent_rev3(struct b43_wldev *dev, u16 freq);
 
 
 /* The N-PHY tables. */
-- 
1.7.1

