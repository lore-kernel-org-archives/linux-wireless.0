Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45289 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab2K1VPg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 16:15:36 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: don't BUG_ON BSS struct issues
Date: Wed, 28 Nov 2012 22:16:00 +0100
Message-Id: <1354137360-22334-1-git-send-email-johannes@sipsolutions.net> (sfid-20121128_221539_615597_A4C1D366)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There's no need to stop the machine, just leak
the BSS entry if there's an issue with its hold
counter when freeing.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 9596015..5af431f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -26,6 +26,10 @@ static void bss_release(struct kref *ref)
 	struct cfg80211_internal_bss *bss;
 
 	bss = container_of(ref, struct cfg80211_internal_bss, ref);
+
+	if (WARN_ON(atomic_read(&bss->hold)))
+		return;
+
 	if (bss->pub.free_priv)
 		bss->pub.free_priv(&bss->pub);
 
@@ -34,8 +38,6 @@ static void bss_release(struct kref *ref)
 	if (bss->proberesp_ies_allocated)
 		kfree(bss->pub.proberesp_ies);
 
-	BUG_ON(atomic_read(&bss->hold));
-
 	kfree(bss);
 }
 
-- 
1.8.0

