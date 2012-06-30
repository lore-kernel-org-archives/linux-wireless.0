Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:38082 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750819Ab2F3Tzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 15:55:37 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.co
Cc: wfg@linux.intel.com, linux-wireless@vger.kernel.org,
	franzschrober@yahoo.de, julian.calaby@gmail.com,
	johannes@sipsolutions.net, thomas@net.t-labs.tu-berlin.de,
	nbd@openwrt.org
Subject: [PATCH v3] mac80211: correct size the argument to kzalloc in minstrel_ht
Date: Sat, 30 Jun 2012 21:55:26 +0200
Message-Id: <1341086126-99685-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120630_215615_724610_BE5513A9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
Use suggested coding style. Thx to Schrober.
Correct an error reported in sane. Thx to Fengguang Wu.
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..f9e51ef 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -809,7 +809,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 			max_rates = sband->n_bitrates;
 	}
 
-	msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
+	msp = kzalloc(sizeof(*msp), gfp);
 	if (!msp)
 		return NULL;
 
-- 
1.7.10.4

