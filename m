Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbYIWAOb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 20:14:31 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 1/1] iwlwifi 2.6.27: send all the calibration results instead of the last one only
Date: Tue, 23 Sep 2008 03:14:28 +0300
Message-Id: <1222128868-16763-1-git-send-email-tomas.winkler@intel.com> (sfid-20080923_021435_697814_527D8EA8)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This patch solves a bug in calibration. We get three results from the
initial microcode, but we freed all the results upon each reception leading
to zero two of them, only the last one survived. This fix is user visible in
HT rates.

This patch simplifed version for 2.6.27 and will create conflict with 
86316f2fe474b019cc445211980f5394977b34d5 iwlwifi: generic init calibrations framework

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
Note this patch effects only 5000 HW (nor 3946 or 4965) so doesn't resolve or create any
regression. Anyhow it was thoroughly tested. 

 drivers/net/wireless/iwlwifi/iwl-5000.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b08036a..0d027c1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -512,23 +512,24 @@ static void iwl5000_rx_calib_result(struct iwl_priv *priv,
 	struct iwl5000_calib_hdr *hdr = (struct iwl5000_calib_hdr *)pkt->u.raw;
 	int len = le32_to_cpu(pkt->len) & FH_RSCSR_FRAME_SIZE_MSK;
 
-	iwl_free_calib_results(priv);
-
 	/* reduce the size of the length field itself */
 	len -= 4;
 
 	switch (hdr->op_code) {
 	case IWL5000_PHY_CALIBRATE_LO_CMD:
+		kfree(priv->calib_results.lo_res);
 		priv->calib_results.lo_res = kzalloc(len, GFP_ATOMIC);
 		priv->calib_results.lo_res_len = len;
 		memcpy(priv->calib_results.lo_res, pkt->u.raw, len);
 		break;
 	case IWL5000_PHY_CALIBRATE_TX_IQ_CMD:
+		kfree(priv->calib_results.tx_iq_res);
 		priv->calib_results.tx_iq_res = kzalloc(len, GFP_ATOMIC);
 		priv->calib_results.tx_iq_res_len = len;
 		memcpy(priv->calib_results.tx_iq_res, pkt->u.raw, len);
 		break;
 	case IWL5000_PHY_CALIBRATE_TX_IQ_PERD_CMD:
+		kfree(priv->calib_results.tx_iq_perd_res);
 		priv->calib_results.tx_iq_perd_res = kzalloc(len, GFP_ATOMIC);
 		priv->calib_results.tx_iq_perd_res_len = len;
 		memcpy(priv->calib_results.tx_iq_perd_res, pkt->u.raw, len);
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

