Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:12646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbbJYJAL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Oct 2015 05:00:11 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Arik Nemtsov <arik@wizery.com>,
	Arik Nemtsov <arikx.nemtsov@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/10] mac80211: allow null chandef in tracing
Date: Sun, 25 Oct 2015 10:59:41 +0200
Message-Id: <1445763582-11421-9-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151025_100021_185539_8CAEF005)
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

In TDLS channel-switch operations the chandef can sometimes be NULL.
Avoid an oops in the trace code for these cases and just print a
chandef full of zeros.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/trace.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 5cf8f4e..56c6d6c 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -33,11 +33,11 @@
 			__field(u32, chan_width)					\
 			__field(u32, center_freq1)					\
 			__field(u32, center_freq2)
-#define CHANDEF_ASSIGN(c)								\
-			__entry->control_freq = (c)->chan ? (c)->chan->center_freq : 0;	\
-			__entry->chan_width = (c)->width;				\
-			__entry->center_freq1 = (c)->center_freq1;			\
-			__entry->center_freq2 = (c)->center_freq2;
+#define CHANDEF_ASSIGN(c)							\
+			__entry->control_freq = (c) ? ((c)->chan ? (c)->chan->center_freq : 0) : 0;	\
+			__entry->chan_width = (c) ? (c)->width : 0;			\
+			__entry->center_freq1 = (c) ? (c)->center_freq1 : 0;		\
+			__entry->center_freq2 = (c) ? (c)->center_freq2 : 0;
 #define CHANDEF_PR_FMT	" control:%d MHz width:%d center: %d/%d MHz"
 #define CHANDEF_PR_ARG	__entry->control_freq, __entry->chan_width,			\
 			__entry->center_freq1, __entry->center_freq2
-- 
2.1.4

