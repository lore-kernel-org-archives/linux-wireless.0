Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52459 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab1F0RtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 13:49:01 -0400
Received: by pvg12 with SMTP id 12so2994431pvg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 10:49:00 -0700 (PDT)
From: Jon Mason <jdmason@kudzu.us>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 17/19] iwlegacy: remove unnecessary read of PCI_CAP_ID_EXP
Date: Mon, 27 Jun 2011 12:48:54 -0500
Message-Id: <1309196934-16314-1-git-send-email-jdmason@kudzu.us> (sfid-20110627_194932_258440_1935426E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCIE capability offset is saved during PCI bus walking.  It will
remove an unnecessary search in the PCI configuration space if this
value is referenced instead of reacquiring it.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/net/wireless/iwlegacy/iwl-core.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index a2de7e9..84da793 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -484,7 +484,7 @@ static inline u16 iwl_legacy_pcie_link_ctl(struct iwl_priv *priv)
 {
 	int pos;
 	u16 pci_lnk_ctl;
-	pos = pci_find_capability(priv->pci_dev, PCI_CAP_ID_EXP);
+	pos = pci_pcie_cap(priv->pci_dev);
 	pci_read_config_word(priv->pci_dev, pos + PCI_EXP_LNKCTL, &pci_lnk_ctl);
 	return pci_lnk_ctl;
 }
-- 
1.7.5.4

