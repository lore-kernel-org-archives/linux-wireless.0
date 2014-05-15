Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:64339 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbaEORFO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 May 2014 13:05:14 -0400
Received: by mail-we0-f173.google.com with SMTP id u57so1393977wes.32
        for <linux-wireless@vger.kernel.org>; Thu, 15 May 2014 10:05:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 13/24] iwlwifi: use dev_printk instead of dev_dbg for debug logs
Date: Thu, 15 May 2014 20:04:30 +0300
Message-Id: <1400173481-9047-13-git-send-email-egrumbach@gmail.com> (sfid-20140515_190527_596832_3A255C78)
In-Reply-To: <5374F373.6040902@gmail.com>
References: <5374F373.6040902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

When calling IWL_DEBUG_*() dev_dbg() is currently used, and this
could result in the log being ignored no matter the internal
loglevel, since dev_dbg() may get turned on or off based on the
dynamic debug mechanism.

Replace the dev_dbg() with dev_printk() since dynamic printing
is pointless as we use our own debug level mechanism and there
is just a single dev_dbg() call in the code.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
[rephrase commit message a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-debug.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.c b/drivers/net/wireless/iwlwifi/iwl-debug.c
index 8a44f59..09feff4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.c
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.c
@@ -61,8 +61,6 @@
  *
  *****************************************************************************/
 
-#define DEBUG
-
 #include <linux/device.h>
 #include <linux/interrupt.h>
 #include <linux/export.h>
@@ -128,8 +126,8 @@ void __iwl_dbg(struct device *dev,
 #ifdef CONFIG_IWLWIFI_DEBUG
 	if (iwl_have_debug_level(level) &&
 	    (!limit || net_ratelimit()))
-		dev_dbg(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
-			function, &vaf);
+		dev_printk(KERN_DEBUG, dev, "%c %s %pV",
+			   in_interrupt() ? 'I' : 'U', function, &vaf);
 #endif
 	trace_iwlwifi_dbg(level, in_interrupt(), function, &vaf);
 	va_end(args);
-- 
1.8.3.2

