Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40970 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab1H1QIH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Aug 2011 12:08:07 -0400
Received: by mail-fx0-f46.google.com with SMTP id 19so3772058fxh.19
        for <linux-wireless@vger.kernel.org>; Sun, 28 Aug 2011 09:08:06 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: b43-dev@lists.infradead.org,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: extract some basic info about board from SPROM
Date: Sun, 28 Aug 2011 18:47:23 +0200
Message-Id: <1314550043-6220-2-git-send-email-zajec5@gmail.com> (sfid-20110828_180811_549683_95C814A4)
In-Reply-To: <1314550043-6220-1-git-send-email-zajec5@gmail.com>
References: <1314550043-6220-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/sprom.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/bcma/sprom.c b/drivers/bcma/sprom.c
index 166ed13..d729239 100644
--- a/drivers/bcma/sprom.c
+++ b/drivers/bcma/sprom.c
@@ -133,6 +133,15 @@ static void bcma_sprom_extract_r8(struct bcma_bus *bus, const u16 *sprom)
 		v = sprom[SPOFF(SSB_SPROM8_IL0MAC) + i];
 		*(((__be16 *)bus->sprom.il0mac) + i) = cpu_to_be16(v);
 	}
+
+	bus->sprom.board_rev = sprom[SPOFF(SSB_SPROM8_BOARDREV)];
+
+	bus->sprom.boardflags_lo = sprom[SPOFF(SSB_SPROM8_BFLLO)];
+	bus->sprom.boardflags_hi = sprom[SPOFF(SSB_SPROM8_BFLHI)];
+	bus->sprom.boardflags2_lo = sprom[SPOFF(SSB_SPROM8_BFL2LO)];
+	bus->sprom.boardflags2_hi = sprom[SPOFF(SSB_SPROM8_BFL2HI)];
+
+	bus->sprom.country_code = sprom[SPOFF(SSB_SPROM8_CCODE)];
 }
 
 int bcma_sprom_get(struct bcma_bus *bus)
-- 
1.7.3.4

