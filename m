Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:44238 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757890AbZKXDaQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 22:30:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/8] iwmc3200wifi: Dont set the UMAC power limit when interface is down
Date: Tue, 24 Nov 2009 11:33:28 +0800
Message-Id: <1259033613-25600-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
References: <1259033613-25600-1-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-2-git-send-email-yi.zhu@intel.com>
 <1259033613-25600-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

When we're down, we shouldnt try to set the UMAC power limit. We just return 0
instead, and cfg80211 toggles the soft rfkill state.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/cfg80211.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/cfg80211.c b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
index 2e00a4b..7cfc2c0 100644
--- a/drivers/net/wireless/iwmc3200wifi/cfg80211.c
+++ b/drivers/net/wireless/iwmc3200wifi/cfg80211.c
@@ -678,6 +678,9 @@ static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
 	case TX_POWER_AUTOMATIC:
 		return 0;
 	case TX_POWER_FIXED:
+		if (!test_bit(IWM_STATUS_READY, &iwm->status))
+			return 0;
+
 		ret = iwm_umac_set_config_fix(iwm, UMAC_PARAM_TBL_CFG_FIX,
 					      CFG_TX_PWR_LIMIT_USR, dbm * 2);
 		if (ret < 0)
@@ -685,6 +688,7 @@ static int iwm_cfg80211_set_txpower(struct wiphy *wiphy,
 
 		return iwm_tx_power_trigger(iwm);
 	default:
+		IWM_ERR(iwm, "Unsupported power type: %d\n", type);
 		return -EOPNOTSUPP;
 	}
 
-- 
1.6.0.4

