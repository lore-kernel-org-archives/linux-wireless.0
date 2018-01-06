Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:34303 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753439AbeAFBTI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jan 2018 20:19:08 -0500
Subject: [PATCH 11/18] cw1200: prevent bounds-check bypass via speculative
 execution
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, peterz@infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        Solomon Peachy <pizza@shaftnet.org>,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        torvalds@linux-foundation.org, Kalle Valo <kvalo@codeaurora.org>,
        alan@linux.intel.com
Date: Fri, 05 Jan 2018 17:10:53 -0800
Message-ID: <151520105352.32271.1167586482542492342.stgit@dwillia2-desk3.amr.corp.intel.com> (sfid-20180106_022139_404502_2FEE2EA3)
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Static analysis reports that 'queue' may be a user controlled value that
is used as a data dependency to read 'txq_params' from the
'priv->tx_queue_params.params' array.  In order to avoid potential leaks
of kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid value of 'txq_params'.
In this case 'txq_params' is referenced later in the function.

Based on an original patch by Elena Reshetova.

Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/wireless/st/cw1200/sta.c |   10 ++++++----
 drivers/net/wireless/st/cw1200/wsm.h |    4 +---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/sta.c b/drivers/net/wireless/st/cw1200/sta.c
index 38678e9a0562..886942617f14 100644
--- a/drivers/net/wireless/st/cw1200/sta.c
+++ b/drivers/net/wireless/st/cw1200/sta.c
@@ -14,6 +14,7 @@
 #include <linux/firmware.h>
 #include <linux/module.h>
 #include <linux/etherdevice.h>
+#include <linux/compiler.h>
 
 #include "cw1200.h"
 #include "sta.h"
@@ -612,18 +613,19 @@ int cw1200_conf_tx(struct ieee80211_hw *dev, struct ieee80211_vif *vif,
 		   u16 queue, const struct ieee80211_tx_queue_params *params)
 {
 	struct cw1200_common *priv = dev->priv;
+	struct wsm_set_tx_queue_params *txq_params;
 	int ret = 0;
 	/* To prevent re-applying PM request OID again and again*/
 	bool old_uapsd_flags;
 
 	mutex_lock(&priv->conf_mutex);
 
-	if (queue < dev->queues) {
+	if ((txq_params = nospec_array_ptr(priv->tx_queue_params.params,
+					queue, dev->queues))) {
 		old_uapsd_flags = le16_to_cpu(priv->uapsd_info.uapsd_flags);
 
-		WSM_TX_QUEUE_SET(&priv->tx_queue_params, queue, 0, 0, 0);
-		ret = wsm_set_tx_queue_params(priv,
-					      &priv->tx_queue_params.params[queue], queue);
+		WSM_TX_QUEUE_SET(txq_params, 0, 0, 0);
+		ret = wsm_set_tx_queue_params(priv, txq_params, queue);
 		if (ret) {
 			ret = -EINVAL;
 			goto out;
diff --git a/drivers/net/wireless/st/cw1200/wsm.h b/drivers/net/wireless/st/cw1200/wsm.h
index 48086e849515..8c8d9191e233 100644
--- a/drivers/net/wireless/st/cw1200/wsm.h
+++ b/drivers/net/wireless/st/cw1200/wsm.h
@@ -1099,10 +1099,8 @@ struct wsm_tx_queue_params {
 };
 
 
-#define WSM_TX_QUEUE_SET(queue_params, queue, ack_policy, allowed_time,\
-		max_life_time)	\
+#define WSM_TX_QUEUE_SET(p, ack_policy, allowed_time, max_life_time)	\
 do {							\
-	struct wsm_set_tx_queue_params *p = &(queue_params)->params[queue]; \
 	p->ackPolicy = (ack_policy);				\
 	p->allowedMediumTime = (allowed_time);				\
 	p->maxTransmitLifetime = (max_life_time);			\
