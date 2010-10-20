Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33449 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab0JTRTK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:19:00 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 5/7] cfg80211: add debug print when disabling a channel on a custom regd
Date: Wed, 20 Oct 2010 10:18:57 -0700
Message-ID: <1287595139-10761-6-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 950f689..62396b2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1123,6 +1123,11 @@ static void handle_channel_custom(struct wiphy *wiphy,
 			       regd);
 
 	if (r) {
+		REG_DBG_PRINT("cfg80211: Disabling freq %d MHz as custom "
+			      "regd has no rule that fits a %d MHz "
+			      "wide channel\n",
+			      chan->center_freq,
+			      KHZ_TO_MHZ(desired_bw_khz));
 		chan->flags = IEEE80211_CHAN_DISABLED;
 		return;
 	}
-- 
1.7.0.4

