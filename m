Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33620 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755990AbbJVPqJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2015 11:46:09 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/3] mac80211: fixup AIFSN instead of disabling WMM
Date: Thu, 22 Oct 2015 17:46:05 +0200
Message-Id: <1445528766-19048-2-git-send-email-johannes@sipsolutions.net> (sfid-20151022_174615_360066_B831575D)
In-Reply-To: <1445528766-19048-1-git-send-email-johannes@sipsolutions.net>
References: <1445528766-19048-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Disabling WMM has a huge impact these days. It implies that
HT and VHT will be disabled which means that the throughput
will be drammatically reduced.
Since the AIFSN is a transmission parameter, we can play a
bit and fix it up to make it compliant with the 802.11
specification which requires it to be at least 2.
Increasing it from 1 to 2 will slightly reduce the
likelyhood to get a transmission opportunity compared to
other clients that would accept to set AIFSN=1, but at
least it will allow HT and VHT which is a huge gain.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0d0ce5cc371d..0aaac951a32c 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1816,6 +1816,13 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		}
 
 		params.aifs = pos[0] & 0x0f;
+
+		if (params.aifs < 2) {
+			sdata_info(sdata,
+				   "AP has invalid WMM params (AIFSN=%d for ACI %d), will use 2\n",
+				   params.aifs, aci);
+			params.aifs = 2;
+		}
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
 		params.txop = get_unaligned_le16(pos + 2);
@@ -4559,17 +4566,10 @@ static bool ieee80211_usable_wmm_params(struct ieee80211_sub_if_data *sdata,
 	left = len - 8;
 
 	for (; left >= 4; left -= 4, pos += 4) {
-		u8 aifsn = pos[0] & 0x0f;
 		u8 ecwmin = pos[1] & 0x0f;
 		u8 ecwmax = (pos[1] & 0xf0) >> 4;
 		int aci = (pos[0] >> 5) & 0x03;
 
-		if (aifsn < 2) {
-			sdata_info(sdata,
-				   "AP has invalid WMM params (AIFSN=%d for ACI %d), disabling WMM\n",
-				   aifsn, aci);
-			return false;
-		}
 		if (ecwmin > ecwmax) {
 			sdata_info(sdata,
 				   "AP has invalid WMM params (ECWmin/max=%d/%d for ACI %d), disabling WMM\n",
-- 
2.5.1

