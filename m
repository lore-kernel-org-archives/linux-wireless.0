Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:40404 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbbBFRgx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 12:36:53 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 3/6] brcmfmac: add debugfs file containing revision info
Date: Fri, 6 Feb 2015 18:36:44 +0100
Message-ID: <1423244207-9707-4-git-send-email-arend@broadcom.com> (sfid-20150206_183704_610058_BA00DE13)
In-Reply-To: <1423244207-9707-1-git-send-email-arend@broadcom.com>
References: <1423244207-9707-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the revision info visible in debugfs. The new debugfs
file is named 'revinfo'.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/core.c | 30 ++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/core.c b/drivers/net/wireless/brcm80211/brcmfmac/core.c
index 2d6e2cc..f8f47dc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/core.c
@@ -944,6 +944,34 @@ fail:
 	return ret;
 }
 
+static int brcmf_revinfo_read(struct seq_file *s, void *data)
+{
+	struct brcmf_bus *bus_if = dev_get_drvdata(s->private);
+	struct brcmf_rev_info *ri = &bus_if->drvr->revinfo;
+	char drev[BRCMU_DOTREV_LEN];
+	char brev[BRCMU_BOARDREV_LEN];
+
+	seq_printf(s, "vendorid: 0x%04x\n", ri->vendorid);
+	seq_printf(s, "deviceid: 0x%04x\n", ri->deviceid);
+	seq_printf(s, "radiorev: %s\n", brcmu_dotrev_str(ri->radiorev, drev));
+	seq_printf(s, "chipnum: %u (%x)\n", ri->chipnum, ri->chipnum);
+	seq_printf(s, "chiprev: %u\n", ri->chiprev);
+	seq_printf(s, "chippkg: %u\n", ri->chippkg);
+	seq_printf(s, "corerev: %u\n", ri->corerev);
+	seq_printf(s, "boardid: 0x%04x\n", ri->boardid);
+	seq_printf(s, "boardvendor: 0x%04x\n", ri->boardvendor);
+	seq_printf(s, "boardrev: %s\n", brcmu_boardrev_str(ri->boardrev, brev));
+	seq_printf(s, "driverrev: %s\n", brcmu_dotrev_str(ri->driverrev, drev));
+	seq_printf(s, "ucoderev: %u\n", ri->ucoderev);
+	seq_printf(s, "bus: %u\n", ri->bus);
+	seq_printf(s, "phytype: %u\n", ri->phytype);
+	seq_printf(s, "phyrev: %u\n", ri->phyrev);
+	seq_printf(s, "anarev: %u\n", ri->anarev);
+	seq_printf(s, "nvramrev: %08x\n", ri->nvramrev);
+
+	return 0;
+}
+
 int brcmf_bus_start(struct device *dev)
 {
 	int ret = -1;
@@ -974,6 +1002,8 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
+	brcmf_debugfs_add_entry(drvr, "revinfo", brcmf_revinfo_read);
+
 	/* assure we have chipid before feature attach */
 	if (!bus_if->chip) {
 		bus_if->chip = drvr->revinfo.chipnum;
-- 
1.9.1

