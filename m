Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:13855 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933199AbXJSO52 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Oct 2007 10:57:28 -0400
From: Bruno Randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Cc: Bruno Randolf <bruno@thinktube.com>
Subject: [PATCH] ath5k: mac revision fixes
Date: Fri, 19 Oct 2007 23:57:27 +0900
Message-Id: <1192805847-5236-1-git-send-email-bruno@thinktube.com> (sfid-20071019_155731_254380_BDD1C1CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

this are two small fixes:

1) actually print the mac revision when we say so

2) better check for mac revisions when putting device to sleep: this is
important with newer mac revisions (>=7.8) which will freeze the whole system
when put to sleep

Signed-off-by: Bruno Randolf <bruno@thinktube.com>
---
 drivers/net/wireless/ath5k/base.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 6cb8ccc..3f9dd0a 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -1000,8 +1000,7 @@ static int ath_stop_hw(struct ath_softc *sc)
 		 * (and system).  This varies by chip and is mostly an
 		 * issue with newer parts that go to sleep more quickly.
 		 */
-		if (sc->ah->ah_mac_version >= 7 &&
-				sc->ah->ah_mac_revision >= 8) {
+		if (sc->ah->ah_mac_srev >= 0x78) {
 			/*
 			 * XXX
 			 * don't put newer MAC revisions > 7.8 to sleep because
@@ -2462,7 +2461,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 
 	dev_info(&pdev->dev, "%s chip found: mac %d.%d phy %d.%d\n",
 			ath_chip_name(id->driver_data), sc->ah->ah_mac_version,
-			sc->ah->ah_mac_version, sc->ah->ah_phy_revision >> 4,
+			sc->ah->ah_mac_revision, sc->ah->ah_phy_revision >> 4,
 			sc->ah->ah_phy_revision & 0xf);
 
 	/* ready to process interrupts */
-- 
1.5.3.4

