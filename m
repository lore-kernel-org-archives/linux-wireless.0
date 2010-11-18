Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:44530 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab0KRFqX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 00:46:23 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 21:46:10 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <mark@moxienet.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] cfg80211: move reg_work and reg_todo above
Date: Wed, 17 Nov 2010 21:46:07 -0800
Message-ID: <1290059169-2468-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
References: <1290059169-2468-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These will be used earlier in the next few patches.

Cc: Mark Mentovai <mark@moxienet.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 9830db6..3fa2474 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -96,6 +96,9 @@ struct reg_beacon {
 	struct ieee80211_channel chan;
 };
 
+static void reg_todo(struct work_struct *work);
+static DECLARE_WORK(reg_work, reg_todo);
+
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 5,
@@ -1494,8 +1497,6 @@ static void reg_todo(struct work_struct *work)
 	reg_process_pending_beacon_hints();
 }
 
-static DECLARE_WORK(reg_work, reg_todo);
-
 static void queue_regulatory_request(struct regulatory_request *request)
 {
 	if (isalpha(request->alpha2[0]))
-- 
1.7.3.2.90.gd4c43

