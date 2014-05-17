Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:37817 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaEQWWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 May 2014 18:22:46 -0400
Received: by mail-ee0-f43.google.com with SMTP id d17so2499190eek.2
        for <linux-wireless@vger.kernel.org>; Sat, 17 May 2014 15:22:45 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>, b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: sprom: add dev_id field for value overriding standard ID
Date: Sun, 18 May 2014 00:22:38 +0200
Message-Id: <1400365358-19604-1-git-send-email-zajec5@gmail.com> (sfid-20140518_002250_508501_A15BB207)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some devices may have different features despite sharing the same ID
(e.g. PCI ID). For example 14e4:4331 is usually a dual band, but this
can be "limited". Device with "pci/x/y/devid=0x4332" supports 2.4 GHz
only. Similarly 0x4333 will mean support for 5 GHz only.
Add entry in SPROM so info described above can be extracted and stored.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I managed to find "devid" on every common SPROM rev:
pci/1/1/sromrev=2
pci/1/1/devid=0x4318

pci/1/1/sromrev=4
pci/1/1/devid=0x4329

pci/1/1/sromrev=8
pci/1/1/devid=0x432d

pci/1/1/sromrev=9
pci/1/1/devid=0x4332

pci/1/1/sromrev=11
pci/1/1/devid=0x43a1

So it makes the most sense to always try to extract it.
---
 arch/mips/bcm47xx/sprom.c | 1 +
 include/linux/ssb/ssb.h   | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/mips/bcm47xx/sprom.c b/arch/mips/bcm47xx/sprom.c
index a8b5408..da4cdb1 100644
--- a/arch/mips/bcm47xx/sprom.c
+++ b/arch/mips/bcm47xx/sprom.c
@@ -168,6 +168,7 @@ static void nvram_read_alpha2(const char *prefix, const char *name,
 static void bcm47xx_fill_sprom_r1234589(struct ssb_sprom *sprom,
 					const char *prefix, bool fallback)
 {
+	nvram_read_u16(prefix, NULL, "devid", &sprom->dev_id, 0, fallback);
 	nvram_read_u8(prefix, NULL, "ledbh0", &sprom->gpio0, 0xff, fallback);
 	nvram_read_u8(prefix, NULL, "ledbh1", &sprom->gpio1, 0xff, fallback);
 	nvram_read_u8(prefix, NULL, "ledbh2", &sprom->gpio2, 0xff, fallback);
diff --git a/include/linux/ssb/ssb.h b/include/linux/ssb/ssb.h
index 07ef9b8..4568a5c 100644
--- a/include/linux/ssb/ssb.h
+++ b/include/linux/ssb/ssb.h
@@ -33,6 +33,7 @@ struct ssb_sprom {
 	u8 et1phyaddr;		/* MII address for enet1 */
 	u8 et0mdcport;		/* MDIO for enet0 */
 	u8 et1mdcport;		/* MDIO for enet1 */
+	u16 dev_id;		/* Device ID overriding e.g. PCI ID */
 	u16 board_rev;		/* Board revision number from SPROM. */
 	u16 board_num;		/* Board number from SPROM. */
 	u16 board_type;		/* Board type from SPROM. */
-- 
1.8.4.5

