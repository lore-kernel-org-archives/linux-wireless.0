Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38207 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2KET2T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Nov 2012 14:28:19 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix race in TKIP MIC test debugfs file
Date: Mon,  5 Nov 2012 20:28:55 +0100
Message-Id: <1352143735-29463-1-git-send-email-johannes@sipsolutions.net> (sfid-20121105_202827_701830_D39396A4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Accessing sdata->vif.bss_conf.bssid without any
protection here is racy, use u.mgd.associated
instead and lock the correct mutex for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/debugfs_netdev.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/debugfs_netdev.c b/net/mac80211/debugfs_netdev.c
index 4b68ec7..99ce871 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -284,13 +284,16 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(
 	case NL80211_IFTYPE_STATION:
 		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
 		/* BSSID SA DA */
-		if (sdata->vif.bss_conf.bssid == NULL) {
+		mutex_lock(&sdata->u.mgd.mtx);
+		if (!sdata->u.mgd.associated) {
+			mutex_unlock(&sdata->u.mgd.mtx);
 			dev_kfree_skb(skb);
 			return -ENOTCONN;
 		}
-		memcpy(hdr->addr1, sdata->vif.bss_conf.bssid, ETH_ALEN);
+		memcpy(hdr->addr1, sdata->u.mgd.associated->bssid, ETH_ALEN);
 		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
 		memcpy(hdr->addr3, addr, ETH_ALEN);
+		mutex_unlock(&sdata->u.mgd.mtx);
 		break;
 	default:
 		dev_kfree_skb(skb);
-- 
1.8.0

