Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51871 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712AbaEIMgA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 08:36:00 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eliad Peller <eliad@wizery.com>
Subject: [PATCH] mac80211: fix vif name tracing
Date: Fri,  9 May 2014 14:35:50 +0200
Message-Id: <1399638950-14932-1-git-send-email-johannes@sipsolutions.net> (sfid-20140509_143604_429218_22253CD4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

If sdata doesn't have a valid dev (e.g. in case of monitor
vif), the vif_name field was initialized with (a length of)
some short string, but later was set to a different,
potentially larger one.

This resulted in out-of-bounds write, which usually
appeared as garbage in the trace log.

Simply trace sdata->name, as it should always have the
correct name for both cases.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a0b0aea76525..cec5b60487a4 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -21,10 +21,10 @@
 
 #define VIF_ENTRY	__field(enum nl80211_iftype, vif_type) __field(void *, sdata)	\
 			__field(bool, p2p)						\
-			__string(vif_name, sdata->dev ? sdata->dev->name : "<nodev>")
+			__string(vif_name, sdata->name)
 #define VIF_ASSIGN	__entry->vif_type = sdata->vif.type; __entry->sdata = sdata;	\
 			__entry->p2p = sdata->vif.p2p;					\
-			__assign_str(vif_name, sdata->dev ? sdata->dev->name : sdata->name)
+			__assign_str(vif_name, sdata->name)
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
-- 
2.0.0.rc0

