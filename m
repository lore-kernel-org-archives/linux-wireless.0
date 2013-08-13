Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:64590 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754342Ab3HMFzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Aug 2013 01:55:06 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 4/4] ath10k: print errcode when CE ring setup fails
Date: Tue, 13 Aug 2013 07:54:57 +0200
Message-ID: <1376373297-32369-5-git-send-email-michal.kazior@tieto.com> (sfid-20130813_075518_676388_594461ED)
In-Reply-To: <1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
References: <1375949650-9699-1-git-send-email-michal.kazior@tieto.com>
 <1376373297-32369-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes it possible to see the reason why the
setup fails. It also adheres to code style of
error checking in ath drivers.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/ce.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ce.c b/drivers/net/wireless/ath/ath10k/ce.c
index f8b969f..50d2ea2 100644
--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -1128,6 +1128,7 @@ struct ce_state *ath10k_ce_init(struct ath10k *ar,
 {
 	struct ce_state *ce_state;
 	u32 ctrl_addr = ath10k_ce_base_address(ce_id);
+	int ret;
 
 	ce_state = ath10k_ce_init_state(ar, ce_id, attr);
 	if (!ce_state) {
@@ -1136,18 +1137,20 @@ struct ce_state *ath10k_ce_init(struct ath10k *ar,
 	}
 
 	if (attr->src_nentries) {
-		if (ath10k_ce_init_src_ring(ar, ce_id, ce_state, attr)) {
-			ath10k_err("Failed to initialize CE src ring for ID: %d\n",
-				   ce_id);
+		ret = ath10k_ce_init_src_ring(ar, ce_id, ce_state, attr);
+		if (ret) {
+			ath10k_err("Failed to initialize CE src ring for ID: %d (%d)\n",
+				   ce_id, ret);
 			ath10k_ce_deinit(ce_state);
 			return NULL;
 		}
 	}
 
 	if (attr->dest_nentries) {
-		if (ath10k_ce_init_dest_ring(ar, ce_id, ce_state, attr)) {
-			ath10k_err("Failed to initialize CE dest ring for ID: %d\n",
-				   ce_id);
+		ret = ath10k_ce_init_dest_ring(ar, ce_id, ce_state, attr);
+		if (ret) {
+			ath10k_err("Failed to initialize CE dest ring for ID: %d (%d)\n",
+				   ce_id, ret);
 			ath10k_ce_deinit(ce_state);
 			return NULL;
 		}
-- 
1.7.9.5

