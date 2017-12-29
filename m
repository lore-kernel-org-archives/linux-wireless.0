Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.14]:63774 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751412AbdL2TvY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 14:51:24 -0500
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>, Eyal Reizer <eyalr@ti.com>,
        Franky Lin <franky.lin@broadcom.com>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Iain Hunter <drhunter95@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sebastian Reichel <sre@kernel.org>,
        Tony Lindgren <tony@atomide.com>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] wlcore: Delete an error message for a failed memory
 allocation in three functions
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Message-ID: <a5e86825-a5e2-a9e7-9036-b7ef3a1814fe@users.sourceforge.net> (sfid-20171229_205149_385796_46081B5E)
Date: Fri, 29 Dec 2017 20:50:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 29 Dec 2017 20:40:49 +0100

Omit an extra message for a memory allocation failure in these functions.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/net/wireless/ti/wlcore/main.c | 8 ++------
 drivers/net/wireless/ti/wlcore/spi.c  | 4 +---
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c346c021b999..970e59871547 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1301,10 +1301,8 @@ static struct sk_buff *wl12xx_alloc_dummy_packet(struct wl1271 *wl)
 			    sizeof(struct wl1271_tx_hw_descr) - sizeof(*hdr);
 
 	skb = dev_alloc_skb(TOTAL_TX_DUMMY_PACKET_SIZE);
-	if (!skb) {
-		wl1271_warning("Failed to allocate a dummy packet skb");
+	if (!skb)
 		return NULL;
-	}
 
 	skb_reserve(skb, sizeof(struct wl1271_tx_hw_descr));
 
@@ -1421,10 +1419,8 @@ int wl1271_rx_filter_alloc_field(struct wl12xx_rx_filter *filter,
 	field = &filter->fields[filter->num_fields];
 
 	field->pattern = kzalloc(len, GFP_KERNEL);
-	if (!field->pattern) {
-		wl1271_warning("Failed to allocate RX filter pattern");
+	if (!field->pattern)
 		return -ENOMEM;
-	}
 
 	filter->num_fields++;
 
diff --git a/drivers/net/wireless/ti/wlcore/spi.c b/drivers/net/wireless/ti/wlcore/spi.c
index 62ce54a949e9..fc94a0d1a01d 100644
--- a/drivers/net/wireless/ti/wlcore/spi.c
+++ b/drivers/net/wireless/ti/wlcore/spi.c
@@ -489,10 +489,8 @@ static int wl1271_probe(struct spi_device *spi)
 	pdev_data->if_ops = &spi_ops;
 
 	glue = devm_kzalloc(&spi->dev, sizeof(*glue), GFP_KERNEL);
-	if (!glue) {
-		dev_err(&spi->dev, "can't allocate glue\n");
+	if (!glue)
 		return -ENOMEM;
-	}
 
 	glue->dev = &spi->dev;
 
-- 
2.15.1
