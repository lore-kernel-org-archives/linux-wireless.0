Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751845Ab1ITOrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 10:47:11 -0400
Date: Tue, 20 Sep 2011 16:46:36 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH] iwlegacy: fix command queue timeout
Message-ID: <20110920144634.GA5358@redhat.com> (sfid-20110920_164719_654645_9610FB7E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwlegacy version of fix:

commit 282cdb325aea4ebbc42ce753b47cc96145eb54bc
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Mon Sep 12 12:09:10 2011 -0700

    iwlagn: fix command queue timeout

    If the command queue is constantly busy,
    which can happen in P2P, the hangcheck
    timer will frequently find a command in
    it and will eventually reset the device
    because nothing sets the timestamp for
    this queue when commands are processed.

    Fix this by setting the timestamp when
    a command completes.

iwlegacy does not support P2P, but this patch fix possible
unneeded hardware resets, hence is needed.

Cc: stable@kernel.org  # 2.6.39+
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-tx.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 4fff995..4b4489f 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -625,6 +625,8 @@ iwl_legacy_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
+	txq->time_stamp = jiffies;
+
 	pci_unmap_single(priv->pci_dev,
 			 dma_unmap_addr(meta, mapping),
 			 dma_unmap_len(meta, len),
-- 
1.7.1

