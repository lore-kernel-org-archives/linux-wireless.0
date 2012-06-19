Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog134.obsmtp.com ([74.125.149.83]:52810 "EHLO
	na3sys009aog134.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab2FSNOv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 09:14:51 -0400
Received: by obcva7 with SMTP id va7so2286772obc.34
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 06:14:50 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>, <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: [PATCH v2 7/7] mac80211: add DFS support to monitor interface
Date: Tue, 19 Jun 2012 16:11:03 +0300
Message-Id: <1340111463-4554-7-git-send-email-victorg@ti.com> (sfid-20120619_151454_179258_C0E46355)
In-Reply-To: <1340111463-4554-1-git-send-email-victorg@ti.com>
References: <1340111463-4554-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AP mode uses monitor interfaces to transmit
management frames which were blocked for "radar
channels" until now.

Stop dropping packets if we are on 'radar channel'
and the DFS is enabled.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/tx.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e453212..8c7f365 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1595,6 +1595,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
 	u16 len_rthdr;
 	int hdrlen;
+	bool dfs_supported = !!(local->hw.wiphy->features &
+				NL80211_FEATURE_DFS);
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1607,13 +1609,13 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
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

