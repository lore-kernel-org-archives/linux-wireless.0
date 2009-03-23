Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51730 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752210AbZCWXDc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 19:03:32 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: stable@kernel.org
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/2] ath9k: AR9280 PCI devices must serialize IO as well
Date: Mon, 23 Mar 2009 19:03:30 -0400
Message-Id: <1237849410-17314-2-git-send-email-lrodriguez@atheros.com> (sfid-20090324_000336_918608_EE05E19A)
In-Reply-To: <1237849410-17314-1-git-send-email-lrodriguez@atheros.com>
References: <1237849410-17314-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a port of:
commit SHA1 5ec905a8df3fa877566ba98298433fbfb3d688cc
for 2.6.27

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/hw.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index 4a35266..c40b677 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -3313,7 +3313,8 @@ static struct ath_hal *ath9k_hw_do_attach(u16 devid,
 	}
 
 	if (ah->ah_config.serialize_regmode == SER_REG_MODE_AUTO) {
-		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI) {
+		if (ah->ah_macVersion == AR_SREV_VERSION_5416_PCI ||
+		    (AR_SREV_9280(ah) && !ah->ah_isPciExpress)) {
 			ah->ah_config.serialize_regmode =
 				SER_REG_MODE_ON;
 		} else {
-- 
1.5.6.4

