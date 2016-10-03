Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:55073 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbcJCLOX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 07:14:23 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
Subject: [PATCHv2 1/3] mac80211: fix CMD_FRAME for AP_VLAN
Date: Mon,  3 Oct 2016 13:14:15 +0200
Message-Id: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de> (sfid-20161003_131427_265805_ADB81E75)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using IEEE 802.11r FT OVER-DS roaming with AP_VLAN, hostapd needs to
send out a frame using CMD_FRAME for a station assigned to an AP_VLAN
interface.

Right now, the userspace needs to give the exact AP_VLAN interface index
for CMD_FRAME; hostapd does not do this. Additionally, userspace cannot
use GET_STATION to query the AP_VLAN ifidx, as while GET_STATION finds
stations assigned to AP_VLAN even if the AP iface is queried, it does not
return AP_VLAN ifidx (it returns the queried one).

This breaks IEEE 802.11r over_ds with vlans, as the reply frame does not
get out. This patch fixes this by using get_sta_bss for CMD_FRAME.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Cc: projekt-wlan@fem.tu-ilmenau.de
---
 net/mac80211/offchannel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 55a9c5b..688744c 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -819,7 +819,7 @@ int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		    mgmt->u.action.category == WLAN_CATEGORY_SPECTRUM_MGMT)
 			break;
 		rcu_read_lock();
-		sta = sta_info_get(sdata, mgmt->da);
+		sta = sta_info_get_bss(sdata, mgmt->da);
 		rcu_read_unlock();
 		if (!sta)
 			return -ENOLINK;
-- 
2.1.4
