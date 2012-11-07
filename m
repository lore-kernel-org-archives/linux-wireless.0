Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:46479 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795Ab2KGNmV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 08:42:21 -0500
From: <Janusz.Dziedzic@tieto.com>
To: <linux-wireless@vger.kernel.org>
CC: <arik@wizery.com>
Date: Wed, 7 Nov 2012 15:42:19 +0200
Subject: [PATCH 2/2] wlcore: SPI - fix spi transfer_list
Message-ID: <3078A9B976EF864C8DDD0C499FFD07912383D647A0@EXMB01.eu.tieto.com> (sfid-20121107_144234_577028_F2D3B917)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In corner case for wl12xx_spi_raw_write() when
	len == SPI_AGGR_BUFFER_SIZE
we don't setup correctly spi transfer_list.
Next we will have garbage and strange errors
reported by SPI framework (eg. wrong speed_hz,
failed to transfer one message from queue)
when iterate transfer_list.

Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
---
 drivers/net/wireless/ti/wlcore/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 368d250..6242dd0 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -270,7 +270,7 @@ static int __must_check wl12xx_spi_raw_write(struct device *child, int addr,
 					     void *buf, size_t len, bool fixed)
 {
 	struct wl12xx_spi_glue *glue = dev_get_drvdata(child->parent);
-	struct spi_transfer t[2 * WSPI_MAX_NUM_OF_CHUNKS];
+	struct spi_transfer t[2 * (WSPI_MAX_NUM_OF_CHUNKS + 1)];
 	struct spi_message m;
 	u32 commands[WSPI_MAX_NUM_OF_CHUNKS];
 	u32 *cmd;
-- 
1.7.9.5

