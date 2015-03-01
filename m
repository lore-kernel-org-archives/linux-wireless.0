Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49636 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751004AbbCAHK3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 02:10:29 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/16] cfg80211: add operating classes 128-130
Date: Sun,  1 Mar 2015 09:10:01 +0200
Message-Id: <1425193815-17785-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081042_129874_EB3D6644)
In-Reply-To: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eliad Peller <eliad@wizery.com>

Operating classes 128-130 are defined in the 11ac
spec for the 5GHz band.

Update ieee80211_operating_class_to_band() to support them.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/util.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6903dbd..f7b3598 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1296,6 +1296,7 @@ bool ieee80211_operating_class_to_band(u8 operating_class,
 	switch (operating_class) {
 	case 112:
 	case 115 ... 127:
+	case 128 ... 130:
 		*band = IEEE80211_BAND_5GHZ;
 		return true;
 	case 81:
-- 
1.9.1

