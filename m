Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32511 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZBNGm2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Feb 2009 01:42:28 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 22:42:28 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] cfg80211: allow drivers that agree on regulatory to agree
Date: Fri, 13 Feb 2009 22:41:40 -0800
Message-ID: <1234593702-19750-2-git-send-email-lrodriguez@atheros.com> (sfid-20090214_074234_731916_010A6B4F)
In-Reply-To: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
References: <1234593702-19750-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers that agree on regulatory to share their
regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9dce86a..95f8298 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1164,6 +1164,16 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
 				return 0;
 			return -EALREADY;
 		}
+
+		/*
+		 * This would happen if you unplug and plug your card
+		 * back in or if you add a new device for which the previously
+		 * loaded card also agrees on the regulatory domain.
+		 */
+		if (last_request->initiator == REGDOM_SET_BY_DRIVER &&
+		    alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
+			return -EALREADY;
+
 		return REG_INTERSECT;
 	case REGDOM_SET_BY_USER:
 		if (last_request->initiator == REGDOM_SET_BY_COUNTRY_IE)
-- 
1.6.1.2.253.ga34a

