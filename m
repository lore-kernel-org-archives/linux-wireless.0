Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab1KRIXW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:22 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 73/77] iwlegacy: 4965-rs: remove unnecessary null check for sta and lq_sta
Date: Fri, 18 Nov 2011 09:22:35 +0100
Message-Id: <1321604559-10707-73-git-send-email-sgruszka@redhat.com> (sfid-20111118_092339_608727_B98C4441)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

both sta and lq_sta are guaranteed to be not null in the calling
function so we don't need to check them here.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index b0946a1..2ec808e 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -1793,9 +1793,6 @@ il4965_rs_rate_scale_perform(struct il_priv *il, struct sk_buff *skb,
 	    (info->flags & IEEE80211_TX_CTL_NO_ACK))
 		return;
 
-	if (!sta || !lq_sta)
-		return;
-
 	lq_sta->supp_rates = sta->supp_rates[lq_sta->band];
 
 	tid = il4965_rs_tl_add_packet(lq_sta, hdr);
-- 
1.7.1

