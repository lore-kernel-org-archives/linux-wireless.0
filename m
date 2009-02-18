Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55338 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbZBRXZr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 18:25:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: johannes@sipsolutions.net
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH v4 14/15] cfg80211: allow drivers that agree on regulatory to agree
Date: Wed, 18 Feb 2009 18:25:44 -0500
Message-Id: <1234999545-14357-15-git-send-email-lrodriguez@atheros.com> (sfid-20090219_005322_406927_5E581F34)
In-Reply-To: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
References: <1234999545-14357-1-git-send-email-lrodriguez@atheros.com>
To: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This allows drivers that agree on regulatory to share their
regulatory domain.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b7ff6d5..c6087bc 100644
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
1.6.0.3

