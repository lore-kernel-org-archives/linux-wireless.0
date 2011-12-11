Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39200 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab1LKXir (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Dec 2011 18:38:47 -0500
Received: by pbbb2 with SMTP id b2so663801pbb.19
        for <linux-wireless@vger.kernel.org>; Sun, 11 Dec 2011 15:38:47 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 12 Dec 2011 00:38:46 +0100
Message-ID: <CAMG6FYgLHP2WmcuMFh6fzih-NKO8Brvpbeeb2uunZQydYYmNLw@mail.gmail.com> (sfid-20111212_003850_667575_028C8B2F)
Subject: [RFC] mac80211: Prevent possible BUG on suspend.
From: Dmitry Tarnyagin <abi.dmitryt@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PM code has a watchdog to trigger a BUG when suspend callback
is not returning in several seconds. Some WLAN hardware has
longer timeouts for non-interruptible configuration-related
operations, leading to the watchdog timeout while
ieee80211_scan_cancel is waiting on a mutex.

The patch checks if interface mutex is already held and rejects
suspend if there is a possibility of locking.
---
 net/mac80211/pm.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index 9ee7164..468d2e5 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -37,6 +37,25 @@ int __ieee80211_suspend(struct ieee80211_hw *hw,
struct cfg80211_wowlan *wowlan)
 	if (!local->open_count)
 		goto suspend;

+	/* PM code has a watchdog to trigger a BUG when
+	 * suspend callback is not returning in several seconds.
+	 * Some WLAN hardware has longer timeouts for non-interruptible
+	 * configuration-related operations, leading to the watchdog
+	 * timeout while ieee80211_scan_cancel is waiting on the mutex.
+	 *
+	 * The code below checks if interface mutex is already held
+	 * and rejects suspend if there is a possibility of locking.
+	 *
+	 * It's a bit racy, but handles most of cases.
+	 */
+	if (mutex_trylock(&local->mtx))
+		mutex_unlock(&local->mtx);
+	else {
+		wiphy_warn(hw->wiphy, "Suspend when operation "
+			"is in progress. Suspend aborted.\n");
+		return -EBUSY;
+	}
+
 	ieee80211_scan_cancel(local);

 	if (hw->flags & IEEE80211_HW_AMPDU_AGGREGATION) {
-- 
1.7.1
