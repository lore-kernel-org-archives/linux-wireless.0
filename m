Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53137 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab1BMR5u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 12:57:50 -0500
Received: by mail-iw0-f174.google.com with SMTP id 9so4086972iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 09:57:50 -0800 (PST)
From: "Nathaniel J. Smith" <njs@pobox.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com, "Nathaniel J. Smith" <njs@pobox.com>
Subject: [PATCH 5/5] iwlwifi: make current tx queue sizes visible in debugfs
Date: Sun, 13 Feb 2011 09:56:43 -0800
Message-Id: <1297619803-2832-7-git-send-email-njs@pobox.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Nathaniel J. Smith <njs@pobox.com>
---
 drivers/net/wireless/iwlwifi/iwl-debugfs.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debugfs.c b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
index bc7a965..31c58fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debugfs.c
@@ -980,7 +980,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	int pos = 0;
 	int cnt;
 	int ret;
-	const size_t bufsz = sizeof(char) * 64 *
+	const size_t bufsz = sizeof(char) * 128 *
 				priv->cfg->base_params->num_of_queues;
 
 	if (!priv->txq) {
@@ -995,9 +995,11 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 		txq = &priv->txq[cnt];
 		q = &txq->q;
 		pos += scnprintf(buf + pos, bufsz - pos,
-				"hwq %.2d: read=%u write=%u stop=%d"
+				"hwq %.2d: read=%u write=%u"
+				" high_mark=%u stop=%d"
 				" swq_id=%#.2x (ac %d/hwq %d)\n",
 				cnt, q->read_ptr, q->write_ptr,
+				atomic_read(&q->high_mark),
 				!!test_bit(cnt, priv->queue_stopped),
 				txq->swq_id, txq->swq_id & 3,
 				(txq->swq_id >> 2) & 0x1f);
-- 
1.7.1

