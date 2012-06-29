Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:60114 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754579Ab2F2N0m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jun 2012 09:26:42 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.co, franzschrober@yahoo.de,
	julian.calaby@gmail.com, johannes@sipsolutions.net,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH v2] mac80211: correct size the argument to kzalloc in minstrel_ht
Date: Fri, 29 Jun 2012 06:26:27 -0700
Message-Id: <1340976387-80206-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120629_152645_382251_B8A9837F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

msp has type struct minstrel_ht_sta_priv not struct minstrel_ht_sta.

Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
Use suggested coding style. Thx to Schrober.
---
 net/mac80211/rc80211_minstrel_ht.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d1acc6..1ca8f2b 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -809,11 +809,11 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 			max_rates = sband->n_bitrates;
 	}
 
-	msp = kzalloc(sizeof(struct minstrel_ht_sta), gfp);
+	msp = kzalloc(sizeof(*msp), gfp);
 	if (!msp)
 		return NULL;
 
-	msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
+	msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);
 	if (!msp->ratelist)
 		goto error;
 
-- 
1.7.10.4

