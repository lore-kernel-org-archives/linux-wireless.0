Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55067 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071Ab0DODa6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:58 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 16/97] ath9k_hw: add the AR9003 ar9003_hw_macversion_supported()
Date: Wed, 14 Apr 2010 23:29:30 -0400
Message-Id: <1271302251-9075-17-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 7127166..0e78e35 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -574,6 +574,17 @@ static bool ar9002_hw_macversion_supported(u32 macversion)
 	return false;
 }
 
+static bool ar9003_hw_macversion_supported(u32 macversion)
+{
+	switch (macversion) {
+	case AR_SREV_VERSION_9300:
+		return true;
+	default:
+		break;
+	}
+	return false;
+}
+
 static void ar9002_hw_init_cal_settings(struct ath_hw *ah)
 {
 	if (AR_SREV_9160_10_OR_LATER(ah)) {
@@ -3543,5 +3554,9 @@ static void ar9002_hw_attach_ops(struct ath_hw *ah)
 /* Sets up the AR9003 hardware familiy callbacks */
 static void ar9003_hw_attach_ops(struct ath_hw *ah)
 {
+	struct ath_hw_private_ops *priv_ops = ath9k_hw_private_ops(ah);
+
+	priv_ops->macversion_supported = ar9003_hw_macversion_supported;
+
 	ar9003_hw_attach_phy_ops(ah);
 }
-- 
1.6.3.3

