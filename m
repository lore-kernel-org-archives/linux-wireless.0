Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static.88-198-24-112.clients.your-server.de ([88.198.24.112]:43107
	"EHLO nbd.name" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752073AbaGYOU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jul 2014 10:20:28 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 2/2] mac80211: fix smps mode check for AP_VLAN
Date: Fri, 25 Jul 2014 16:20:23 +0200
Message-Id: <1406298023-13389-2-git-send-email-nbd@openwrt.org> (sfid-20140725_162412_701637_9DE66D6A)
In-Reply-To: <1406298023-13389-1-git-send-email-nbd@openwrt.org>
References: <1406298023-13389-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ieee80211_sta_ps_deliver_wakeup, sdata->smps_mode is checked. This is
initialized only for the base AP interface, not the individual VLANs.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/sta_info.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f41177f..6b0e886 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1094,8 +1094,11 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 	unsigned long flags;
 	struct ps_data *ps;
 
-	if (sdata->vif.type == NL80211_IFTYPE_AP ||
-	    sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
+				     u.ap);
+
+	if (sdata->vif.type == NL80211_IFTYPE_AP)
 		ps = &sdata->bss->ps;
 	else if (ieee80211_vif_is_mesh(&sdata->vif))
 		ps = &sdata->u.mesh.ps;
-- 
1.8.5.2 (Apple Git-48)

