Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:52765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632AbYGAHo5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 03:44:57 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 2/2] iwlwifi: request Tx of bar if necessary
Date: Tue,  1 Jul 2008 10:44:51 +0300
Message-Id: <1214898291-6232-4-git-send-email-tomas.winkler@intel.com> (sfid-20080701_094503_351677_00B3060E)
In-Reply-To: <1214898291-6232-3-git-send-email-tomas.winkler@intel.com>
References: <1214898291-6232-1-git-send-email-tomas.winkler@intel.com>
 <1214898291-6232-2-git-send-email-tomas.winkler@intel.com>
 <1214898291-6232-3-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch sets the block ack request flag if needed

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8c93f8d..04365b3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2285,9 +2285,9 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 
 		iwl4965_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
-		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
-			/* TODO: send BAR */
-		}
+		/* check if BAR is needed */
+		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status))
+			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			int freed, ampdu_q;
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 7cc73e9..717db0d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1278,9 +1278,9 @@ static void iwl5000_rx_reply_tx(struct iwl_priv *priv,
 
 		iwl5000_tx_status_reply_tx(priv, agg, tx_resp, txq_id, index);
 
-		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status)) {
-			/* TODO: send BAR */
-		}
+		/* check if BAR is needed */
+		if ((tx_resp->frame_count == 1) && !iwl_is_tx_success(status))
+			info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 
 		if (txq->q.read_ptr != (scd_ssn & 0xff)) {
 			int freed, ampdu_q;
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

