Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51748 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755826Ab1D0PoG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 11:44:06 -0400
Received: by fxm17 with SMTP id 17so1214241fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 08:44:04 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	=?UTF-8?q?Michael=20B=C3=BCsch?= <mb@bu3sch.de>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH] ssb: pci: early fix for SPROM core index
Date: Wed, 27 Apr 2011 18:21:34 +0200
Message-Id: <1303921294-6591-1-git-send-email-zajec5@gmail.com> (sfid-20110427_174411_035267_F8D85ED1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This was documented in:
Message-ID: <4BB81CAD.10602@lwfinger.net>
---
 drivers/ssb/driver_pcicore.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 32a9b61..8fde122 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -414,6 +414,16 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
  * Workarounds.
  **************************************************/
 
+static void ssb_pcicore_fix_sprom_core_index(struct ssb_pcicore *pc)
+{
+	u16 tmp = pcicore_read16(pc, SSB_PCICORE_SPROM(0));
+	if (((tmp & 0xF000) >> 12) != pc->dev->core_index) {
+		tmp &= ~0xF000;
+		tmp |= (pc->dev->core_index << 12);
+		pcicore_write16(pc, SSB_PCICORE_SPROM(0), tmp);
+	}
+}
+
 static u8 ssb_pcicore_polarity_workaround(struct ssb_pcicore *pc)
 {
 	return (ssb_pcie_read(pc, 0x204) & 0x10) ? 0xC0 : 0x80;
@@ -521,6 +531,8 @@ void ssb_pcicore_init(struct ssb_pcicore *pc)
 	if (!ssb_device_is_enabled(dev))
 		ssb_device_enable(dev, 0);
 
+	ssb_pcicore_fix_sprom_core_index(pc);
+
 #ifdef CONFIG_SSB_PCICORE_HOSTMODE
 	pc->hostmode = pcicore_is_in_hostmode(pc);
 	if (pc->hostmode)
-- 
1.7.3.4

