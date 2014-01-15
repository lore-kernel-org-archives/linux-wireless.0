Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:58626 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaAOQLt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 11:11:49 -0500
Received: from ultralex.lan ([93.218.75.192]) by mail.gmx.com (mrgmx002) with
 ESMTPSA (Nemesis) id 0Lq9se-1VPiTL2tW4-00dkCw for
 <linux-wireless@vger.kernel.org>; Wed, 15 Jan 2014 17:11:47 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath5k-devel@lists.ath5k.org
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 5/5] carl9170: use ath_is_mybeacon
Date: Wed, 15 Jan 2014 17:11:39 +0100
Message-Id: <1389802299-7048-1-git-send-email-linux@rempel-privat.de> (sfid-20140115_171151_637033_564D906B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>
---
 drivers/net/wireless/ath/carl9170/rx.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
index 1b1b207..536bc46a 100644
--- a/drivers/net/wireless/ath/carl9170/rx.c
+++ b/drivers/net/wireless/ath/carl9170/rx.c
@@ -519,6 +519,7 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 {
 	struct ieee80211_hdr *hdr = data;
 	struct ieee80211_tim_ie *tim_ie;
+	struct ath_common *common = &ar->common;
 	u8 *tim;
 	u8 tim_len;
 	bool cam;
@@ -526,17 +527,13 @@ static void carl9170_ps_beacon(struct ar9170 *ar, void *data, unsigned int len)
 	if (likely(!(ar->hw->conf.flags & IEEE80211_CONF_PS)))
 		return;
 
-	/* check if this really is a beacon */
-	if (!ieee80211_is_beacon(hdr->frame_control))
-		return;
-
 	/* min. beacon length + FCS_LEN */
 	if (len <= 40 + FCS_LEN)
 		return;
 
+	/* check if this really is a beacon */
 	/* and only beacons from the associated BSSID, please */
-	if (!ether_addr_equal_64bits(hdr->addr3, ar->common.curbssid) ||
-	    !ar->common.curaid)
+	if (!ath_is_mybeacon(common, hdr) || !common->curaid)
 		return;
 
 	ar->ps.last_beacon = jiffies;
-- 
1.8.5.2

