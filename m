Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757041Ab1KRIXR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:23:17 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Greg Dietsche <Gregory.Dietsche@cuw.edu>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 71/77] iwlegacy: 4965: remove vif null check in request_scan
Date: Fri, 18 Nov 2011 09:22:33 +0100
Message-Id: <1321604559-10707-71-git-send-email-sgruszka@redhat.com> (sfid-20111118_092354_091703_5E42A53C)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Greg Dietsche <Gregory.Dietsche@cuw.edu>

remove null check on vif in il4965_request_scan

Signed-off-by: Greg Dietsche <Gregory.Dietsche@cuw.edu>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 8d2f616..4aaef41 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -850,8 +850,7 @@ il4965_request_scan(struct il_priv *il, struct ieee80211_vif *vif)
 
 	lockdep_assert_held(&il->mutex);
 
-	if (vif)
-		ctx = il_rxon_ctx_from_vif(vif);
+	ctx = il_rxon_ctx_from_vif(vif);
 
 	if (!il->scan_cmd) {
 		il->scan_cmd =
-- 
1.7.1

