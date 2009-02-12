Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:36319 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755942AbZBLEkg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 23:40:36 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 11 Feb 2009 20:40:35 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18835.42854.638408.910086@gargle.gargle.HOWL> (sfid-20090212_054039_234491_7D494239)
Date: Thu, 12 Feb 2009 10:06:54 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 8/8] ath9k: Decrease minimum NF threshold
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The existing value was too conservative, causing
the history buffer not to be updated.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/calib.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath9k/calib.h b/drivers/net/wireless/ath9k/calib.h
index d2448f0..32589e0 100644
--- a/drivers/net/wireless/ath9k/calib.h
+++ b/drivers/net/wireless/ath9k/calib.h
@@ -27,7 +27,7 @@ extern const struct hal_percal_data adc_init_dc_cal;
 
 #define AR_PHY_CCA_MAX_GOOD_VALUE      		-85
 #define AR_PHY_CCA_MAX_HIGH_VALUE      		-62
-#define AR_PHY_CCA_MIN_BAD_VALUE       		-121
+#define AR_PHY_CCA_MIN_BAD_VALUE       		-140
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH_INIT     3
 #define AR_PHY_CCA_FILTERWINDOW_LENGTH          5
 
-- 
1.6.1

