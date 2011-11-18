Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757013Ab1KRIXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:14 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 69/77] iwlegacy: change IL_ERR to D_HT in iwl4965_rs_tl_turn_on_agg_for_tid
Date: Fri, 18 Nov 2011 09:22:31 +0100
Message-Id: <1321604559-10707-69-git-send-email-sgruszka@redhat.com> (sfid-20111118_092351_763941_02E4200A)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

This message should be a debug message and not an error.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 4bc5a18..93c3a4d 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -371,10 +371,10 @@ il4965_rs_tl_turn_on_agg_for_tid(struct il_priv *il, struct il_lq_sta *lq_data,
 			IL_ERR("Fail start Tx agg on tid: %d\n", tid);
 			ieee80211_stop_tx_ba_session(sta, tid);
 		}
-	} else {
-		IL_ERR("Aggregation not enabled for tid %d "
-		       "because load = %u\n", tid, load);
-	}
+	} else
+		D_HT("Aggregation not enabled for tid %d because load = %u\n",
+		     tid, load);
+
 	return ret;
 }
 
-- 
1.7.1

