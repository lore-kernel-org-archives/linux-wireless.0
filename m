Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:59985 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbaARMyq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 07:54:46 -0500
Received: from ultralex.lan ([93.218.86.193]) by mail.gmx.com (mrgmx101) with
 ESMTPSA (Nemesis) id 0LxLcc-1VFMym2mx0-016wxx for
 <linux-wireless@vger.kernel.org>; Sat, 18 Jan 2014 13:54:44 +0100
From: Oleksij Rempel <linux@rempel-privat.de>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: Oleksij Rempel <linux@rempel-privat.de>
Subject: [PATCH 5/5] carl9170: use ath_is_mybeacon
Date: Sat, 18 Jan 2014 13:54:19 +0100
Message-Id: <1390049659-27021-6-git-send-email-linux@rempel-privat.de> (sfid-20140118_135457_535668_78DF5ED7)
In-Reply-To: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
References: <1390049659-27021-1-git-send-email-linux@rempel-privat.de>
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

