Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:35444 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933962AbZLFRXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:23:41 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linville@tuxdriver.com
Subject: [PATCH 2/4] mac80211: Add new callback set_coverage
Date: Sun, 6 Dec 2009 18:23:45 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net>
In-Reply-To: <200912061820.26320.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912061823.45809.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mac80211 callback to driver set_coverage() sets slot time and ACK timeout
for given coverage class. The callback is optional, but it's essential for
long distance links.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 include/net/mac80211.h |    5 +++++
 net/mac80211/cfg.c     |    6 ++++++
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1d75b96..2865bc6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1477,6 +1477,10 @@ enum ieee80211_ampdu_mlme_action {
  *	need to set wiphy->rfkill_poll to %true before registration,
  *	and need to call wiphy_rfkill_set_hw_state() in the callback.
  *
+ * @set_coverage: Set slot time for given coverage class as specified
+ *	in IEEE 802.11-2007 section 17.3.8.6 and modify ACK timeout
+ *	accordingly. Optional function, could be NULL.
+ *
  * @testmode_cmd: Implement a cfg80211 test mode command.
  */
 struct ieee80211_ops {
@@ -1531,6 +1535,7 @@ struct ieee80211_ops {
 			    struct ieee80211_sta *sta, u16 tid, u16 *ssn);
 
 	void (*rfkill_poll)(struct ieee80211_hw *hw);
+	void (*set_coverage)(struct ieee80211_hw *hw, u8 coverage_class);
 #ifdef CONFIG_NL80211_TESTMODE
 	int (*testmode_cmd)(struct ieee80211_hw *hw, void *data, int len);
 #endif
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 93ee1fd..f0ab669 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1236,6 +1236,12 @@ static int ieee80211_set_wiphy_params(struct wiphy 
*wiphy, u32 changed)
 	struct ieee80211_local *local = wiphy_priv(wiphy);
 	int err;
 
+	if (changed & WIPHY_PARAM_COVERAGE_CLASS) {
+		if (!local->ops->set_coverage)
+			return -EOPNOTSUPP;
+		local->ops->set_coverage(&local->hw, wiphy->coverage_class);
+	}
+
 	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
 		err = drv_set_rts_threshold(local, wiphy->rts_threshold);
 
-- 
1.6.4.4
