Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49526 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab1KEMRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Nov 2011 08:17:23 -0400
Received: by faao14 with SMTP id o14so3511601faa.19
        for <linux-wireless@vger.kernel.org>; Sat, 05 Nov 2011 05:17:22 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	anamtsov@gmail.com, Helmut Schaa <helmut.schaa@googlemail.com>
Subject: [PATCH] mac80211: Also report the STA's TDLS flag via nl80211
Date: Sat,  5 Nov 2011 14:15:24 +0100
Message-Id: <1320498924-7205-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111105_131728_028038_71C4D4FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 net/mac80211/cfg.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a9ded52..e83791d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -411,7 +411,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 				BIT(NL80211_STA_FLAG_SHORT_PREAMBLE) |
 				BIT(NL80211_STA_FLAG_WME) |
 				BIT(NL80211_STA_FLAG_MFP) |
-				BIT(NL80211_STA_FLAG_AUTHENTICATED);
+				BIT(NL80211_STA_FLAG_AUTHENTICATED) |
+				BIT(NL80211_STA_FLAG_TDLS_PEER);
 	if (test_sta_flag(sta, WLAN_STA_AUTHORIZED))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHORIZED);
 	if (test_sta_flag(sta, WLAN_STA_SHORT_PREAMBLE))
@@ -422,6 +423,8 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_MFP);
 	if (test_sta_flag(sta, WLAN_STA_AUTH))
 		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_AUTHENTICATED);
+	if (test_sta_flag(sta, WLAN_STA_TDLS_PEER))
+		sinfo->sta_flags.set |= BIT(NL80211_STA_FLAG_TDLS_PEER);
 }
 
 
-- 
1.7.3.4

