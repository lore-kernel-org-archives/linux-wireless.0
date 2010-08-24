Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38122 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0HXMIF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 08:08:05 -0400
Date: Tue, 24 Aug 2010 14:07:43 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Ben Hutchings <ben@decadent.org.uk>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
Message-ID: <20100824120743.GG29330@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The indenting is not correct here.  I don't have this hardware and I'm
just guessing as to what was intended.  I think that if there is an
error we should return an error code, but if there isn't an error we
should return success directly without releasing the firmware.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
index fe3f080..123a541 100644
--- a/drivers/net/wireless/libertas/if_spi.c
+++ b/drivers/net/wireless/libertas/if_spi.c
@@ -471,9 +471,12 @@ static int if_spi_prog_helper_firmware(struct if_spi_card *card)
 		goto release_firmware;
 	err = spu_write_u16(card, IF_SPI_CARD_INT_CAUSE_REG,
 				IF_SPI_CIC_CMD_DOWNLOAD_OVER);
+	if (err)
 		goto release_firmware;
 
-	lbs_deb_spi("waiting for helper to boot...\n");
+	lbs_deb_spi("helper firmware loaded...\n");
+
+	return 0;
 
 release_firmware:
 	release_firmware(firmware);
