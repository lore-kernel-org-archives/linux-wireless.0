Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47731 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab2FWQCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 12:02:47 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	Bala Shanmugam <bkamatch@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [PATCH v2 10/10] ath9k: do not disable hardware while wow is enabled
Date: Sat, 23 Jun 2012 21:29:54 +0530
Message-ID: <1340467194-16930-11-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120623_180250_729451_5DFEF70C)
In-Reply-To: <1340467194-16930-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340467194-16930-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Hardware needs to be AWAKE and should maintain association
with the AP to process WoW triggers any time

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index aa0e83a..87b89d5 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -313,6 +313,9 @@ static int ath_pci_suspend(struct device *device)
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
 
+	if (sc->wow_enabled)
+		return 0;
+
 	/* The device has to be moved to FULLSLEEP forcibly.
 	 * Otherwise the chip never moved to full sleep,
 	 * when no interface is up.
-- 
1.7.0.4

