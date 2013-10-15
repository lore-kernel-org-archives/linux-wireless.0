Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34823 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758739Ab3JONRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 09:17:16 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH 3.12 1/3] mac80211: fix honouring rate flags in low-rate transmit
Date: Tue, 15 Oct 2013 15:17:08 +0200
Message-Id: <1381843030-12260-1-git-send-email-johannes@sipsolutions.net> (sfid-20131015_151719_896322_452B2366)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Transmissions with the IEEE80211_TX_CTL_NO_CCK_RATE flag set
(which can come from userspace) were no longer guaranteed to
be transmitted with allowed rates since commit 2103dec14792b
("mac80211: select and adjust bitrates according to channel
mode") due to a missing rate_flags check in that commit. The
commit also introduced the need to check the 5/10 MHz flags
but accidentally didn't. Fix it by adding the missing check.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rate.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index e126605..7f7ce11 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -247,6 +247,9 @@ static void __rate_control_send_low(struct ieee80211_hw *hw,
 
 	info->control.rates[0].idx = 0;
 	for (i = 0; i < sband->n_bitrates; i++) {
+		if ((rate_flags & sband->bitrates[i].flags) != rate_flags)
+			continue;
+
 		if (!rate_supported(sta, sband->band, i))
 			continue;
 
-- 
1.8.4.rc3

