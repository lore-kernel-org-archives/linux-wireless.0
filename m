Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:61608 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751626AbZLWNPQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:15:16 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] ath9k: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 14:04:43 +0100
Message-Id: <1261573483-8928-1-git-send-email-tklauser@distanz.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/ath/ath9k/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 5321f73..f7af5ea 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -96,7 +96,7 @@ static void ath_pci_bt_coex_prep(struct ath_common *common)
 	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
 }
 
-const static struct ath_bus_ops ath_pci_bus_ops = {
+static const struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
-- 
1.6.3.3

