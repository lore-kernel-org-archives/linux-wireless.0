Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:47480 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbZL3NyQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Dec 2009 08:54:16 -0500
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx03.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id nBUDsAXX029614
	for <linux-wireless@vger.kernel.org>; Wed, 30 Dec 2009 15:54:13 +0200
Subject: [PATCH] mac80211: fix ieee80211_change_mac() to use struct sockaddr
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kalle.valo@iki.fi>
Cc: Kalle Valo <kalle.valo@nokia.com>
Date: Wed, 30 Dec 2009 15:54:03 +0200
Message-ID: <20091230135403.30935.72535.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Setting the mac address from user space was buggy. For example, when
executing this command:

ip link set wlan0 address 00:1f:df:88:cd:55

mac80211 used the address 01:00:00:1f:df:88 instead. It was shifted two
bytes.

The reason was that the addr (type of void *) provided to
ieee80211_change_mac() is actually of type struct sockaddr, not just the
mac address array. Also the call to eth_mac_addr() expects the address to
be struct sockaddr.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---
 net/mac80211/iface.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 00a1f4c..7218966 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -63,15 +63,16 @@ static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
 static int ieee80211_change_mac(struct net_device *dev, void *addr)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sockaddr *sa = addr;
 	int ret;
 
 	if (ieee80211_sdata_running(sdata))
 		return -EBUSY;
 
-	ret = eth_mac_addr(dev, addr);
+	ret = eth_mac_addr(dev, sa);
 
 	if (ret == 0)
-		memcpy(sdata->vif.addr, addr, ETH_ALEN);
+		memcpy(sdata->vif.addr, sa->sa_data, ETH_ALEN);
 
 	return ret;
 }

