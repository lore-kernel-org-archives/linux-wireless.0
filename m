Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46494 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726212AbeIDQFy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 12:05:54 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  4 Sep 2018 14:40:53 +0300
Message-Id: <20180904114055.1429-8-luca@coelho.fi> (sfid-20180904_134136_177200_E8E7545A)
In-Reply-To: <20180904114055.1429-1-luca@coelho.fi>
References: <20180831083130.15525-1-luca@coelho.fi>
 <20180904114055.1429-1-luca@coelho.fi>
Subject: [PATCH v2 7/9] cfg80211: reg: Init wiphy_idx in regulatory_hint_core()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Core regulatory hints didn't set wiphy_idx to WIPHY_IDX_INVALID. Since
the regulatory request is zeroed, wiphy_idx was always implicitly set to
0. This resulted in updating only phy #0.
Fix that.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 net/wireless/reg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 043d43573ca2..0eb5e44f8a74 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2932,6 +2932,7 @@ static int regulatory_hint_core(const char *alpha2)
 	request->alpha2[0] = alpha2[0];
 	request->alpha2[1] = alpha2[1];
 	request->initiator = NL80211_REGDOM_SET_BY_CORE;
+	request->wiphy_idx = WIPHY_IDX_INVALID;
 
 	queue_regulatory_request(request);
 
-- 
2.18.0
