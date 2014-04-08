Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33161 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235AbaDHWIE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 18:08:04 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.15] mac80211: suppress BSS info change notifications for AP_VLAN
Date: Wed,  9 Apr 2014 00:08:01 +0200
Message-Id: <1396994881-54087-1-git-send-email-nbd@openwrt.org> (sfid-20140409_000809_686177_E29301F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes warnings on tx power changes

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index b055f6a5..4172d42 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -199,7 +199,7 @@ void ieee80211_bss_info_change_notify(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_local *local = sdata->local;
 
-	if (!changed)
+	if (!changed || sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
 		return;
 
 	drv_bss_info_changed(local, sdata, &sdata->vif.bss_conf, changed);
-- 
1.8.5.2 (Apple Git-48)

