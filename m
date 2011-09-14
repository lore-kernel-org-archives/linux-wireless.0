Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38553 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab1INI5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:57:41 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] wireless: Reset beacon_found while updating regulatory
Date: Wed, 14 Sep 2011 14:28:17 +0530
Message-ID: <1315990697-3575-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110914_105745_689628_AD3F0019)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

During the association, the regulatory is updated by country IE
that reaps the previously found beacons. The impact is that
after a STA disconnects *or* when for any reason a regulatory
domain change happens the beacon hint flag is not cleared
therefore preventing future beacon hints to be learned.
This is important as a regulatory domain change or a restore
of regulatory settings would set back the passive scan and no-ibss
flags on the channel. This is the right place to do this given that
it covers any regulatory domain change.

Cc: stable@kernel.org
Reviewed-by: Luis R. Rodriguez <mcgrof@gmail.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/wireless/reg.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index a2b09c2..1bbd2a9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -851,6 +851,7 @@ static void handle_channel(struct wiphy *wiphy,
 		return;
 	}
 
+	chan->beacon_found = false;
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-- 
1.7.6.1

