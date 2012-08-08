Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:40188 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755879Ab2HHMAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 08:00:48 -0400
Received: by ggmb6 with SMTP id b6so725226ggm.40
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 05:00:47 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v3 7/7] mac80211: add DFS support to monitor interface
Date: Wed,  8 Aug 2012 14:53:43 +0300
Message-Id: <1344426823-1795-8-git-send-email-victorg@ti.com> (sfid-20120808_140053_992647_C2674B49)
In-Reply-To: <1344426823-1795-1-git-send-email-victorg@ti.com>
References: <1344426823-1795-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode uses monitor interfaces to transmit
management frames which were blocked for "radar
channels" until now.

Stop dropping packets if we are on 'radar channel'
and the DFS is enabled.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/tx.c |   13 +++++++------
 1 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index acf712f..d1b6f9a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1583,6 +1583,7 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
 	u16 len_rthdr;
 	int hdrlen;
+	bool dfs_supported = (local->hw.wiphy->features & NL80211_FEATURE_DFS);
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1595,13 +1596,13 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	 * flag.
 	 *
 	 * Since AP mode uses monitor interfaces to inject/TX management
-	 * frames we can make AP mode the exception to this rule once it
-	 * supports radar detection as its implementation can deal with
-	 * radar detection by itself. We can do that later by adding a
-	 * monitor flag interfaces used for AP support.
+	 * frames we can make AP mode the exception to this rule, in the
+	 * case the driver supports radar detection, allow usage of radar
+	 * channels.
 	 */
-	if ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
-	     IEEE80211_CHAN_PASSIVE_SCAN)))
+	if ((!(chan->flags & IEEE80211_CHAN_RADAR) || !dfs_supported) &&
+	    ((chan->flags & (IEEE80211_CHAN_NO_IBSS | IEEE80211_CHAN_RADAR |
+			     IEEE80211_CHAN_PASSIVE_SCAN))))
 		goto fail;
 
 	/* check for not even having the fixed radiotap header part */
-- 
1.7.5.4

