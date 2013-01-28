Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1532 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1OTQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 09:19:16 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [RFC/RFT] mac80211: use macaddr vif parameter for P2P_DEVICE
 creation
Date: Mon, 28 Jan 2013 15:19:06 +0100
Message-ID: <1359382746-26322-1-git-send-email-arend@broadcom.com> (sfid-20130128_151919_850592_1A788D5C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch is a follow-up of:

commit 1c18f1452a772dfe884ed25677bddb3ecaf9c43a
Author: Arend van Spriel <arend@broadcom.com>
Date:   Tue Jan 8 10:17:27 2013 +0100

    nl80211: allow user-space to set address for P2P_DEVICE

The address of the wdev is determined by the macaddr parameter
when it is not a zero ethernet address. Otherwise, the permanent
address as determined by ieee80211_assign_perm_addr() is used.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

Here a mac80211 change to take the user-space provided mac address into
account. Not sure if that is sufficient. Tested P2P device vif creation using
iw with mac80211_hwsim:

phy#0
        Unnamed/non-netdev interface
                wdev 0x2
                addr 00:01:02:03:04:05
                type P2P-device
        Interface wlan0
                ifindex 9
                wdev 0x1
                addr 02:00:00:00:00:00
                type managed

Gr. AvS
---
 net/mac80211/iface.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 0a36dc6..b9ec91f 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1530,7 +1530,12 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 
 		sdata->dev = NULL;
 		strlcpy(sdata->name, name, IFNAMSIZ);
-		ieee80211_assign_perm_addr(local, wdev->address, type);
+		/* only use perm address if not provided in params */
+		if (is_zero_ether_addr(params->macaddr))
+			ieee80211_assign_perm_addr(local, wdev->address, type);
+		else
+			memcpy(wdev->address, params->macaddr, ETH_ALEN);
+
 		memcpy(sdata->vif.addr, wdev->address, ETH_ALEN);
 	} else {
 		if (local->hw.queues >= IEEE80211_NUM_ACS)
-- 
1.7.10.4


