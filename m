Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38205 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2KET2M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 14:28:12 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: use mac_pton
Date: Mon,  5 Nov 2012 20:28:47 +0100
Message-Id: <1352143727-29422-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_202827_044531_BA5B3ACF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of implementing practically the same
function (hwaddr_aton) use mac_pton.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 07c5721..4b68ec7 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -10,6 +10,7 @@
 #include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/if.h>
+#include <linux/if_ether.h>
 #include <linux/interrupt.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
@@ -248,27 +249,6 @@ static ssize_t ieee80211_if_fmt_tkip_mic_test(
 	return -EOPNOTSUPP;
 }
 
-static int hwaddr_aton(const char *txt, u8 *addr)
-{
-	int i;
-
-	for (i = 0; i < ETH_ALEN; i++) {
-		int a, b;
-
-		a = hex_to_bin(*txt++);
-		if (a < 0)
-			return -1;
-		b = hex_to_bin(*txt++);
-		if (b < 0)
-			return -1;
-		*addr++ = (a << 4) | b;
-		if (i < 5 && *txt++ != ':')
-			return -1;
-	}
-
-	return 0;
-}
-
 static ssize_t ieee80211_if_parse_tkip_mic_test(
 	struct ieee80211_sub_if_data *sdata, const char *buf, int buflen)
 {
@@ -278,13 +258,7 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
 
-	/*
-	 * Assume colon-delimited MAC address with possible white space
-	 * following.
-	 */
-	if (buflen < 3 * ETH_ALEN - 1)
-		return -EINVAL;
-	if (hwaddr_aton(buf, addr) < 0)
+	if (!mac_pton(buf, addr))
 		return -EINVAL;
 
 	if (!ieee80211_sdata_running(sdata))
-- 
1.8.0

