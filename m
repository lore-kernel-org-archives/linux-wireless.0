Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:30251 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932724Ab1DZBfx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Apr 2011 21:35:53 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 25 Apr 2011 18:35:26 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: fix regresion on reg user timeout
Date: Mon, 25 Apr 2011 18:35:48 -0700
Message-ID: <1303781748-21498-1-git-send-email-lrodriguez@atheros.com> (sfid-20110426_033555_920044_E50545DF)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch "cfg80211: add a timer for invalid user reg hints"
introduced a regression for the case where a secondary identical
regulatory hint from a user is sent. What would happen is the
second hint would schedule delayed work in to catch a timeout
but since we are never processing it given that the hint was already
applied we'd always hit the timeout and and restore regulatory
settings back to world regulatory domain. This is fixed by simply
avoiding sheduling work if the hint was already applied.

Tested-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 58d6995..1613080 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1455,7 +1455,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
 	 * We only time out user hints, given that they should be the only
 	 * source of bogus requests.
 	 */
-	if (reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
+	if (r != -EALREADY &&
+	    reg_request->initiator == NL80211_REGDOM_SET_BY_USER)
 		schedule_delayed_work(&reg_timeout, msecs_to_jiffies(3142));
 }
 
-- 
1.7.4.15.g7811d

