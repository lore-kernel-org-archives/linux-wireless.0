Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53132 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3DPNeh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 09:34:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>
Subject: [PATCH] mac80211: indicate admission control in TX queue parameters
Date: Tue, 16 Apr 2013 15:34:32 +0200
Message-Id: <1366119272-32666-1-git-send-email-johannes@sipsolutions.net> (sfid-20130416_153441_163732_656B5A95)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

Some driver implementations need to know whether mandatory
admission control is required by the AP for some ACs. Add
a parameter to the TX queue parameters indicating this.

As there's currently no support for admission control in
mac80211's AP implementation, it's only ever set for the
client implementation.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 2 ++
 net/mac80211/mlme.c    | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9ff10b3..28960f8 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -128,6 +128,7 @@ enum ieee80211_ac_numbers {
  *	2^n-1 in the range 1..32767]
  * @cw_max: maximum contention window [like @cw_min]
  * @txop: maximum burst time in units of 32 usecs, 0 meaning disabled
+ * @acm: is mandatory admission control required for the access category
  * @uapsd: is U-APSD mode enabled for the queue
  */
 struct ieee80211_tx_queue_params {
@@ -135,6 +136,7 @@ struct ieee80211_tx_queue_params {
 	u16 cw_min;
 	u16 cw_max;
 	u8 aifs;
+	bool acm;
 	bool uapsd;
 };
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index c7860d0..49caec9 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1661,6 +1661,7 @@ static bool ieee80211_sta_wmm_params(struct ieee80211_local *local,
 		params.cw_max = ecw2cw((pos[1] & 0xf0) >> 4);
 		params.cw_min = ecw2cw(pos[1] & 0x0f);
 		params.txop = get_unaligned_le16(pos + 2);
+		params.acm = acm;
 		params.uapsd = uapsd;
 
 		mlme_dbg(sdata,
-- 
1.8.0

