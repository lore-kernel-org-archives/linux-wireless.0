Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:55978 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750759AbdLKWhu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 17:37:50 -0500
Date: Mon, 11 Dec 2017 15:37:49 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: nl80211: Remove obsolete kerneldoc line
Message-ID: <20171211153749.51d30b4b@lwn.net> (sfid-20171211_233754_242497_70746249)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit ca986ad9bcd3 (nl80211: allow multiple active scheduled scan
requests) removed WIPHY_FLAG_SUPPORTS_SCHED_SCAN but left the kerneldoc
description in place, leading to this docs-build warning:

   ./include/net/cfg80211.h:3278: warning: Excess enum value
           'WIPHY_FLAG_SUPPORTS_SCHED_SCAN' description in 'wiphy_flags'

Remove the line and gain a bit of peace.

Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 include/net/cfg80211.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8b8118a7fadb..cb4d92b79cd9 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3226,7 +3226,6 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_IBSS_RSN: The device supports IBSS RSN.
  * @WIPHY_FLAG_MESH_AUTH: The device supports mesh authentication by routing
  *	auth frames to userspace. See @NL80211_MESH_SETUP_USERSPACE_AUTH.
- * @WIPHY_FLAG_SUPPORTS_SCHED_SCAN: The device supports scheduled scans.
  * @WIPHY_FLAG_SUPPORTS_FW_ROAM: The device supports roaming feature in the
  *	firmware.
  * @WIPHY_FLAG_AP_UAPSD: The device supports uapsd on AP.
-- 
2.14.3
