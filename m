Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:34842 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbbFHMij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2015 08:38:39 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/4] brcmfmac: remove chipinfo debugfs entry
Date: Mon, 8 Jun 2015 14:38:33 +0200
Message-ID: <1433767115-8136-3-git-send-email-arend@broadcom.com> (sfid-20150608_143843_690273_7C6981A5)
In-Reply-To: <1433767115-8136-1-git-send-email-arend@broadcom.com>
References: <1433767115-8136-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The information provided by chipinfo is also provided by the
revinfo debugfs entry. Removing it from debugfs.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/debug.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
index 9b473d5..10a9221 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -41,15 +41,6 @@ void brcmf_debugfs_exit(void)
 	root_folder = NULL;
 }
 
-static int brcmf_debugfs_chipinfo_read(struct seq_file *seq, void *data)
-{
-	struct brcmf_bus *bus = dev_get_drvdata(seq->private);
-
-	seq_printf(seq, "chip: %x(%u) rev %u\n",
-		   bus->chip, bus->chip, bus->chiprev);
-	return 0;
-}
-
 int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 {
 	struct device *dev = drvr->bus_if->dev;
@@ -58,7 +49,6 @@ int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 		return -ENODEV;
 
 	drvr->dbgfs_dir = debugfs_create_dir(dev_name(dev), root_folder);
-	brcmf_debugfs_add_entry(drvr, "chipinfo", brcmf_debugfs_chipinfo_read);
 
 	return PTR_ERR_OR_ZERO(drvr->dbgfs_dir);
 }
-- 
1.9.1

