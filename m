Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49810 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758954Ab0JFUpJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 16:45:09 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, johannes@sipsolutions.net,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: avoid uninitialized var warning in ieee80211_scan_cancel
Date: Wed,  6 Oct 2010 16:42:23 -0400
Message-Id: <1286397743-21687-1-git-send-email-linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/scan.c: In function ‘ieee80211_scan_cancel’:
net/mac80211/scan.c:794: warning: ‘finish’ may be used uninitialized in this function

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/scan.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 80e017d..523db93 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -791,7 +791,8 @@ int ieee80211_request_internal_scan(struct ieee80211_sub_if_data *sdata,
  */
 void ieee80211_scan_cancel(struct ieee80211_local *local)
 {
-	bool abortscan, finish;
+	bool abortscan;
+	bool finish = false;
 
 	/*
 	 * We are only canceling software scan, or deferred scan that was not
@@ -818,7 +819,7 @@ void ieee80211_scan_cancel(struct ieee80211_local *local)
 	if (abortscan) {
 		/* The scan is canceled, but stop work from being pending */
 		cancel_delayed_work_sync(&local->scan_work);
-		if (finish)
-			__ieee80211_scan_completed_finish(&local->hw, false);
 	}
+	if (finish)
+		__ieee80211_scan_completed_finish(&local->hw, false);
 }
-- 
1.7.2.3

