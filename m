Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50920 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1758129AbdLRKOM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 05:14:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 18 Dec 2017 12:14:05 +0200
Message-Id: <20171218101405.9330-3-luca@coelho.fi> (sfid-20171218_111418_970141_5D90F544)
In-Reply-To: <20171218101405.9330-1-luca@coelho.fi>
References: <20171218101405.9330-1-luca@coelho.fi>
Subject: [PATCH 2/2] nl80211: send deauth reason if locally generated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Send disconnection reason code to user space even if it's locally
generated, since some tests that check reason code may fail because of
the current behavior.

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index e4522ad5f770..e4dddfb64ced 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -13963,7 +13963,7 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
-	    (from_ap && reason &&
+	    (reason &&
 	     nla_put_u16(msg, NL80211_ATTR_REASON_CODE, reason)) ||
 	    (from_ap &&
 	     nla_put_flag(msg, NL80211_ATTR_DISCONNECTED_BY_AP)) ||
-- 
2.15.1
