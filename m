Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37813 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756939Ab0HFOAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 10:00:52 -0400
Subject: [PATCH 2.6.36] iwlwifi: fix TX tracer
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	"Zhao, Shanyu" <shanyu.zhao@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Aug 2010 16:00:48 +0200
Message-ID: <1281103248.3853.483.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The TX tracing code copies with the wrong length,
which will typically copy too little data. Fix
this by using the correct length variable.

Cc: stable@kernel.org [2.6.32+]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2010-08-06 15:58:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-devtrace.h	2010-08-06 15:58:20.000000000 +0200
@@ -193,7 +193,7 @@ TRACE_EVENT(iwlwifi_dev_tx,
 		__entry->framelen = buf0_len + buf1_len;
 		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
 		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
-		memcpy(__get_dynamic_array(buf1), buf1, buf0_len);
+		memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
 	),
 	TP_printk("[%p] TX %.2x (%zu bytes)",
 		  __entry->priv,


