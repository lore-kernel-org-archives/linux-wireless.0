Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35026 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab1KUJoJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Nov 2011 04:44:09 -0500
Subject: [PATCH] cfg80211: fix regulatory NULL dereference
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Nov 2011 10:44:00 +0100
Message-ID: <1321868640.3999.17.camel@jlt3.sipsolutions.net> (sfid-20111121_104413_868989_62927AFC)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

By the time userspace returns with a response to
the regulatory domain request, the wiphy causing
the request might have gone away. If this is so,
reject the update but mark the request as having
been processed anyway.

Cc: Luis R. Rodriguez <lrodriguez@qca.qualcomm.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/wireless/reg.c	2011-11-10 09:27:32.000000000 +0100
+++ b/net/wireless/reg.c	2011-11-21 10:41:57.000000000 +0100
@@ -2037,6 +2037,10 @@ static int __set_regdom(const struct iee
 	}
 
 	request_wiphy = wiphy_idx_to_wiphy(last_request->wiphy_idx);
+	if (!request_wiphy) {
+		reg_set_request_processed();
+		return -ENODEV;
+	}
 
 	if (!last_request->intersect) {
 		int r;


