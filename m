Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53032 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414Ab3DPMp4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Apr 2013 08:45:56 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: sgruszka@redhat.com, emmanuel.grumbach@intel.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: regulatory: fix channel disabling race condition
Date: Tue, 16 Apr 2013 14:45:44 +0200
Message-Id: <1366116344-30225-1-git-send-email-johannes@sipsolutions.net> (sfid-20130416_144559_928521_2B4E8B7A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When a full scan 2.4 and 5 GHz scan is scheduled, but then the 2.4 GHz
part of the scan disables a 5.2 GHz channel due to, e.g. receiving
country or frequency information, that 5.2 GHz channel might already
be in the list of channels to scan next. Then, when the driver checks
if it should do a passive scan, that will return false and attempt an
active scan. This is not only wrong but can also lead to the iwlwifi
device firmware crashing since it checks regulatory as well.

Fix this by not setting the channel flags to just disabled but rather
OR'ing in the disabled flag. That way, even if the race happens, the
channel will be scanned passively which is still (mostly) correct.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 93ab840..507c28e 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -855,7 +855,7 @@ static void handle_channel(struct wiphy *wiphy,
 			return;
 
 		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->flags |= IEEE80211_CHAN_DISABLED;
 		return;
 	}
 
-- 
1.8.0

