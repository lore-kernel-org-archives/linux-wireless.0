Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.mujha-vel.cz ([81.30.225.246]:47629 "EHLO
	smtp.mujha-vel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932451Ab0AFRgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 12:36:06 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: wireless, fix lock imbalance
Date: Wed,  6 Jan 2010 17:35:42 +0100
Message-Id: <1262795743-15009-1-git-send-email-jslaby@suse.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One fail path in cfg80211_wext_siwscan omits to unlock rdev->mtx.
Fix that.

Trigerrable by "Scan for SSID" with long enough SSID (> 32).

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/wireless/scan.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 12dfa62..9c50c85 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -694,8 +694,10 @@ int cfg80211_wext_siwscan(struct net_device *dev,
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out;
+			}
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
 		}
-- 
1.6.5.7

