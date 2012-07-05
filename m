Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45657 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754949Ab2GEIZF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 04:25:05 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7/9] iwlwifi: fix debug message level
Date: Thu,  5 Jul 2012 10:24:53 +0200
Message-Id: <1341476695-6889-8-git-send-email-johannes@sipsolutions.net> (sfid-20120705_102533_232626_797137BC)
In-Reply-To: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
References: <1341476695-6889-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Debug messages should be printed using dev_dbg() not
dev_err() which requires DEBUG to be defined.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
index 0f8fcd1..87535a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -61,6 +61,9 @@
  *
  *****************************************************************************/
 
+#define DEBUG
+
+#include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/export.h>
 #include "iwl-debug.h"
@@ -124,7 +127,7 @@ void __iwl_dbg(struct device *dev,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_have_debug_level(level) &&
 	    (!limit || net_ratelimit()))
-		dev_err(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
+		dev_dbg(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
 			function, &vaf);
 #endif
 	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
-- 
1.7.10

