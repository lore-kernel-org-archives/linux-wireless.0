Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50664 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0LUBCT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:19 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 6/7] ath9k: Use pci_is_pcie()
Date: Tue, 21 Dec 2010 02:01:55 +0100
Message-Id: <1292893316-26694-7-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function pci_is_pcie() instead of accessing struct member directly.

CC: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/ath/ath9k/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 7ca8499..2136242 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -96,7 +96,7 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	u8 aspm;
 
-	if (!pdev->is_pcie)
+	if (!pci_is_pcie(pdev))
 		return;
 
 	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
-- 
1.7.1

