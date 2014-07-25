Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:43105
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751931AbaGYOU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 10:20:28 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/2] mac80211: ignore AP_VLAN in ieee80211_recalc_chanctx_chantype
Date: Fri, 25 Jul 2014 16:20:22 +0200
Message-Id: <1406298023-13389-1-git-send-email-nbd@openwrt.org> (sfid-20140725_162412_081266_203D92FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When bringing down the AP, a WARN_ON is hit because the bss config chandef
is empty here.
Since AP_VLAN channel settings do not matter for anything chanctx related
(always inherits the settings from the AP interface), let's just ignore
it here.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/chan.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 6d537f0..4206a11 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -541,6 +541,8 @@ static void ieee80211_recalc_chanctx_chantype(struct ieee80211_local *local,
 			continue;
 		if (rcu_access_pointer(sdata->vif.chanctx_conf) != conf)
 			continue;
+		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+			continue;
 
 		if (!compat)
 			compat = &sdata->vif.bss_conf.chandef;
-- 
1.8.5.2 (Apple Git-48)

