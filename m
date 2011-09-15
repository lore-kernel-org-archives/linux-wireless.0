Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20594 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932575Ab1IOKyW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 06:54:22 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: Do not allow disabled channel during scan
Date: Thu, 15 Sep 2011 16:24:56 +0530
Message-ID: <1316084096-12565-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_125432_614661_3467831B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The scan decision allows disabled channel to be set. So the
probe request was seen over the disabled channel. This patch
skips the disabled channel while scanning.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/scan.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
index 6f09eca..9c3d309 100644
--- a/net/mac80211/scan.c
+++ b/net/mac80211/scan.c
@@ -616,6 +616,10 @@ static void ieee80211_scan_state_set_channel(struct ieee80211_local *local,
 		if (ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_CHANNEL))
 			skip = 1;
 
+	/* Skip disabled channels */
+	if (chan->flags & IEEE80211_CHAN_DISABLED)
+		skip = 1;
+
 	/* advance state machine to next channel/band */
 	local->scan_channel_idx++;
 
-- 
1.7.6.1

