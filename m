Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:34451 "EHLO
	annwn14.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752865AbXIXWNS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2007 18:13:18 -0400
From: Michael Wu <flamingice@sourmilk.net>
Subject: [PATCH 6/6] adm8211: Detect interface up/down in suspend/resume hooks correctly
Date: Mon, 24 Sep 2007 18:10:25 -0400
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-Id: <20070924221025.6870.73757.stgit@magic.sourmilk.net>
In-Reply-To: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
References: <20070924221025.6870.53754.stgit@magic.sourmilk.net>
Content-Type: text/plain;
  charset=utf-8;
  format=fixed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Wu <flamingice@sourmilk.net>

Interface up/down detection was incorrectly changed during the filter API
update.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
---

 drivers/net/wireless/adm8211.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/adm8211.c b/drivers/net/wireless/adm8211.c
index 95c8315..94f061c 100644
--- a/drivers/net/wireless/adm8211.c
+++ b/drivers/net/wireless/adm8211.c
@@ -1554,6 +1554,7 @@ static void adm8211_stop(struct ieee80211_hw *dev)
 {
 	struct adm8211_priv *priv = dev->priv;
 
+	priv->mode = IEEE80211_IF_TYPE_MGMT;
 	priv->nar = 0;
 	ADM8211_CSR_WRITE(NAR, 0);
 	ADM8211_CSR_WRITE(IER, 0);
@@ -1896,7 +1897,7 @@ static int __devinit adm8211_probe(struct pci_dev *pdev,
 	priv->tx_power = 0x40;
 	priv->lpf_cutoff = 0xFF;
 	priv->lnags_threshold = 0xFF;
-	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->mode = IEEE80211_IF_TYPE_MGMT;
 
 	/* Power-on issue. EEPROM won't read correctly without */
 	if (pdev->revision >= ADM8211_REV_BA) {
@@ -1991,7 +1992,7 @@ static int adm8211_suspend(struct pci_dev *pdev, pm_message_t state)
 	struct ieee80211_hw *dev = pci_get_drvdata(pdev);
 	struct adm8211_priv *priv = dev->priv;
 
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR) {
+	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
 		ieee80211_stop_queues(dev);
 		adm8211_stop(dev);
 	}
@@ -2009,7 +2010,7 @@ static int adm8211_resume(struct pci_dev *pdev)
 	pci_set_power_state(pdev, PCI_D0);
 	pci_restore_state(pdev);
 
-	if (priv->mode != IEEE80211_IF_TYPE_MNTR) {
+	if (priv->mode != IEEE80211_IF_TYPE_MGMT) {
 		adm8211_start(dev);
 		ieee80211_start_queues(dev);
 	}

