Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49538 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750714AbcJSEr6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Oct 2016 00:47:58 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 19 Oct 2016 07:47:47 +0300
Message-Id: <20161019044747.15921-1-luca@coelho.fi> (sfid-20161019_064807_169701_6E50040E)
Subject: [PATCH] cfg80211: allow vendor commands to be sent to nan interface
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Allow vendor commands that require WIPHY_VENDOR_CMD_NEED_RUNNING flag, to
be sent to NAN interface.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e48b9c3..fcf5b4f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -11258,7 +11258,8 @@ static int nl80211_vendor_cmd(struct sk_buff *skb, struct genl_info *info)
 				if (wdev->netdev &&
 				    !netif_running(wdev->netdev))
 					return -ENETDOWN;
-				if (!wdev->netdev && !wdev->p2p_started)
+				if (!wdev->netdev && !wdev->p2p_started &&
+				    !wdev->nan_started)
 					return -ENETDOWN;
 			}
 
-- 
2.9.3
