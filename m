Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:56607 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753758Ab3BDMuL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 07:50:11 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, victorg@ti.com, linville@tuxdriver.com,
	kgiori@qca.qualcomm.com, zefir.kurtisi@neratec.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: [PATCHv8 3/3] nl80211: allow DFS in start_ap
Date: Mon,  4 Feb 2013 13:49:58 +0100
Message-Id: <1359982200-2321-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20130204_135024_868845_0F8335B1)
In-Reply-To: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1359982200-2321-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch enables DFS within nl80211/cfg80211. start_ap now checks if
DFS is allowed on the channel with the selected channel width.

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
---
Changes to PATCHv7:
 * set radar required in AP params

Changes to PATCHv6:
 * let reg_can_beacon() and others check for channel states, simplify
   start_ap
 * check using cfg80211_chandef_dfs_required

Changes to PATCHv5:
 * check radar detection width
---
 net/wireless/nl80211.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 00e6599..2a71935 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2714,6 +2714,7 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_ap_settings params;
 	int err;
+	u8 radar_detect_width = 0;
 
 	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
 	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
@@ -2832,9 +2833,19 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &params.chandef))
 		return -EINVAL;
 
+	err = cfg80211_chandef_dfs_required(wdev->wiphy, &params.chandef);
+	if (err < 0)
+		return -EINVAL;
+	if (err) {
+		radar_detect_width = BIT(params.chandef.width);
+		params.radar_required = true;
+	}
+
 	mutex_lock(&rdev->devlist_mtx);
-	err = cfg80211_can_use_chan(rdev, wdev, params.chandef.chan,
-				    CHAN_MODE_SHARED);
+	err = cfg80211_can_use_iftype_chan(rdev, wdev, wdev->iftype,
+					   params.chandef.chan,
+					   CHAN_MODE_SHARED,
+					   radar_detect_width);
 	mutex_unlock(&rdev->devlist_mtx);
 
 	if (err)
-- 
1.7.10.4

