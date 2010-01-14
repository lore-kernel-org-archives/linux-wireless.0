Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:37762 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab0ANS1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2010 13:27:49 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v3] cfg80211: Ingore country IEs with a zero set of number of channels
Date: Thu, 14 Jan 2010 13:27:46 -0500
Message-Id: <1263493666-16641-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Previous to this and the last patch, titled,

"cfg80211: Fix 2 GHz subband calculation for country IEs"

we would end up treating these IEs as single channel units. These are in
fact just bogus IE triplets so ignore the entire IE if these are found.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

v3 Removes an extra tab on the second hunk.. sorry about that.

 net/wireless/reg.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f0859ea..5b03ca7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -585,6 +585,9 @@ static int max_subband_chan(int orig_cur_chan,
 			break;
 		}
 
+		if (triplet->chans.num_channels == 0)
+			return 0;
+
 		/* Monitonically increasing channel order */
 		if (triplet->chans.first_channel <= end_subband_chan)
 			return 0;
@@ -737,6 +740,9 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 			break;
 		}
 
+		if (triplet->chans.num_channels == 0)
+			return NULL;
+
 		/* 2 GHz */
 		if (triplet->chans.first_channel <= 14)
 			end_channel = triplet->chans.first_channel +
-- 
1.6.3.3

