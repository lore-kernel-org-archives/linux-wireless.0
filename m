Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bastet.se.axis.com ([195.60.68.11]:37971 "EHLO
	bastet.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530AbbETOCS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 10:02:18 -0400
Date: Wed, 20 May 2015 16:02:15 +0200
From: Henrik Eriksson <henrik.eriksson@axis.com>
To: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org
Subject: [PATCH] brcmfmac: clear sdiodev->pdata if irq_of_parse_and_map fails
Message-ID: <20150520140206.GA11272@linux.se.axis.com> (sfid-20150520_160221_986114_985C5110)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Clear the pdata pointer in sdiodev after freeing the memory.  In my case
not doing so interferes with device initialization as request_irq of
sdiodev->pdata->oob_irq_nr fails, but even if not, leaving a wild
pointer is incorrect.

Signed-off-by: Henrik Eriksson <henriken@axis.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/of.c b/drivers/net/wireless/brcm80211/brcmfmac/of.c
index c824570..71ead7b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/of.c
@@ -43,6 +43,7 @@ void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 	if (!irq) {
 		brcmf_err("interrupt could not be mapped\n");
 		devm_kfree(dev, sdiodev->pdata);
+		sdiodev->pdata = NULL;
 		return;
 	}
 	irqf = irqd_get_trigger_type(irq_get_irq_data(irq));
-- 
2.0.4
