Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39558 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752822Ab0AGWZE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 17:25:04 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for country IEs
Date: Thu,  7 Jan 2010 17:24:55 -0500
Message-Id: <1262903097-2129-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Country IEs triplets are getting an extra channel with
the current count. This does not affect regulatory because
we always took the intersection between what the AP gave
and what CRDA believed is correct.

This however does fix processing some Country IEs with multiple
sequential 2 GHz triplets. Since our parser and the spec mandates
all channels be monitonically increasing we would drop the IE after
noticing the second triplet begins on a channel already processed.
APs that send these type of country IEs seems rare though.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 389247c..7223a7a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -555,7 +555,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		/* 2 GHz */
 		if (triplet->chans.first_channel <= 14)
 			end_channel = triplet->chans.first_channel +
-				triplet->chans.num_channels;
+				triplet->chans.num_channels - 1;
 		else
 			/*
 			 * 5 GHz -- For example in country IEs if the first
@@ -655,7 +655,7 @@ static struct ieee80211_regdomain *country_ie_2_rd(
 		/* 2 GHz */
 		if (triplet->chans.first_channel <= 14)
 			end_channel = triplet->chans.first_channel +
-				triplet->chans.num_channels;
+				triplet->chans.num_channels -1;
 		else
 			end_channel =  triplet->chans.first_channel +
 				(4 * (triplet->chans.num_channels - 1));
-- 
1.6.3.3

