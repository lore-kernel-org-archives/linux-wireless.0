Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38481 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab3BOTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 14:16:04 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] mac80211: Fix incorrect use of STA_PR_FMT in trace points
Date: Fri, 15 Feb 2013 13:15:48 -0600
Message-Id: <1360955748-26608-1-git-send-email-seth.forshee@canonical.com> (sfid-20130215_201608_039156_EDBF3D4E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Several tracepoints are using STA_PR_FMT where STA_PR_ARG should be
used, resulting in messages like "phy0 sta:ARG TYPE NOT FIELD BUT 1".
Change these to STA_PR_ARG.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 net/mac80211/trace.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0bdd7ae..d873421 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -479,7 +479,7 @@ TRACE_EVENT(drv_set_tim,
 
 	TP_printk(
 		LOCAL_PR_FMT STA_PR_FMT " set:%d",
-		LOCAL_PR_ARG, STA_PR_FMT, __entry->set
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->set
 	)
 );
 
@@ -1684,7 +1684,7 @@ TRACE_EVENT(api_sta_block_awake,
 
 	TP_printk(
 		LOCAL_PR_FMT STA_PR_FMT " block:%d",
-		LOCAL_PR_ARG, STA_PR_FMT, __entry->block
+		LOCAL_PR_ARG, STA_PR_ARG, __entry->block
 	)
 );
 
@@ -1782,7 +1782,7 @@ TRACE_EVENT(api_eosp,
 
 	TP_printk(
 		LOCAL_PR_FMT STA_PR_FMT,
-		LOCAL_PR_ARG, STA_PR_FMT
+		LOCAL_PR_ARG, STA_PR_ARG
 	)
 );
 
-- 
1.7.9.5

