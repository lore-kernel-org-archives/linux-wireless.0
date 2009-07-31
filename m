Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f200.google.com ([209.85.222.200]:45317 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbZGaSjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:39:20 -0400
Received: by pzk38 with SMTP id 38so1120652pzk.33
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 11:39:20 -0700 (PDT)
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: tharvey@irobot.com, dcbw@redhat.com,
	Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH] libertas: check valid bits in SPI bus mode reg
Date: Fri, 31 Jul 2009 11:35:19 -0700
Message-Id: <1249065319-18643-1-git-send-email-andrey@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SPI driver writes to the bus mode register and performs a sanity
check by reading back what we wrote, however only the lower four bits of
that register are defined.  In some cases, the device side seems to set
the higher bits, causing us to fail the sanity check unnecessarily.
Check only the lower four bits instead.

Thanks to John Goyette from Schick Technologies for pointing out the
problem.

Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
---
 drivers/net/wireless/libertas/if_spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index 6564282..86263a9 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -376,7 +376,7 @@ static int spu_set_bus_mode(struct if_spi_card *card, u16 mode)
 	err = spu_read_u16(card, IF_SPI_SPU_BUS_MODE_REG, &rval);
 	if (err)
 		return err;
-	if (rval != mode) {
+	if ((rval & 0xF) != mode) {
 		lbs_pr_err("Can't read bus mode register.\n");
 		return -EIO;
 	}
-- 
1.5.6.3

