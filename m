Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:35916 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab1EJXdX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 May 2011 19:33:23 -0400
Received: by ewy4 with SMTP id 4so1975941ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 10 May 2011 16:33:22 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] b43: implement timeouts workaround
Date: Wed, 11 May 2011 02:10:59 +0200
Message-Id: <1305072659-4011-2-git-send-email-zajec5@gmail.com> (sfid-20110511_013326_055907_556AAFEA)
In-Reply-To: <1305072659-4011-1-git-send-email-zajec5@gmail.com>
References: <1305072659-4011-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Documented in: <4BB81CAD.10602@lwfinger.net>

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/b43/main.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index fd8bd98..88bfd29 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4213,7 +4213,18 @@ static void b43_bluetooth_coext_disable(struct b43_wldev *dev)
 
 static void b43_imcfglo_timeouts_workaround(struct b43_wldev *dev)
 {
-	/* TODO: implement 80211 core workaround here */
+	struct ssb_bus *bus = dev->dev->bus;
+	u32 tmp;
+
+	if ((bus->chip_id == 0x4311 && bus->chip_rev == 2) ||
+	    (bus->chip_id == 0x4312)) {
+		tmp = ssb_read32(dev->dev, SSB_IMCFGLO);
+		tmp &= ~SSB_IMCFGLO_REQTO;
+		tmp &= ~SSB_IMCFGLO_SERTO;
+		tmp |= 0x3;
+		ssb_write32(dev->dev, SSB_IMCFGLO, tmp);
+		ssb_commit_settings(bus);
+	}
 }
 
 static void b43_set_synth_pu_delay(struct b43_wldev *dev, bool idle)
-- 
1.7.3.4

