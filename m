Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:57994 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291AbaGQMEX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 08:04:23 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: fix mic_failure tracing
Date: Thu, 17 Jul 2014 15:00:56 +0300
Message-Id: <1405598456-8512-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140717_140442_721197_C7FA43DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

tsc can be NULL (mac80211 currently always passes NULL),
resulting in NULL-dereference. check before copying it.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 5ffb849..0f0901e 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2049,7 +2049,8 @@ TRACE_EVENT(cfg80211_michael_mic_failure,
 		MAC_ASSIGN(addr, addr);
 		__entry->key_type = key_type;
 		__entry->key_id = key_id;
-		memcpy(__entry->tsc, tsc, 6);
+		if (tsc)
+			memcpy(__entry->tsc, tsc, 6);
 	),
 	TP_printk(NETDEV_PR_FMT ", " MAC_PR_FMT ", key type: %d, key id: %d, tsc: %pm",
 		  NETDEV_PR_ARG, MAC_PR_ARG(addr), __entry->key_type,
-- 
1.9.1

