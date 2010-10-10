Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:53306 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab0JJUOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Oct 2010 16:14:22 -0400
Received: by ewy20 with SMTP id 20so334443ewy.19
        for <linux-wireless@vger.kernel.org>; Sun, 10 Oct 2010 13:14:21 -0700 (PDT)
Date: Sun, 10 Oct 2010 22:14:25 +0200 (CEST)
From: "=?ISO-8859-15?Q?Bj=F6rn_Smedman?=" <bjorn.smedman@venatech.se>
To: linville@tuxdriver.com, johannes@sipsolutions.net,
	lrodriguez@atheros.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: minstrel_ht A-MPDU fix
Message-ID: <alpine.DEB.2.00.1010102206580.31264@bigbill>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1482533735-1286741667=:31264"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1482533735-1286741667=:31264
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

This patch fixes two problems with the minstrel_ht rate control
algorithms handling of A-MPDU frames:

1. The ampdu_len field of the tx status is not always initialized for 
non-HT frames (and it would probably be unreasonable to require all 
drivers to do so). This could cause rate control statistics to be 
corrupted. We now trust the ampdu_len and ampdu_ack_len fields only when 
the frame is marked with the IEEE80211_TX_STAT_AMPDU flag.

2. Successful transmission attempts where only recognized when the A-MPDU
subframe carrying the rate control status information was marked with the
IEEE80211_TX_STAT_ACK flag. If this information happed to be carried on a
frame that failed to be ACKed then the other subframes (which may have
succeeded) where not correctly registered. We now update rate control
statistics regardless of whether the subframe carrying the information was
ACKed or not.

Cc: <stable@kernel.org>
Signed-off-by: Björn Smedman <bjorn.smedman@venatech.se>
---
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index c5b4659..2a18d66 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -397,8 +397,9 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 	    !(info->flags & IEEE80211_TX_STAT_AMPDU))
 		return;
 
-	if (!info->status.ampdu_len) {
-		info->status.ampdu_ack_len = 1;
+	if (!(info->flags & IEEE80211_TX_STAT_AMPDU)) {
+		info->status.ampdu_ack_len =
+			(info->flags & IEEE80211_TX_STAT_ACK ? 1 : 0);
 		info->status.ampdu_len = 1;
 	}
 
@@ -426,7 +427,7 @@ minstrel_ht_tx_status(void *priv, struct ieee80211_supported_band *sband,
 		group = minstrel_ht_get_group_idx(&ar[i]);
 		rate = &mi->groups[group].rates[ar[i].idx % 8];
 
-		if (last && (info->flags & IEEE80211_TX_STAT_ACK))
+		if (last)
 			rate->success += info->status.ampdu_ack_len;
 
 		rate->attempts += ar[i].count * info->status.ampdu_len;
--8323329-1482533735-1286741667=:31264--
