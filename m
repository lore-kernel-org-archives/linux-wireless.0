Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45833 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab1HMQOK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 12:14:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com, sgruszka@redhat.com
Subject: [PATCH] ath9k: remove a bogus WARN_ON
Date: Sat, 13 Aug 2011 10:13:49 -0600
Message-Id: <1313252029-17665-1-git-send-email-nbd@openwrt.org> (sfid-20110813_181415_983427_56FA9425)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On embedded hardware it's normal to not have a PCI device for the PCI
bridge that the wifi card is attached to. pdev->bus->self will be
NULL in that case. In that case, simply return without emitting an
useless kernel stack trace.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 5685cf1..d8f22aa 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -129,7 +129,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 		return;
 
 	parent = pdev->bus->self;
-	if (WARN_ON(!parent))
+	if (!parent)
 		return;
 
 	pos = pci_pcie_cap(parent);
-- 
1.7.3.2

