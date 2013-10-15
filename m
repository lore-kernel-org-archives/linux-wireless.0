Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab3JONS6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:18:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.12 3/3] mac80211: sanity check WMM/QoS parameters
Date: Tue, 15 Oct 2013 15:17:10 +0200
Message-Id: <1381843030-12260-3-git-send-email-johannes@sipsolutions.net> (sfid-20131015_151903_954538_B0C1D1CC)
In-Reply-To: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
References: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Check for invalid WMM parameters (AIFSN < 2 or CWmax < CWmin)
and try to set them to usable values in this case.

Notably the Sitecom WL-153 v1 with firmware 1.45 is sending
AIFSN, ECWmin and ECWmax as all zero.

Reported-and-tested-by: Antonio Quartulli <antonio@meshcoding.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 86e4ad5..058ae1c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1598,6 +1598,7 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 	int count;
 	const u8 *pos;
 	u8 uapsd_queues = 0;
+	static const u8 default_aifs[] = { 2, 2, 3, 7 };
 
 	if (!local->ops->conf_tx)
 		return false;
@@ -1664,8 +1665,12 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		}
 
 		params.aifs = pos[0] & 0x0f;
+		if (params.aifs < 2)
+			params.aifs = default_aifs[queue];
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
+		if (params.cw_max < params.cw_min)
+			params.cw_max = params.cw_min;
 		params.txop = get_unaligned_le16(pos + 2);
 		params.acm = acm;
 		params.uapsd = uapsd;
-- 
1.8.4.rc3

