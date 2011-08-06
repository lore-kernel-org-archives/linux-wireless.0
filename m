Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33673 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab1HFOYL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Aug 2011 10:24:11 -0400
Date: Sat, 6 Aug 2011 07:23:44 -0700
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"open list:MARVELL LIBERTAS..." <libertas-dev@lists.infradead.org>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Subject: [patch] libertas: remove some dead code in
 if_spi_prog_helper_firmware()
Message-ID: <20110806142344.GA10373@mwanda> (sfid-20110806_162424_265672_A71EBCC4)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We always hit the goto and skip the printk().  The original code does
the right thing even though it looks messy.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index e0286cf..622ae6d 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -531,10 +531,6 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card,
 		goto out;
 	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
 				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
-		goto out;
-
-	lbs_deb_spi("waiting for helper to boot...\n");
-
 out:
 	if (err)
 		pr_err("failed to load helper firmware (err=%d)\n", err);
