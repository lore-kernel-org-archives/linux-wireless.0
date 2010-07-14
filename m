Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63214 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab0GNVnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Jul 2010 17:43:40 -0400
Received: by bwz1 with SMTP id 1so227497bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jul 2010 14:43:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] minstrel_ht: fix freeze with legacy hardware
Date: Wed, 14 Jul 2010 23:43:33 +0200
Cc: John W Linville <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007142343.33937.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ever since minstrel_ht was prompted to be the default RC,
I had an this odd freeze in ieee80211_tx_status, 
whenever I tried to connect my p54*(legacy 11abg) to
a 802.11n network.

Apparently, minstrel_ht was not interested if the hardware
supported 802.11n or not?

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
Note: There's another possible way to fix this.
We can simply AND sta's ht_supported bool with
the setting in sband's ht_supported.

The advantage is that we won't need this patch
and the procedure would "match" to what we did
with the ht_cap flags.

This is up for debate... But in the meantime,
here's a fix.

P.S.: is there a valid operation situation
where sta is be NULL, but priv_sta isn't?
---
diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index b5ace24..8ad3630 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -635,8 +635,12 @@ minstrel_ht_update_caps(void *priv, struct ieee80211_supported_band *sband,
 	int stbc;
 	int i;
 
-	/* fall back to the old minstrel for legacy stations */
-	if (sta && !sta->ht_cap.ht_supported) {
+	/*
+	 * fall back to the old minstrel for legacy stations,
+	 * or on legacy hardware.
+	 */
+	if ((sta && !sta->ht_cap.ht_supported) ||
+	    !sband->ht_cap.ht_supported) {
 		msp->is_ht = false;
 		memset(&msp->legacy, 0, sizeof(msp->legacy));
 		msp->legacy.r = msp->ratelist;
