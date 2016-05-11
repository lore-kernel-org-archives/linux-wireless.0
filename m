Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53949 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbcEKRCp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 13:02:45 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2 15/21] ath10k: support CT firmware flag.
Date: Wed, 11 May 2016 10:02:27 -0700
Message-Id: <1462986153-16318-16-git-send-email-greearb@candelatech.com> (sfid-20160511_192231_580341_4C06002A)
In-Reply-To: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Add placeholder so CT firmware can more easily co-exist with upstream
kernel.  CT firmware should be backwards compatible with existing kernels,
but it also has many new features.  Subsequent patches, if acceptable for
upstream, can enable and further describe those features.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 1 +
 drivers/net/wireless/ath/ath10k/core.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index fa71d57..49c85c3 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -235,6 +235,7 @@ static const char *const ath10k_core_fw_feature_str[] = {
 	[ATH10K_FW_FEATURE_SUPPORTS_ADAPTIVE_CCA] = "adaptive-cca",
 	[ATH10K_FW_FEATURE_MFP_SUPPORT] = "mfp",
 	[ATH10K_FW_FEATURE_PEER_FLOW_CONTROL] = "peer-flow-ctrl",
+	[ATH10K_FW_FEATURE_WMI_10X_CT] = "wmi-10.x-CT",
 };
 
 static unsigned int ath10k_core_get_fw_feature_str(char *buf,
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index cb6aa8c..f9e3b20 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -566,6 +566,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_PEER_FLOW_CONTROL = 13,
 
+	/* Firmware from Candela Technologies, enables more VIFs, etc */
+	ATH10K_FW_FEATURE_WMI_10X_CT = 31,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
-- 
2.4.3

