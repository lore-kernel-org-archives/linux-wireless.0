Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:33982 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757628Ab3KHQbr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Nov 2013 11:31:47 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH] mac80211: fix crash when using AP VLAN interfaces
Date: Fri,  8 Nov 2013 17:31:37 +0100
Message-Id: <1383928297-25206-1-git-send-email-nbd@openwrt.org> (sfid-20131108_173151_474891_DCE1E36B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "mac80211: implement SMPS for AP" applies to AP_VLAN as well.
It assumes that sta->sdata->vif.bss_conf.bssid is present, which did not
get set for AP_VLAN.
Initialize it to sdata->vif.addr like for other interface types.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/mac80211/iface.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index ff101ea..36c3a4c 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1325,7 +1325,6 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 		sdata->vif.bss_conf.bssid = NULL;
 		break;
 	case NL80211_IFTYPE_AP_VLAN:
-		break;
 	case NL80211_IFTYPE_P2P_DEVICE:
 		sdata->vif.bss_conf.bssid = sdata->vif.addr;
 		break;
-- 
1.8.3.4 (Apple Git-47)

