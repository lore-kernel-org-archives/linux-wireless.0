Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:42047 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750772AbdIRHp6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Sep 2017 03:45:58 -0400
From: Ganapathi Bhat <gbhat@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Brian Norris <briannorris@chromium.org>,
        Cathy Luo <cluo@marvell.com>, Xinming Hu <huxm@marvell.com>,
        Zhiyuan Yang <yangzy@marvell.com>,
        James Cao <jcao@marvell.com>,
        Mangesh Malusare <mmangesh@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>
Subject: [PATCH 2/2] mwifiex: use get_random_mask_addr() helper
Date: Mon, 18 Sep 2017 13:12:17 +0530
Message-ID: <1505720537-13362-1-git-send-email-gbhat@marvell.com> (sfid-20170918_094601_241859_181EA4DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Avoid calculating random MAC address in driver. Instead make
use of 'get_random_mask_addr()' function.

Signed-off-by: Ganapathi Bhat <gbhat@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/cfg80211.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cfg80211.c b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
index 84c1518..2b293b1 100644
--- a/drivers/net/wireless/marvell/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/marvell/mwifiex/cfg80211.c
@@ -2503,6 +2503,7 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	struct ieee80211_channel *chan;
 	struct ieee_types_header *ie;
 	struct mwifiex_user_scan_cfg *user_scan_cfg;
+	u8 mac_addr[ETH_ALEN];
 
 	mwifiex_dbg(priv->adapter, CMD,
 		    "info: received scan request on %s\n", dev->name);
@@ -2529,12 +2530,10 @@ static int mwifiex_set_ibss_params(struct mwifiex_private *priv,
 	priv->scan_request = request;
 
 	if (request->flags & NL80211_SCAN_FLAG_RANDOM_ADDR) {
-		for (i = 0; i < ETH_ALEN; i++) {
-			request->mac_addr[i] &= request->mac_addr_mask[i];
-			request->mac_addr[i] |=
-				get_random_int() & ~(request->mac_addr_mask[i]);
-		}
-		ether_addr_copy(user_scan_cfg->random_mac, request->mac_addr);
+		get_random_mask_addr(mac_addr, request->mac_addr,
+				     request->mac_addr_mask);
+		ether_addr_copy(request->mac_addr, mac_addr);
+		ether_addr_copy(user_scan_cfg->random_mac, mac_addr);
 	}
 
 	user_scan_cfg->num_ssids = request->n_ssids;
-- 
1.9.1
