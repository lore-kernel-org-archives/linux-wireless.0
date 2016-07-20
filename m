Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:58907 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbcGTHa2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2016 03:30:28 -0400
From: "Reizer, Eyal" <eyalr@ti.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
	Rob Herring <robh@kernel.org>
Subject: [PATCH] wlcore: spi: fix build warning caused by redundant variable
Date: Wed, 20 Jul 2016 07:30:20 +0000
Message-ID: <8665E2433BC68541A24DFFCA87B70F5B36161A64@DFRE01.ent.ti.com> (sfid-20160720_093052_203036_1D772196)
References: <1468999637-31006-1-git-send-email-eyalr@ti.com>
In-Reply-To: <1468999637-31006-1-git-send-email-eyalr@ti.com>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ret variable is unused in wlcore_probe_of()
Remove it for fixing build warning.

Fixes: 01efe65aba65 ("wlcore: spi: add wl18xx support")
Signed-off-by: Eyal Reizer <eyalr@ti.com>
---
 drivers/net/wireless/ti/wlcore/spi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 73fbcf1..6d24040 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -454,7 +454,6 @@ static int wlcore_probe_of(struct spi_device *spi, struct wl12xx_spi_glue *glue,
 			   struct wlcore_platdev_data *pdev_data)
 {
 	struct device_node *dt_node = spi->dev.of_node;
-	int ret;
 	const struct of_device_id *of_id;
 
 	of_id = of_match_node(wlcore_spi_of_match_table, dt_node);
-- 
2.7.4

