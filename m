Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:48847 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396AbZBREiC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 23:38:02 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 20:38:02 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH v3 14/15] cfg80211: allow drivers that agree on regulatory to agree
Date: Tue, 17 Feb 2009 20:22:01 -0800
Message-ID: <1234930922-29367-15-git-send-email-lrodriguez@atheros.com> (sfid-20090218_053809_667475_8DC99CA6)
In-Reply-To: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com>
References: <1234930922-29367-1-git-send-email-lrodriguez@atheros.com>
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
index ee27866..ae6921a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1157,6 +1157,16 @@ static int ignore_request(struct wiphy *wiphy, enum reg_set_by set_by,
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

