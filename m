Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63185 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752614AbcL0PXs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 10:23:48 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable advertising support for channel 169, 5Ghz
Date: Tue, 27 Dec 2016 20:53:35 +0530
Message-ID: <1482852215-6438-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20161227_162352_421420_08E371A0)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Enable advertising support for channel 169, 5Ghz so that
based on the regulatory domain(country code) this channel
shall be active for use. For example in countries like India
this channel shall be available for use with latest regulatory updates

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h | 2 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 756e876..a19cef2 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -46,7 +46,7 @@
 #define WMI_READY_TIMEOUT (5 * HZ)
 #define ATH10K_FLUSH_TIMEOUT_HZ (5 * HZ)
 #define ATH10K_CONNECTION_LOSS_HZ (3 * HZ)
-#define ATH10K_NUM_CHANS 39
+#define ATH10K_NUM_CHANS 40
 
 /* Antenna noise floor */
 #define ATH10K_DEFAULT_NOISE_FLOOR -95
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 481842b..7d2f0ae 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7559,6 +7559,7 @@ struct ath10k_mac_change_chanctx_arg {
 	CHAN5G(157, 5785, 0),
 	CHAN5G(161, 5805, 0),
 	CHAN5G(165, 5825, 0),
+	CHAN5G(169, 5845, 0),
 };
 
 struct ath10k *ath10k_mac_create(size_t priv_size)
-- 
1.9.1
