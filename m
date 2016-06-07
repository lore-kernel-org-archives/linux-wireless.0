Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:32791 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162046AbcFGUJB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 16:09:01 -0400
Date: Wed, 8 Jun 2016 01:38:53 +0530
From: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	Johannes Berg <johannes.berg@intel.com>
Cc: Tejun Heo <tj@kernel.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas_tf: Remove create_workqueue
Message-ID: <20160607200853.GA13742@Karyakshetra> (sfid-20160607_220939_915506_10A6F9CD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

alloc_workqueue replaces deprecated create_workqueue().

A dedicated workqueue has been used since the workitem (viz
&priv->cmd_work per priv, which maps to lbtf_cmd_work) is involved in
actual command processing and may be used on a memory reclaim path.
The workitems require forward progress under memory pressure and hence,
WQ_MEM_RECLAIM has been set. Since there are only a fixed number of work
items, explicit concurrency limit is unnecessary here.

Signed-off-by: Bhaktipriya Shridhar <bhaktipriya96@gmail.com>
---
 drivers/net/wireless/marvell/libertas_tf/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas_tf/main.c b/drivers/net/wireless/marvell/libertas_tf/main.c
index 0bf8916..81463f7 100644
--- a/drivers/net/wireless/marvell/libertas_tf/main.c
+++ b/drivers/net/wireless/marvell/libertas_tf/main.c
@@ -742,7 +742,7 @@ EXPORT_SYMBOL_GPL(lbtf_bcn_sent);
 static int __init lbtf_init_module(void)
 {
 	lbtf_deb_enter(LBTF_DEB_MAIN);
-	lbtf_wq = create_workqueue("libertastf");
+	lbtf_wq = alloc_workqueue("libertastf", WQ_MEM_RECLAIM, 0);
 	if (lbtf_wq == NULL) {
 		printk(KERN_ERR "libertastf: couldn't create workqueue\n");
 		return -ENOMEM;
--
2.1.4

