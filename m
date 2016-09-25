Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:56457 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934317AbcIYGxC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 02:53:02 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        Michael Braun <michael-dev@fami-braun.de>
Subject: [PATCH] mac80211: fix CMD_FRAME for AP_VLAN
Date: Sun, 25 Sep 2016 08:47:15 +0200
Message-Id: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de> (sfid-20160925_085309_299000_B93FE309)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using IEEE 802.11r FT OVER-DS roaming with AP_VLAN, hostapd needs to send
out a frame using CMD_FRAME for a station assigned to an AP_VLAN interface.

Right now, the userspace needs to give the exact AP_VLAN interface index
for CMD_FRAME; hostapd does not do this. Additionally, userspace cannot
use GET_STATION to query the AP_VLAN ifidx, as while GET_STATION finds
stations assigned to AP_VLAN even if the AP iface is queried, it does not
return AP_VLAN ifidx (it returns the queried one).

This breaks IEEE 802.11r over_ds with vlans, as the reply frame does not
get out. This patch fixes this by using get_sta_bss for CMD_FRAME.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
---
 net/mac80211/offchannel.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 55a9c5b..2afd329 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -819,7 +819,10 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		    mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT)
 			break;
 		rcu_read_lock();
-		sta = sta_info_get(sdata, mgmt->da);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			sta = sta_info_get(sdata, mgmt->da);
+		else
+			sta = sta_info_get_bss(sdata, mgmt->da);
 		rcu_read_unlock();
 		if (!sta)
 			return -ENOLINK;
-- 
2.1.4
