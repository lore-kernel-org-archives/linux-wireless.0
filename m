Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:47864 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751141Ab2GBMkD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jul 2012 08:40:03 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: dan.carpenter@oracle.com, wfg@linux.intel.com,
	linux-wireless@vger.kernel.org, franzschrober@yahoo.de,
	julian.calaby@gmail.com, johannes@sipsolutions.net,
	thomas@net.t-labs.tu-berlin.de, nbd@openwrt.org
Subject: [PATCH] mac80211: fix kzalloc memory corruption introduced in minstrel_ht
Date: Mon,  2 Jul 2012 14:39:52 +0200
Message-Id: <1341232792-6247-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20120702_144008_138760_7D990196)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch: "mac80211: correct size the argument to
kzalloc in minstrel_ht" (from Jun 29, 2012), leads to memory corruption.
"msp->ratelist" is a void pointer - therfore going back to the
expicit form: sizeof(struct minstrel_rate) which brings back correct
memory allocation.

Reported-by: Fengguang Wu <wfg@linux.intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
---
 net/mac80211/rc80211_minstrel_ht.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 1ca8f2b..f9e51ef 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -813,7 +813,7 @@ minstrel_ht_alloc_sta(void *priv, struct ieee80211_sta *sta, gfp_t gfp)
 	if (!msp)
 		return NULL;
 
-	msp->ratelist = kzalloc(sizeof(*msp->ratelist) * max_rates, gfp);
+	msp->ratelist = kzalloc(sizeof(struct minstrel_rate) * max_rates, gfp);
 	if (!msp->ratelist)
 		goto error;
 
-- 
1.7.10.4

