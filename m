Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32335 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab1GLJtO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 05:49:14 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH] mac80211: remove a redundant check
Date: Tue, 12 Jul 2011 15:19:04 +0530
Message-ID: <1310464144-3509-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20110712_114918_229766_0AAD58C9)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

is_valid_ether_addr itself checks for is_zero_ether_addr

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 net/mac80211/iface.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 236d158..cd5fb40 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -363,8 +363,7 @@ static int ieee80211_open(struct net_device *dev)
 	int err;
 
 	/* fail early if user set an invalid address */
-	if (!is_zero_ether_addr(dev->dev_addr) &&
-	    !is_valid_ether_addr(dev->dev_addr))
+	if (!is_valid_ether_addr(dev->dev_addr))
 		return -EADDRNOTAVAIL;
 
 	err = ieee80211_check_concurrent_iface(sdata, sdata->vif.type);
-- 
1.7.0.4

