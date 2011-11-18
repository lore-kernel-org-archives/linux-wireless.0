Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757121Ab1KRIXY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 74/77] iwlegacy: 4965-rs: il4965_rs_alloc_sta: remove lq_sta local var
Date: Fri, 18 Nov 2011 09:22:36 +0100
Message-Id: <1321604559-10707-74-git-send-email-sgruszka@redhat.com> (sfid-20111118_092340_809334_D7641F0F)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

remove the lq_sta local variable and return the
result directly in il4965_rs_alloc_sta

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-rs.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 2ec808e..5200637 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -2295,7 +2295,6 @@ il4965_rs_get_rate(void *il_r, struct ieee80211_sta *sta, void *il_sta,
 static void *
 il4965_rs_alloc_sta(void *il_rate, struct ieee80211_sta *sta, gfp_t gfp)
 {
-	struct il_lq_sta *lq_sta;
 	struct il_station_priv *sta_priv =
 	    (struct il_station_priv *)sta->drv_priv;
 	struct il_priv *il;
@@ -2303,9 +2302,7 @@ il4965_rs_alloc_sta(void *il_rate, struct ieee80211_sta *sta, gfp_t gfp)
 	il = (struct il_priv *)il_rate;
 	D_RATE("create station rate scale win\n");
 
-	lq_sta = &sta_priv->lq_sta;
-
-	return lq_sta;
+	return &sta_priv->lq_sta;
 }
 
 /*
-- 
1.7.1

