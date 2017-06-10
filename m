Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60220 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751999AbdFJKw5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Jun 2017 06:52:57 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 10 Jun 2017 13:52:46 +0300
Message-Id: <20170610105246.26455-5-luca@coelho.fi> (sfid-20170610_125401_690810_6C93809D)
In-Reply-To: <20170610105246.26455-1-luca@coelho.fi>
References: <20170610105246.26455-1-luca@coelho.fi>
Subject: [PATCH 4/4] mac80211: add the action to the drv_ampdu_action tracepoint
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

It is very useful to know what ampdu action is currently
happening. Add this information to the tracepoint.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/mac80211/trace.h | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 0d645bc148d0..3d9ac17af407 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -92,16 +92,19 @@
 				__field(u16, ssn)					\
 				__field(u8, buf_size)					\
 				__field(bool, amsdu)					\
-				__field(u16, timeout)
+				__field(u16, timeout)					\
+				__field(u16, action)
 #define AMPDU_ACTION_ASSIGN	STA_NAMED_ASSIGN(params->sta);				\
 				__entry->tid = params->tid;				\
 				__entry->ssn = params->ssn;				\
 				__entry->buf_size = params->buf_size;			\
 				__entry->amsdu = params->amsdu;				\
-				__entry->timeout = params->timeout;
-#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, timeout %d"
+				__entry->timeout = params->timeout;			\
+				__entry->action = params->action;
+#define AMPDU_ACTION_PR_FMT	STA_PR_FMT " tid %d, ssn %d, buf_size %u, amsdu %d, timeout %d action %d"
 #define AMPDU_ACTION_PR_ARG	STA_PR_ARG, __entry->tid, __entry->ssn,			\
-				__entry->buf_size, __entry->amsdu, __entry->timeout
+				__entry->buf_size, __entry->amsdu, __entry->timeout,	\
+				__entry->action
 
 /*
  * Tracing for driver callbacks.
-- 
2.11.0
