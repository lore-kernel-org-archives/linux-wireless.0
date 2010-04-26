Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:39931 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753041Ab0DZXXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 19:23:55 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/2] mac80211: implement ap isolation support
Date: Tue, 27 Apr 2010 01:23:36 +0200
Message-Id: <1272324216-73349-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
References: <1272324216-73349-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/cfg.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 845a6e6..b6fed60 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -1115,6 +1115,13 @@ static int ieee80211_change_bss(struct wiphy *wiphy,
 		changed |= BSS_CHANGED_BASIC_RATES;
 	}
 
+	if (params->ap_isolate >= 0) {
+		if (params->ap_isolate)
+			sdata->flags |= IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
+		else
+			sdata->flags &= ~IEEE80211_SDATA_DONT_BRIDGE_PACKETS;
+	}
+
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	return 0;
-- 
1.6.4.2

