Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:53358 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918AbZEETsp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2009 15:48:45 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] mac80211: Fix sparse warning for ssid_len on ieee80211_sta_config_auth()
Date: Tue,  5 May 2009 15:48:39 -0400
Message-Id: <1241552919-27568-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

net/mac80211/mlme.c:2079:28: warning: symbol 'ssid_len' shadows an earlier one
net/mac80211/mlme.c:2022:12: originally declared here

ssid_len is already being declared and checked above so there is
no need for it again.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/mlme.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5509c5a..75c4872 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2076,10 +2076,6 @@ static int ieee80211_sta_config_auth(struct ieee80211_sub_if_data *sdata)
 		return 0;
 	} else {
 		if (ifmgd->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
-			u8 ssid_len = 0;
-
-			if (!(ifmgd->flags & IEEE80211_STA_AUTO_SSID_SEL))
-				ssid_len = ifmgd->ssid_len;
 
 			ifmgd->assoc_scan_tries++;
 
-- 
1.6.2.2.446.gfbdc0

