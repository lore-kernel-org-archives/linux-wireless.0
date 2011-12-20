Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18337 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252Ab1LTSsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 13:48:20 -0500
Cc: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 5/6] ath5k: avoid sparse warnings on tracing
Date: Tue, 20 Dec 2011 10:46:10 -0800
Message-ID: <1324406771-7100-6-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20111220_194823_067219_205CF66E)
In-Reply-To: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

Just skip the sparse checks on tracing.

  CHECK   drivers/net/wireless/ath/ath5k/base.c
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:19:1: error: incompatible types for operation (<)
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:19:1:    left side has type struct ath5k_hw *<noident>
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:19:1:    right side has type int
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:37:1: error: incompatible types for operation (<)
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:37:1:    left side has type struct ath5k_hw *<noident>
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:37:1:    right side has type int
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:63:1: error: incompatible types for operation (<)
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:63:1:    left side has type struct ath5k_hw *<noident>
include/trace/../../drivers/net/wireless/ath/ath5k/trace.h:63:1:    right side has type int
/home/mcgrof/wireless-testing/arch/x86/include/asm/jump_label.h:16:9: error: bad asm output
/home/mcgrof/wireless-testing/arch/x86/include/asm/jump_label.h:16:9: error: bad asm output
/home/mcgrof/wireless-testing/arch/x86/include/asm/jump_label.h:16:9: error: bad asm output
/home/mcgrof/wireless-testing/arch/x86/include/asm/jump_label.h:16:9: error: bad asm output
  CC [M]  drivers/net/wireless/ath/ath5k/base.o

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath5k/trace.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/trace.h b/drivers/net/wireless/ath/ath5k/trace.h
index 39f002e..00f0158 100644
--- a/drivers/net/wireless/ath/ath5k/trace.h
+++ b/drivers/net/wireless/ath/ath5k/trace.h
@@ -3,7 +3,8 @@
 
 #include <linux/tracepoint.h>
 
-#ifndef CONFIG_ATH5K_TRACER
+
+#if !defined(CONFIG_ATH5K_TRACER) || defined(__CHECKER__)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
@@ -93,7 +94,7 @@ TRACE_EVENT(ath5k_tx_complete,
 
 #endif /* __TRACE_ATH5K_H */
 
-#ifdef CONFIG_ATH5K_TRACER
+#if defined(CONFIG_ATH5K_TRACER) && !defined(__CHECKER__)
 
 #undef TRACE_INCLUDE_PATH
 #define TRACE_INCLUDE_PATH ../../drivers/net/wireless/ath/ath5k
-- 
1.7.4.15.g7811d

