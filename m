Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50621 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab2L0Tcf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 14:32:35 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: split out chandef tracing macros
Date: Thu, 27 Dec 2012 20:32:57 +0100
Message-Id: <1356636777-16051-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_203238_991567_1922812C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Some new APIs will require tracing a chandef without
it being part of a channel context, so separate out
the tracing macros for that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/trace.h | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index a8270b4..41861b9 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -28,21 +28,27 @@
 #define VIF_PR_FMT	" vif:%s(%d%s)"
 #define VIF_PR_ARG	__get_str(vif_name), __entry->vif_type, __entry->p2p ? "/p2p" : ""
 
-#define CHANCTX_ENTRY	__field(u32, control_freq)				\
+#define CHANDEF_ENTRY	__field(u32, control_freq)				\
 			__field(u32, chan_width)				\
 			__field(u32, center_freq1)				\
-			__field(u32, center_freq2)				\
+			__field(u32, center_freq2)
+#define CHANDEF_ASSIGN(c)							\
+			__entry->control_freq = (c)->chan->center_freq;		\
+			__entry->chan_width = (c)->width;			\
+			__entry->center_freq1 = (c)->center_freq1;		\
+			__entry->center_freq1 = (c)->center_freq2;
+#define CHANDEF_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz"
+#define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,		\
+			__entry->center_freq1, __entry->center_freq2
+
+#define CHANCTX_ENTRY	CHANDEF_ENTRY						\
 			__field(u8, rx_chains_static)				\
 			__field(u8, rx_chains_dynamic)
-#define CHANCTX_ASSIGN	__entry->control_freq = ctx->conf.def.chan->center_freq;\
-			__entry->chan_width = ctx->conf.def.width;		\
-			__entry->center_freq1 = ctx->conf.def.center_freq1;	\
-			__entry->center_freq2 = ctx->conf.def.center_freq2;	\
+#define CHANCTX_ASSIGN	CHANDEF_ASSIGN(&ctx->conf.def)				\
 			__entry->rx_chains_static = ctx->conf.rx_chains_static;	\
 			__entry->rx_chains_dynamic = ctx->conf.rx_chains_dynamic
-#define CHANCTX_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz chains:%d/%d"
-#define CHANCTX_PR_ARG	__entry->control_freq, __entry->chan_width,		\
-			__entry->center_freq1, __entry->center_freq2,		\
+#define CHANCTX_PR_FMT	CHANDEF_PR_FMT " chains:%d/%d"
+#define CHANCTX_PR_ARG	CHANDEF_PR_ARG,						\
 			__entry->rx_chains_static, __entry->rx_chains_dynamic
 
 
-- 
1.8.0

