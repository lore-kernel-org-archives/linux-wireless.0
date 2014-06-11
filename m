Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60947 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589AbaFKOSi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 10:18:38 -0400
Received: by mail-wi0-f176.google.com with SMTP id n3so5573272wiv.3
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2014 07:18:36 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 02/10] mac80211: set auth flags after other station info
Date: Wed, 11 Jun 2014 17:18:19 +0300
Message-Id: <1402496307-32522-2-git-send-email-arik@wizery.com> (sfid-20140611_161841_401319_C9E8448D)
In-Reply-To: <1402496307-32522-1-git-send-email-arik@wizery.com>
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For TDLS, the AUTHORIZED flag arrives with all other important station
info (supported rates, HT/VHT caps, ...). Make sure to set the station
state in the low-level driver after transferring this information to
the mac80211 STA entry.
This aligns the STA information during sta_state callbacks with the
non-TDLS case.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/cfg.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index af3eac4..6c67073 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1020,9 +1020,12 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 		}
 	}
 
-	ret = sta_apply_auth_flags(local, sta, mask, set);
-	if (ret)
-		return ret;
+	/* auth flags will be set later for TDLS stations */
+	if (!test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+		ret = sta_apply_auth_flags(local, sta, mask, set);
+		if (ret)
+			return ret;
+	}
 
 	if (mask & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE)) {
 		if (set & BIT(NL80211_STA_FLAG_SHORT_PREAMBLE))
@@ -1159,6 +1162,13 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 #endif
 	}
 
+	/* set the STA state after all sta info from usermode has been set */
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER)) {
+		ret = sta_apply_auth_flags(local, sta, mask, set);
+		if (ret)
+			return ret;
+	}
+
 	return 0;
 }
 
-- 
1.9.1

