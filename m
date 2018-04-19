Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:58271 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751135AbeDSJSO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Apr 2018 05:18:14 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: Bernhard_Gabler@web.de,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH] reg: Rename confusing 'country IE' in log output
Date: Thu, 19 Apr 2018 11:17:38 +0200
Message-Id: <20180419091738.9068-1-toke@toke.dk> (sfid-20180419_111818_112796_8753F00D)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The 'country IE' messages in the log can be confusing and make people think
that the country code has been set to Ireland. Fix this by changing the
log messages to use 'country element' instead (as they are no longer called
'information element' in the spec anyway).

Reported-by: Bernhard Gabler <Bernhard_Gabler@web.de>
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 16c7e4ef5820..ecfee5f06c76 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1652,7 +1652,7 @@ const char *reg_initiator_name(enum nl80211_reg_initiator initiator)
 	case NL80211_REGDOM_SET_BY_DRIVER:
 		return "driver";
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
-		return "country IE";
+		return "country element";
 	default:
 		WARN_ON(1);
 		return "bug";
@@ -2618,7 +2618,7 @@ reg_process_hint_country_ie(struct wiphy *wiphy,
 		 * This doesn't happen yet, not sure we
 		 * ever want to support it for this case.
 		 */
-		WARN_ONCE(1, "Unexpected intersection for country IEs");
+		WARN_ONCE(1, "Unexpected intersection for country elements");
 		return REG_REQ_IGNORE;
 	}
 
-- 
2.16.3
