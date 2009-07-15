Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52580 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbZGOAWC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:22:02 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/5] adm8211: remove uneeded code during suspend/resume
Date: Tue, 14 Jul 2009 20:21:57 -0400
Message-Id: <1247617320-20163-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
References: <1247617320-20163-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 drivers do not need to stop the software queues
or call their own stop() callback upon suspend as we do it
for drivers. Equally drivers don't have to call their own
start() or start the queues as mac80211 will do it for us.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/adm8211.c |   17 -----------------
 1 files changed, 0 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index ecc9383..5695911 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1964,14 +1964,6 @@ static void __devexit adm8211_remove(struct pci_dev *pdev)
 #ifdef CONFIG_PM
 static int adm8211_suspend(struct pci_dev *pdev, pm_message_t state)
 {
-	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct adm8211_priv *priv = dev->priv;
-
-	if (priv->mode != NL80211_IFTYPE_UNSPECIFIED) {
-		ieee80211_stop_queues(dev);
-		adm8211_stop(dev);
-	}
-
 	pci_save_state(pdev);
 	pci_set_power_state(pdev, pci_choose_state(pdev, state));
 	return 0;
@@ -1979,17 +1971,8 @@ static int adm8211_suspend(struct pci_dev *pdev, pm_message_t state)
 
 static int adm8211_resume(struct pci_dev *pdev)
 {
-	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
-	struct adm8211_priv *priv = dev->priv;
-
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
-
-	if (priv->mode != NL80211_IFTYPE_UNSPECIFIED) {
-		adm8211_start(dev);
-		ieee80211_wake_queues(dev);
-	}
-
 	return 0;
 }
 #endif /* CONFIG_PM */
-- 
1.6.0.6

