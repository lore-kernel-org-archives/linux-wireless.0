Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602AbZIWIvv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 04:51:51 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlagn: fix panic in iwl{5000,4965}_rx_reply_tx
Date: Wed, 23 Sep 2009 10:51:34 +0200
Message-Id: <1253695894-4553-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In some cases firmware can give us bad value of index in transmit
buffers array. This patch add sanity check for such values and return
from processing function instantly when it happens.

https://bugzilla.redhat.com/show_bug.cgi?id=521931

Patch was tested by reporter on iwl5000. I think check can be also
helpful for 4965.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    6 ++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c |    6 ++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 8f3d4bc..573818f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2019,6 +2019,12 @@ static int iwl4965_tx_status_reply_tx(struct iwl_priv *priv,
 					   agg->frame_count, txq_id, idx);
 
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
+			if (!hdr) {
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't point to valid skb"
+					" idx=%d, txq_id=%d\n", idx, txq_id);
+				return -1;
+			}
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index b3c648c..460f1fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1139,6 +1139,12 @@ static int iwl5000_tx_status_reply_tx(struct iwl_priv *priv,
 					   agg->frame_count, txq_id, idx);
 
 			hdr = iwl_tx_queue_get_hdr(priv, txq_id, idx);
+			if (!hdr) {
+				IWL_ERR(priv,
+					"BUG_ON idx doesn't point to valid skb"
+					" idx=%d, txq_id=%d\n", idx, txq_id);
+				return -1;
+			}
 
 			sc = le16_to_cpu(hdr->seq_ctrl);
 			if (idx != (SEQ_TO_SN(sc) & 0xff)) {
-- 
1.6.2.5

