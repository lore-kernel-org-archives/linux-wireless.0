Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60357 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933778AbaGQOOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 10:14:20 -0400
Received: by mail-wg0-f44.google.com with SMTP id m15so2115601wgh.15
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jul 2014 07:14:19 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 11/15] mac80211: set Rx highest rate in ht_cap
Date: Thu, 17 Jul 2014 17:14:27 +0300
Message-Id: <1405606471-30128-12-git-send-email-arik@wizery.com> (sfid-20140717_161451_154882_95511AF9)
In-Reply-To: <1405606471-30128-1-git-send-email-arik@wizery.com>
References: <1405606471-30128-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set for completeness mostly, currently unused in the code.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/mac80211/ht.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index 568055c..ff630be 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -227,6 +227,9 @@ bool ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
 	if (own_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap.mcs.rx_mask[32/8] |= 1;
 
+	/* set Rx highest rate */
+	ht_cap.mcs.rx_highest = ht_cap_ie->mcs.rx_highest;
+
  apply:
 	changed = memcmp(&sta->sta.ht_cap, &ht_cap, sizeof(ht_cap));
 
-- 
1.9.1

