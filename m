Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:12840 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab1IMOsj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 10:48:39 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] wireless: Reset beacon_found while updating regulatory
Date: Tue, 13 Sep 2011 20:19:13 +0530
Message-ID: <1315925353-20152-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110913_164843_233035_DDBC1F13)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the association, the regulatory is updated by country IE
that reaps the previously found beacons. So the passive scan
channels after the association is never getting cleared even
the beacons are received on that channel. This patch resets
beacon_found while updating regulatory.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/reg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9f3aa5c..e38ccbb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -850,6 +850,7 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-- 
1.7.6.1

