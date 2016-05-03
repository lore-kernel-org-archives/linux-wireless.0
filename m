Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f182.google.com ([209.85.161.182]:36280 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396AbcECUhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2016 16:37:14 -0400
From: Kangjie Lu <kangjielu@gmail.com>
To: johannes@sipsolutions.net
Cc: davem@davemloft.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	Kangjie Lu <kjlu@gatech.edu>
Subject: [PATCH] fix infoleak in wireless
Date: Tue,  3 May 2016 16:40:13 -0400
Message-Id: <1462308013-6032-1-git-send-email-kjlu@gatech.edu> (sfid-20160503_223744_418372_19D84B29)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 6-bytes array “mac_addr” is not initialized in the dump_station
implementations of “drivers/staging/wilc1000/wilc_wfi_cfgoperations.c”
and “drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c”, so all 6
bytes may be leaked.

Signed-off-by: Kangjie Lu <kjlu@gatech.edu>
---
 net/wireless/nl80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 056a730..2e92d14 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3905,6 +3905,7 @@ static int nl80211_dump_station(struct sk_buff *skb,
 
 	while (1) {
 		memset(&sinfo, 0, sizeof(sinfo));
+		eth_zero_addr(mac_addr);
 		err = rdev_dump_station(rdev, wdev->netdev, sta_idx,
 					mac_addr, &sinfo);
 		if (err == -ENOENT)
-- 
1.9.1

