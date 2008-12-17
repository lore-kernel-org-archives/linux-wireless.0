Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:55837 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195AbYLQI7r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 03:59:47 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Wu, Fengguang" <fengguang.wu@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 6/8] iwlwifi: use meaningful vars in _iwl_poll_bit()
Date: Wed, 17 Dec 2008 16:52:32 +0800
Message-Id: <1229503954-30347-7-git-send-email-yi.zhu@intel.com> (sfid-20081217_095952_363346_3ED3EBE4)
In-Reply-To: <1229503954-30347-6-git-send-email-yi.zhu@intel.com>
References: <1229503954-30347-1-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-2-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-3-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-4-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-5-git-send-email-yi.zhu@intel.com>
 <1229503954-30347-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wu, Fengguang <fengguang.wu@intel.com>

Rename vars in _iwl_poll_bit() to better reflect the truth.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-io.h |   11 ++++++-----
 1 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index 998ac19..0a92e74 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -87,17 +87,18 @@ static inline u32 __iwl_read32(char *f, u32 l, struct iwl_priv *priv, u32 ofs)
 #define iwl_read32(p, o) _iwl_read32(p, o)
 #endif
 
+#define IWL_POLL_INTERVAL 10	/* microseconds */
 static inline int _iwl_poll_bit(struct iwl_priv *priv, u32 addr,
 				u32 bits, u32 mask, int timeout)
 {
-	int i = 0;
+	int t = 0;
 
 	do {
 		if ((_iwl_read32(priv, addr) & mask) == (bits & mask))
-			return i;
-		udelay(10);
-		i += 10;
-	} while (i < timeout);
+			return t;
+		udelay(IWL_POLL_INTERVAL);
+		t += IWL_POLL_INTERVAL;
+	} while (t < timeout);
 
 	return -ETIMEDOUT;
 }
-- 
1.5.3.6

