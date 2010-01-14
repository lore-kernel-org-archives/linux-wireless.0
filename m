Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40557 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754367Ab0ANRXV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 12:23:21 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] cfg80211: Ingore country IEs with a zero set of number of channels
Date: Thu, 14 Jan 2010 12:23:15 -0500
Message-Id: <1263489795-3515-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous to this and the last patch, titled,

"cfg80211: Fix 2 GHz subband calculation for country IEs"

we would end up treating these IEs as single channel units. These are in
fact just bogus IE triplets so ignore the entire IE if these are found.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f0859ea..951d8c7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -737,6 +737,9 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			break;
 		}
 
+		if (triplet->chans.num_channels == 0)
+				return NULL;
+
 		/* 2 GHz */
 		if (triplet->chans.first_channel <= 14)
 			end_channel = triplet->chans.first_channel +
-- 
1.6.3.3

