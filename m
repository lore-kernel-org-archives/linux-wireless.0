Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34348 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab1F0U6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 16:58:53 -0400
Received: by wyg8 with SMTP id 8so1345778wyg.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 13:58:52 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 1/2] mac80211: propagate information about STA WME support down
Date: Mon, 27 Jun 2011 23:58:45 +0300
Message-Id: <1309208326-18260-1-git-send-email-arik@wizery.com> (sfid-20110627_225906_730370_4FDACB5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add a memeber to the ieee80211_sta structure to indicate whether the STA
supports WME.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
v1->3: added a comment on the validity of the sta->wme flag in AP mode
only.

include/net/mac80211.h |    2 ++
 net/mac80211/cfg.c     |    5 ++++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 8c7189c..2271bdf 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -933,6 +933,7 @@ enum set_key_cmd {
  * @aid: AID we assigned to the station if we're an AP
  * @supp_rates: Bitmap of supported rates (per band)
  * @ht_cap: HT capabilities of this STA; restricted to our own TX capabilities
+ * @wme: indicates whether the STA supports WME. Only valid during AP-mode.
  * @drv_priv: data area for driver use, will always be aligned to
  *	sizeof(void *), size is determined in hw information.
  */
@@ -941,6 +942,7 @@ struct ieee80211_sta {
 	u8 addr[ETH_ALEN];
 	u16 aid;
 	struct ieee80211_sta_ht_cap ht_cap;
+	bool wme;
 
 	/* must be last */
 	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index be70c70..e6e6b35 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -674,8 +674,11 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 
 	if (mask & BIT(NL80211_STA_FLAG_WME)) {
 		sta->flags &= ~WLAN_STA_WME;
-		if (set & BIT(NL80211_STA_FLAG_WME))
+		sta->sta.wme = false;
+		if (set & BIT(NL80211_STA_FLAG_WME)) {
 			sta->flags |= WLAN_STA_WME;
+			sta->sta.wme = true;
+		}
 	}
 
 	if (mask & BIT(NL80211_STA_FLAG_MFP)) {
-- 
1.7.4.1

