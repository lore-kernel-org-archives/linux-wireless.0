Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41501 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab1IIMTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 08:19:18 -0400
Subject: [FYI] iwlagn: fix command queue timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
In-Reply-To: <1315570496.17050.7.camel@jlt3.sipsolutions.net> (sfid-20110909_141507_339473_273626F4)
References: <1315570496.17050.7.camel@jlt3.sipsolutions.net>
	 (sfid-20110909_141507_339473_273626F4)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 14:19:15 +0200
Message-ID: <1315570755.17050.9.camel@jlt3.sipsolutions.net> (sfid-20110909_141921_054876_98578A48)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

And here's another one -- I think iwlegacy has the same bug which
probably means I can answer my question below with yes, it definitely
does need to go to stable ...



From: Johannes Berg <johannes.berg@intel.com>

If the command queue is constantly busy,
which can happen in P2P, the hangcheck
timer will frequently find a command in
it and will eventually reset the device
because nothing sets the timestamp for
this queue when commands are processed.

Fix this by setting the timestamp when
a command completes.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
It's possible this needs to go to stable?

 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c	2011-09-09 13:55:03.000000000 +0200
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c	2011-09-09 13:55:26.000000000 +0200
@@ -928,6 +928,8 @@ void iwl_tx_cmd_complete(struct iwl_tran
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
+	txq->time_stamp = jiffies;
+
 	iwlagn_unmap_tfd(trans, meta, &txq->tfds[index],
 			 DMA_BIDIRECTIONAL);
 


