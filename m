Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:49446 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564Ab1AEAbw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 19:31:52 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 4/5] iwlagn: return error if PAN disable timeout
Date: Tue,  4 Jan 2011 16:22:02 -0800
Message-Id: <1294186923-4582-5-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1294186923-4582-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index 99e9650..6e80f10 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -74,8 +74,10 @@ static int iwlagn_disable_pan(struct iwl_priv *priv,
 		signed long wait_res;
 
 		wait_res = iwlagn_wait_notification(priv, &disable_wait, HZ);
-		if (wait_res == 0)
+		if (wait_res == 0) {
 			IWL_ERR(priv, "Timed out waiting for PAN disable\n");
+			ret = -EIO;
+		}
 	}
 
 	return ret;
-- 
1.7.0.4

