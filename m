Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17857 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758998Ab2DJPQL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:16:11 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [WIP 11/11] ath9k: do not disable hardware while wow is enabled
Date: Tue, 10 Apr 2012 20:43:21 +0530
Message-ID: <1334070801-21708-12-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171621_118201_1D906F18)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/pci.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 9b25299..32608ea 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -310,6 +310,9 @@ static int ath_pci_suspend(struct device *device)
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

