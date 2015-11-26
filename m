Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49709 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbbKZMQO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:16:14 -0500
From: Mark Brown <broonie@kernel.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	Mark Brown <broonie@kernel.org>
Date: Thu, 26 Nov 2015 12:15:35 +0000
Message-Id: <1448540135-9388-1-git-send-email-broonie@kernel.org> (sfid-20151126_131619_387172_D2FFBDAD)
Subject: [PATCH] ath10k: Fix check for !THERMAL case
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When defining stubs for !THERMAL cases we currently check if CONFIG_THERMAL
is defined but this fails when the thermal code is built as a module in
which case CONFIG_THERMAL_MODULE is defined instead causing us to define
the stubs as well as building the actual ath10k thermal code which in turn
causes the build to fail on arm64 allmodconfig. Fix this by changing the
check in the header to use IS_ENABLED().

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/net/wireless/ath/ath10k/thermal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/thermal.h b/drivers/net/wireless/ath/ath10k/thermal.h
index b610ea5caae8..793eec160e65 100644
--- a/drivers/net/wireless/ath/ath10k/thermal.h
+++ b/drivers/net/wireless/ath/ath10k/thermal.h
@@ -36,7 +36,7 @@ struct ath10k_thermal {
 	int temperature;
 };
 
-#ifdef CONFIG_THERMAL
+#if IS_ENABLED(CONFIG_THERMAL)
 int ath10k_thermal_register(struct ath10k *ar);
 void ath10k_thermal_unregister(struct ath10k *ar);
 void ath10k_thermal_event_temperature(struct ath10k *ar, int temperature);
-- 
2.6.2

