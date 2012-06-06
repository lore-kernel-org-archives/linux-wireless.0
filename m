Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33675 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab2FFNWX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:22:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ilan Peer <ilan.peer@intel.com>
Subject: [PATCH 09/29] iwlwifi: clear STATUS_SCAN_HW when PAN_PARAMS fails
Date: Wed,  6 Jun 2012 15:21:50 +0200
Message-Id: <1338988930-11561-9-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152241_717861_906CAF35)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The STATUS_SCAN_HW is set before calling iwlagn_set_pan_params
(used as an input to calculate slot time allocation). The bit needs
to be cleared in case sending the command fails.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-scan.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 069849e..a32b35e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -966,8 +966,10 @@ static int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	set_bit(STATUS_SCAN_HW, &priv->status);
 
 	ret = iwlagn_set_pan_params(priv);
-	if (ret)
+	if (ret) {
+		clear_bit(STATUS_SCAN_HW, &priv->status);
 		return ret;
+	}
 
 	ret = iwl_dvm_send_cmd(priv, &cmd);
 	if (ret) {
-- 
1.7.10

