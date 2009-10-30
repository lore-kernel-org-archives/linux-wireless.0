Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:60196 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932926AbZJ3Vw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 17:52:29 -0400
Received: by fg-out-1718.google.com with SMTP id 16so1769174fgg.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2009 14:52:33 -0700 (PDT)
Subject: [PATCH 1/2] Allow scanning while in authenticated only state
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
In-Reply-To: <1256939391.31271.11.camel@maxim-laptop>
References: <1256939391.31271.11.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 23:52:29 +0200
Message-ID: <1256939549.31271.14.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 1d13f997f652c7e632d4ddb053df3f3fad78da23 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 30 Oct 2009 23:36:20 +0200
Subject: [PATCH 1/2] Allow scanning while in authenticated only state

Since ifmgd->work_list is {ab}used as a storage for authenticated,
but not associated access points (this is done using idle work items),
allow scanning if all work items are in this state.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 net/mac80211/scan.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index c46ac01..c932765 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -418,6 +418,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct ieee80211_mgd_work *wk, *tmp;
 	int rc;
 
 	if (local->scan_req)
@@ -450,9 +451,14 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
 	if (req != local->int_scan_req &&
 	    sdata->vif.type == NL80211_IFTYPE_STATION &&
 	    !list_empty(&ifmgd->work_list)) {
-		/* actually wait for the work it's doing to finish/time out */
-		set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
-		return 0;
+
+		/* actually wait for the work it's doing to finish/time out*/
+		list_for_each_entry_safe(wk, tmp, &ifmgd->work_list, list) {
+			if (wk->state != IEEE80211_MGD_STATE_IDLE) {
+				set_bit(IEEE80211_STA_REQ_SCAN, &ifmgd->request);
+				return 0;
+			}
+		}
 	}
 
 	if (local->ops->hw_scan)
-- 
1.6.3.3


