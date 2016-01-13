Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:33125 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759336AbcAMOAC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 09:00:02 -0500
Received: by mail-lf0-f41.google.com with SMTP id m198so108395924lfm.0
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jan 2016 06:00:01 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 3/5] ath10k: add new FW_FEATURE_PEER_FLOW_CONTROL
Date: Wed, 13 Jan 2016 15:01:06 +0100
Message-Id: <1452693668-30030-4-git-send-email-michal.kazior@tieto.com> (sfid-20160113_150017_335591_F55BA554)
In-Reply-To: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
References: <1452693668-30030-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature flag will be used for firmware which
supports pull-push model where host shares it's
software queue state with firmware and firmware
generates fetch requests telling host which queues
to dequeue tx from.

Primary function of this is improved MU-MIMO
performance with multiple clients.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 9 +++++++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index b41eb3f4ee56..48a26206c5c1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -217,6 +217,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_RAW_MODE_SUPPORT] = "raw-mode",
 	[ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA] = "adaptive-cca",
 	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
+	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] = "peer-flow-ctrl",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7840cf3ef7a6..822e3195533a 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -510,6 +510,15 @@ enum ath10k_fw_features {
 	/* Firmware supports management frame protection */
 	ATH10K_FW_FEATURE_MFP_SUPPORT = 12,
 
+	/* Firmware supports pull-push model where host shares it's software
+	 * queue state with firmware and firmware generates fetch requests
+	 * telling host which queues to dequeue tx from.
+	 *
+	 * Primary function of this is improved MU-MIMO performance with
+	 * multiple clients.
+	 */
+	ATH10K_FW_FEATURE_PEER_FLOW_CONTROL = 13,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
-- 
2.1.4

