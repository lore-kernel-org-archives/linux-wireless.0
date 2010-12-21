Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50654 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933189Ab0LUBCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 20:02:17 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/7] ath5k: Use pci_is_pcie()
Date: Tue, 21 Dec 2010 02:01:54 +0100
Message-Id: <1292893316-26694-6-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
References: <1292893316-26694-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use function pci_is_pcie() instead of accessing struct member directly.

CC: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/ath/ath5k/attach.c |    2 +-
 drivers/net/wireless/ath/ath5k/reset.c  |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 9dbc1fa..cdac5cf 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -276,7 +276,7 @@ int ath5k_hw_init(struct ath5k_softc *sc)
 	/*
 	 * Write PCI-E power save settings
 	 */
-	if ((ah->ah_version == AR5K_AR5212) && pdev && (pdev->is_pcie)) {
+	if ((ah->ah_version == AR5K_AR5212) && pdev && (pci_is_pcie(pdev))) {
 		ath5k_hw_reg_write(ah, 0x9248fc00, AR5K_PCIE_SERDES);
 		ath5k_hw_reg_write(ah, 0x24924924, AR5K_PCIE_SERDES);
 
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index bc84aaa..7297d7b 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -537,7 +537,7 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
-	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
@@ -594,7 +594,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 	 * we ingore that flag for PCI-E cards. On PCI cards
 	 * this flag gets cleared after 64 PCI clocks.
 	 */
-	bus_flags = (pdev && pdev->is_pcie) ? 0 : AR5K_RESET_CTL_PCI;
+	bus_flags = (pdev && pci_is_pcie(pdev)) ? 0 : AR5K_RESET_CTL_PCI;
 
 	if (ah->ah_version == AR5K_AR5210) {
 		ret = ath5k_hw_nic_reset(ah, AR5K_RESET_CTL_PCU |
-- 
1.7.1

