Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from investici.nine.ch ([217.150.252.179]:28008 "EHLO
	confino.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab2FPRIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2012 13:08:14 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <ordex@autistici.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: In IBSS the DA field of auth frames is different from BSSID
Date: Sat, 16 Jun 2012 18:50:01 +0200
Message-Id: <1339865405-10787-1-git-send-email-ordex@autistici.org> (sfid-20120616_190856_109562_ED1D360F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of authentication frame exchange between two IBSS STAs, the
DA field must contain the destinatioin address (instead of the BSSID).

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/ibss.c        |    2 +-
 net/mac80211/ieee80211_i.h |    2 +-
 net/mac80211/util.c        |    6 +++---
 net/mac80211/work.c        |    5 +++--
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index b4c3031..4345e94 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -57,7 +57,7 @@ static void ieee80211_rx_mgmt_auth_ibss(struct ieee80211_sub_if_data *sdata,
 	 * has actually implemented this.
 	 */
 	if (auth_alg == WLAN_AUTH_OPEN && auth_transaction == 1)
-		ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0,
+		ieee80211_send_auth(sdata, 2, WLAN_AUTH_OPEN, NULL, 0, mgmt->sa,
 				    sdata->u.ibss.bssid, NULL, 0, 0);
 }
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 2f0642d..ca6486b 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1396,7 +1396,7 @@ void ieee80211_add_pending_skbs_fn(struct ieee80211_local *local,
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
 			 u8 *extra, size_t extra_len, const u8 *bssid,
-			 const u8 *key, u8 key_len, u8 key_idx);
+			 const u8 *da, const u8 *key, u8 key_len, u8 key_idx);
 int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 			     const u8 *ie, size_t ie_len,
 			     enum ieee80211_band band, u32 rate_mask,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 9919892..30d72e2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -862,8 +862,8 @@ u32 ieee80211_mandatory_rates(struct ieee80211_local *local,
 
 void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 			 u16 transaction, u16 auth_alg,
-			 u8 *extra, size_t extra_len, const u8 *bssid,
-			 const u8 *key, u8 key_len, u8 key_idx)
+			 u8 *extra, size_t extra_len, const u8 *da,
+			 const u8 *bssid, const u8 *key, u8 key_len, u8 key_idx)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
@@ -881,7 +881,7 @@ void ieee80211_send_auth(struct ieee80211_sub_if_data *sdata,
 	memset(mgmt, 0, 24 + 6);
 	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					  IEEE80211_STYPE_AUTH);
-	memcpy(mgmt->da, bssid, ETH_ALEN);
+	memcpy(mgmt->da, da, ETH_ALEN);
 	memcpy(mgmt->sa, sdata->vif.addr, ETH_ALEN);
 	memcpy(mgmt->bssid, bssid, ETH_ALEN);
 	mgmt->u.auth.auth_alg = cpu_to_le16(auth_alg);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index c6dd01a..0a1a176 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -480,7 +480,8 @@ ieee80211_authenticate(struct ieee80211_work *wk)
 	       sdata->name, wk->filter_ta, wk->probe_auth.tries);
 
 	ieee80211_send_auth(sdata, 1, wk->probe_auth.algorithm, wk->ie,
-			    wk->ie_len, wk->filter_ta, NULL, 0, 0);
+			    wk->ie_len, wk->filter_ta, wk->filter_ta, NULL, 0,
+			    0);
 	wk->probe_auth.transaction = 2;
 
 	wk->timeout = jiffies + IEEE80211_AUTH_TIMEOUT;
@@ -598,7 +599,7 @@ static void ieee80211_auth_challenge(struct ieee80211_work *wk,
 		return;
 	ieee80211_send_auth(sdata, 3, wk->probe_auth.algorithm,
 			    elems.challenge - 2, elems.challenge_len + 2,
-			    wk->filter_ta, wk->probe_auth.key,
+			    wk->filter_ta, wk->filter_ta, wk->probe_auth.key,
 			    wk->probe_auth.key_len, wk->probe_auth.key_idx);
 	wk->probe_auth.transaction = 4;
 }
-- 
1.7.9.4

