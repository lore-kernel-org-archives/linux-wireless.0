Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:15909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab1KRIXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:25 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 75/77] iwlegacy: 4965-rs: don't return rate from il4965_rs_update_rate_tbl
Date: Fri, 18 Nov 2011 09:22:37 +0100
Message-Id: <1321604559-10707-75-git-send-email-sgruszka@redhat.com> (sfid-20111118_092341_360106_BE669DC0)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

1) don't return rate from il4965_rs_update_rate_tbl
2) fix up il4965_rs_rate_scale_perform

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |   12 +++---------
 1 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 5200637..162c778 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -1731,9 +1731,8 @@ il4965_rs_stay_in_table(struct il_lq_sta *lq_sta, bool force_search)
 
 /*
  * setup rate table in uCode
- * return rate_n_flags as used in the table
  */
-static u32
+static void
 il4965_rs_update_rate_tbl(struct il_priv *il, struct il_rxon_context *ctx,
 			  struct il_lq_sta *lq_sta,
 			  struct il_scale_tbl_info *tbl, int idx, u8 is_green)
@@ -1744,8 +1743,6 @@ il4965_rs_update_rate_tbl(struct il_priv *il, struct il_rxon_context *ctx,
 	rate = il4965_rate_n_flags_from_tbl(il, tbl, idx, is_green);
 	il4965_rs_fill_link_cmd(il, lq_sta, rate);
 	il_send_lq_cmd(il, ctx, &lq_sta->lq, CMD_ASYNC, false);
-
-	return rate;
 }
 
 /*
@@ -1774,7 +1771,6 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 	u8 update_lq = 0;
 	struct il_scale_tbl_info *tbl, *tbl1;
 	u16 rate_scale_idx_msk = 0;
-	u32 rate;
 	u8 is_green = 0;
 	u8 active_tbl = 0;
 	u8 done_search = 0;
@@ -1858,8 +1854,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 			tbl = &(lq_sta->lq_info[lq_sta->active_tbl]);
 			/* get "active" rate info */
 			idx = il4965_hwrate_to_plcp_idx(tbl->current_rate);
-			rate =
-			    il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
+			il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
 						      is_green);
 		}
 		return;
@@ -2062,8 +2057,7 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 lq_update:
 	/* Replace uCode's rate table for the destination station. */
 	if (update_lq)
-		rate =
-		    il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
+		il4965_rs_update_rate_tbl(il, ctx, lq_sta, tbl, idx,
 					      is_green);
 
 	/* Should we stay with this modulation mode,
-- 
1.7.1

