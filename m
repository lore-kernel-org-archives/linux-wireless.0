Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34168 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756629Ab3J1OIo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:08:44 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: add missing break in cfg80211_get_chan_state()
Date: Mon, 28 Oct 2013 15:08:40 +0100
Message-Id: <1382969320-25660-1-git-send-email-johannes@sipsolutions.net> (sfid-20131028_150847_088918_561EFC7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Improve readability of the function by adding the break,
there's no functional impact but it's confusing to fall
through.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 9b8cc87..59c4f9a 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -510,6 +510,7 @@ cfg80211_get_chan_state(struct wireless_dev *wdev,
 				  : CHAN_MODE_EXCLUSIVE;
 			return;
 		}
+		break;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_P2P_CLIENT:
 		if (wdev->current_bss) {
-- 
1.8.4.rc3

