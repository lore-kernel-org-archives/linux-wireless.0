Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:57797 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab3KFQxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Nov 2013 11:53:39 -0500
Received: by mail-ea0-f175.google.com with SMTP id l15so4135775eak.6
        for <linux-wireless@vger.kernel.org>; Wed, 06 Nov 2013 08:53:37 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 1/19] cfg80211: enforce disabling channels by custom or strict settings
Date: Wed,  6 Nov 2013 17:54:44 +0100
Message-Id: <1383756884-8556-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131106_175342_394666_E92B433F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If a custom regulatory domain is passed and if a rule for a
channel indicates it should be disabled that channel should
always remain disabled as per its documentation and design.

Likewise if WIPHY_FLAG_STRICT_REGULATORY flag is set and a
regulatory_hint() is issued if a channel is disabled that
channel should remain disabled.

Without this change only drivers that set the _orig flags
appropriately on their own would ensure disallowed channels
remaind disabled. This helps drivers save code by relying on
the APIS provided to entrust channels that should not be enabled
be respected by only having to use wiphy_apply_custom_regulatory()
or regulatory_hint() with the WIPHY_FLAG_STRICT_REGULATORY set.

If wiphy_apply_custom_regulatory() is used together with
WIPHY_FLAG_STRICT_REGULATORY and a regulatory_hint() issued
later, the incoming regulatory domain can override previously
set _orig parameters from the initial custom regulatory
setting.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---

This v2 splits up the flag assignements into two lines
to make things clear: we extend the _orig flags with the
disable flag, and then just copy it over to the regular
channel flags.

 net/wireless/reg.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dccdfe3..b4b1687 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -846,8 +846,18 @@ static void handle_channel(struct wiphy *wiphy,
 		    PTR_ERR(reg_rule) == -ERANGE)
 			return;
 
-		REG_DBG_PRINT("Disabling freq %d MHz\n", chan->center_freq);
-		chan->flags |= IEEE80211_CHAN_DISABLED;
+		if (lr->initiator == NL80211_REGDOM_SET_BY_DRIVER &&
+		    request_wiphy && request_wiphy == wiphy &&
+		    request_wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
+			REG_DBG_PRINT("Disabling freq %d MHz for good\n",
+				      chan->center_freq);
+			chan->orig_flags |= IEEE80211_CHAN_DISABLED;
+			chan->flags = chan->orig_flags;
+		} else {
+			REG_DBG_PRINT("Disabling freq %d MHz\n",
+				      chan->center_freq);
+			chan->flags |= IEEE80211_CHAN_DISABLED;
+		}
 		return;
 	}
 
@@ -1250,7 +1260,8 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	if (IS_ERR(reg_rule)) {
 		REG_DBG_PRINT("Disabling freq %d MHz as custom regd has no rule that fits it\n",
 			      chan->center_freq);
-		chan->flags = IEEE80211_CHAN_DISABLED;
+		chan->orig_flags |= IEEE80211_CHAN_DISABLED;
+		chan->flags = chan->orig_flags;
 		return;
 	}
 
-- 
1.8.4.rc3

