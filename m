Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49408 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932367Ab0JFJVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 05:21:06 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 5/6] mac80211: compete scan to cfg80211 if deferred scan fail to start
Date: Wed,  6 Oct 2010 11:22:12 +0200
Message-Id: <1286356933-4076-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
References: <1286356933-4076-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We nulify local->scan_req on failure in __ieee80211_start_scan, so
__ieee80211_scan_completed will not call cfg80211_scan_done. Fix that.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 net/mac80211/scan.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index bce769a..2c79b83 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -666,6 +666,8 @@ void ieee80211_scan_work(struct work_struct *work)
 
 		rc = __ieee80211_start_scan(sdata, req);
 		if (rc) {
+			/* need to complete scan in cfg80211 */
+			local->scan_req = req;
 			aborted = true;
 			goto out_complete;
 		} else
-- 
1.7.1

