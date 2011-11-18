Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756975Ab1KRIXM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:12 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 68/77] iwlegacy: change IL_WARN to D_HT in il4965_tx_agg_start
Date: Fri, 18 Nov 2011 09:22:30 +0100
Message-Id: <1321604559-10707-68-git-send-email-sgruszka@redhat.com> (sfid-20111118_092319_559275_DA269481)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

This message should be a debug message and not a warning.

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 21a1381..8d2f616 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -2252,7 +2252,7 @@ il4965_tx_agg_start(struct il_priv *il, struct ieee80211_vif *vif,
 	if (unlikely(tx_fifo < 0))
 		return tx_fifo;
 
-	IL_WARN("%s on ra = %pM tid = %d\n", __func__, sta->addr, tid);
+	D_HT("%s on ra = %pM tid = %d\n", __func__, sta->addr, tid);
 
 	sta_id = il_sta_id(sta);
 	if (sta_id == IL_INVALID_STATION) {
-- 
1.7.1

