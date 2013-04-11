Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35748 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab3DKOWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Apr 2013 10:22:14 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@lists.ath5k.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] ath5k: use more idiomatic tracing include style
Date: Thu, 11 Apr 2013 16:22:08 +0200
Message-Id: <1365690128-25084-1-git-send-email-johannes@sipsolutions.net> (sfid-20130411_162218_107597_C8ECD596)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Pretty much everywhere that uses a trace definition
header that's not in include/trace/events/ uses the
make system for the include path rather than putting
it into the sources, so do that in ath5k as well.

This came up during backporting work (where this is
required), but since all other drivers do it this
way upstream it seemed applicable.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath5k/Makefile | 1 +
 drivers/net/wireless/ath/ath5k/trace.h  | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index f60b389..1b3a34f 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -10,6 +10,7 @@ ath5k-y				+= phy.o
 ath5k-y				+= reset.o
 ath5k-y				+= attach.o
 ath5k-y				+= base.o
+CFLAGS_base.o			+= -I$(src)
 ath5k-y				+= led.o
 ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
diff --git a/drivers/net/wireless/ath/ath5k/trace.h b/drivers/net/wireless/ath/ath5k/trace.h
index 00f0158..c6eef51 100644
--- a/drivers/net/wireless/ath/ath5k/trace.h
+++ b/drivers/net/wireless/ath/ath5k/trace.h
@@ -97,7 +97,7 @@ TRACE_EVENT(ath5k_tx_complete,
 #if defined(CONFIG_ATH5K_TRACER) && !defined(__CHECKER__)
 
 #undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH ../../drivers/net/wireless/ath/ath5k
+#define TRACE_INCLUDE_PATH .
 #undef TRACE_INCLUDE_FILE
 #define TRACE_INCLUDE_FILE trace
 
-- 
1.8.0

