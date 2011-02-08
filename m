Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235Ab1BHIcP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Feb 2011 03:32:15 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 4/5] iwlwifi: fix ack health for WiFi/BT combo devices
Date: Tue,  8 Feb 2011 09:31:58 +0100
Message-Id: <1297153919-18766-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
References: <1297153919-18766-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Combo devices have TX statistics on different place, because
struct statistics_rx_bt and struct statistics_rx have different
size. User proper values on combo devices instead of random data.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8c4ca39..6dd5001 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1419,8 +1419,13 @@ bool iwl_good_ack_health(struct iwl_priv *priv, struct iwl_rx_packet *pkt)
 	if (priv->_agn.agg_tids_count)
 		return true;
 
-	cur = &pkt->u.stats.tx;
-	old = &priv->_agn.statistics.tx;
+	if (iwl_bt_statistics(priv)) {
+		cur = &pkt->u.stats_bt.tx;
+		old = &priv->_agn.statistics_bt.tx;
+	} else {
+		cur = &pkt->u.stats.tx;
+		old = &priv->_agn.statistics.tx;
+	}
 
 	actual_delta = le32_to_cpu(cur->actual_ack_cnt) -
 		       le32_to_cpu(old->actual_ack_cnt);
-- 
1.7.1

