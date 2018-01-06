Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27018 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753439AbeAFBS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jan 2018 20:18:57 -0500
Subject: [PATCH 09/18] p54: prevent bounds-check bypass via speculative
 execution
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, peterz@infradead.org,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Elena Reshetova <elena.reshetova@intel.com>,
        gregkh@linuxfoundation.org,
        Christian Lamparter <chunkeey@googlemail.com>,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        Kalle Valo <kvalo@codeaurora.org>, alan@linux.intel.com
Date: Fri, 05 Jan 2018 17:10:43 -0800
Message-ID: <151520104323.32271.6614158873750932410.stgit@dwillia2-desk3.amr.corp.intel.com> (sfid-20180106_022210_950892_EB6BA182)
In-Reply-To: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151520099201.32271.4677179499894422956.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Static analysis reports that 'queue' may be a user controlled value that
is used as a data dependency to read from the 'priv->qos_params' array.
In order to avoid potential leaks of kernel memory values, block
speculative execution of the instruction stream that could issue reads
based on an invalid result of 'priv->qos_params[queue]'.

Based on an original patch by Elena Reshetova.

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/net/wireless/intersil/p54/main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intersil/p54/main.c b/drivers/net/wireless/intersil/p54/main.c
index ab6d39e12069..85c9cbee35fc 100644
--- a/drivers/net/wireless/intersil/p54/main.c
+++ b/drivers/net/wireless/intersil/p54/main.c
@@ -20,6 +20,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/compiler.h>
 
 #include <net/mac80211.h>
 
@@ -411,12 +412,13 @@ static int p54_conf_tx(struct ieee80211_hw *dev,
 		       const struct ieee80211_tx_queue_params *params)
 {
 	struct p54_common *priv = dev->priv;
+	struct p54_edcf_queue_param *p54_q;
 	int ret;
 
 	mutex_lock(&priv->conf_mutex);
-	if (queue < dev->queues) {
-		P54_SET_QUEUE(priv->qos_params[queue], params->aifs,
-			params->cw_min, params->cw_max, params->txop);
+	if ((p54_q = nospec_array_ptr(priv->qos_params, queue, dev->queues))) {
+		P54_SET_QUEUE(p54_q[0], params->aifs, params->cw_min,
+				params->cw_max, params->txop);
 		ret = p54_set_edcf(priv);
 	} else
 		ret = -EINVAL;
