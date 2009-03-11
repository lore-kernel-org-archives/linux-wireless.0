Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40720 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZCKCwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 22:52:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>, stable@kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v5 2/4] ath9k: AR9280 PCI devices must serialize IO as well
Date: Tue, 10 Mar 2009 22:52:31 -0400
Message-Id: <1236739953-17701-3-git-send-email-lrodriguez@atheros.com> (sfid-20090311_035303_650493_28856986)
In-Reply-To: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
References: <1236739953-17701-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/ath9k/hw.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 50a44a0..51d3a4e 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -628,8 +628,15 @@ static struct ath_hw *ath9k_hw_do_attach(u16 devid, struct ath_softc *sc,
 		goto bad;
 	}
 
+	/*
+	 * All PCI devices should be put here.
+	 * XXX: remove ah->is_pciexpress and use pdev->is_pcie, then
+	 * we can just check for !pdev->is_pcie here, but
+	 * consideration must be taken for handling AHB as well.
+	 */
 	if (ah->config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI) {
+		if (ah->hw_version.macVersion == AR_SREV_VERSION_5416_PCI ||
+		    (AR_SREV_9280(ah) && !ah->is_pciexpress)) {
 			ah->config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
-- 
1.6.0.6

