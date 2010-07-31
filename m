Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15724 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756553Ab0GaQyt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jul 2010 12:54:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/8] iwlwifi: fix compile warning
Date: Sat, 31 Jul 2010 08:34:09 -0700
Message-Id: <1280590452-10655-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1280590452-10655-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When iwlwifi is compiled w/o debug, we get
this warning:
iwl-agn.c: In function ‘iwlagn_load_firmware’:
iwl-agn.c:2014: warning: passing argument 3 of ‘iwl_print_hex_dump’ discards qualifiers from pointer target type
iwl-debug.h:73: note: expected ‘void *’ but argument is of type ‘const u8 *’

because the const qualifier is missing in the
inline stub. Fix this.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index 5c2bcef..0b961a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -71,7 +71,7 @@ do {                                            			\
 #define IWL_DEBUG(__priv, level, fmt, args...)
 #define IWL_DEBUG_LIMIT(__priv, level, fmt, args...)
 static inline void iwl_print_hex_dump(struct iwl_priv *priv, int level,
-				      void *p, u32 len)
+				      const void *p, u32 len)
 {}
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
-- 
1.7.0.4

