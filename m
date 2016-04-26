Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:11556 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbcDZPZD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 11:25:03 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Move spectral related structures under ath10k debugfs
Date: Tue, 26 Apr 2016 20:54:36 +0530
Message-ID: <1461684276-4042-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160426_172508_237201_7979DB07)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Spectral related structures are accessed / modified only if ath10k
debugfs is enabled, so it makes more sense to move them under
ATH10K_DEBUGFS

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
[compile tested disabling ATH10K_DEBUGFS]

 drivers/net/wireless/ath/ath10k/core.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index c23c373..48fffef 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -868,8 +868,6 @@ struct ath10k {
 
 #ifdef CONFIG_ATH10K_DEBUGFS
 	struct ath10k_debug debug;
-#endif
-
 	struct {
 		/* relay(fs) channel for spectral scan */
 		struct rchan *rfs_chan_spec_scan;
@@ -878,6 +876,7 @@ struct ath10k {
 		enum ath10k_spectral_mode mode;
 		struct ath10k_spec_scan config;
 	} spectral;
+#endif
 
 	struct {
 		/* protected by conf_mutex */
-- 
1.7.9.5

