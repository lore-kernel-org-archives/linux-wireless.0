Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754080Ab1KVSKk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Nov 2011 13:10:40 -0500
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] cfg80211: amend regulatory NULL dereference fix
Date: Tue, 22 Nov 2011 10:10:02 -0800
Message-Id: <1321985402-14257-4-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111122_191044_517876_F11B1DD9)
In-Reply-To: <1321985402-14257-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1321985402-14257-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johanne's patch for "cfg80211: fix regulatory NULL dereference"
was fine but needed some other set of fixes which my previous
patches addresses. This one ammends his fix with the other
considerations applied.

Cc: stable@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/reg.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index c8c3c59..b3393d6 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2104,7 +2104,7 @@ static int __set_regdom(const struct ieee80211_regdomain *rd)
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
 	if (!request_wiphy) {
-		reg_set_request_processed();
+		schedule_delayed_work(&reg_timeout, 0);
 		return -ENODEV;
 	}
 
-- 
1.7.4.15.g7811d

