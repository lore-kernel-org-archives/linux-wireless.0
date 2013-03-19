Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39984 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933710Ab3CST3H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 15:29:07 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.9] cfg80211: fix wdev tracing crash
Date: Tue, 19 Mar 2013 20:28:31 +0100
Message-Id: <1363721311-29180-1-git-send-email-johannes@sipsolutions.net> (sfid-20130319_203000_748917_05866763)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Arend reported a crash in tracing if the driver returns an
ERR_PTR() value from the add_virtual_intf() callback. This
is due to the tracing then still attempting to dereference
the "pointer", fix this by using IS_ERR_OR_NULL().

Reported-by: Arend van Spriel <arend@broadcom.com>
Tested-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/trace.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index 6847d04..7586de7 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -27,7 +27,8 @@
 #define WIPHY_PR_ARG	__entry->wiphy_name
 
 #define WDEV_ENTRY	__field(u32, id)
-#define WDEV_ASSIGN	(__entry->id) = (wdev ? wdev->identifier : 0)
+#define WDEV_ASSIGN	(__entry->id) = (!IS_ERR_OR_NULL(wdev)	\
+					 ? wdev->identifier : 0)
 #define WDEV_PR_FMT	"wdev(%u)"
 #define WDEV_PR_ARG	(__entry->id)
 
-- 
1.8.0

