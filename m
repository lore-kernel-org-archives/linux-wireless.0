Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:57398 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756926Ab2IJJFc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 05:05:32 -0400
From: Colin King <colin.king@canonical.com>
To: "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] brcm80211: fix missing allocation failure check
Date: Mon, 10 Sep 2012 10:05:26 +0100
Message-Id: <1347267926-7118-1-git-send-email-colin.king@canonical.com> (sfid-20120910_110619_787790_2FAB5ACD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Check for oobirq_entry allocation failure to avoid
NULL pointer dereferencing.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 49765d3..7c4ee72 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -638,6 +638,8 @@ static int brcmf_sdio_pd_probe(struct platform_device *pdev)
 
 		oobirq_entry = kzalloc(sizeof(struct brcmf_sdio_oobirq),
 				       GFP_KERNEL);
+		if (!oobirq_entry)
+			return -ENOMEM;
 		oobirq_entry->irq = res->start;
 		oobirq_entry->flags = res->flags & IRQF_TRIGGER_MASK;
 		list_add_tail(&oobirq_entry->list, &oobirq_lh);
-- 
1.7.10.4

