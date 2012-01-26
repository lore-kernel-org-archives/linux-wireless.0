Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:58508 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751539Ab2AZMj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:56 -0500
Received: by yenm10 with SMTP id m10so205981yen.0
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:55 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 9/9] mac80211: add DFS support to monitor interface
Date: Thu, 26 Jan 2012 14:38:04 +0200
Message-Id: <1327581484-22047-10-git-send-email-victorg@ti.com> (sfid-20120126_133959_899850_0DA830C1)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stop dropping packets if we are on 'radar channel'
and the DFS is enabled/supported.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 net/mac80211/tx.c |   15 +++++++++------
 1 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index edcd1c7..2c728a4 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1569,6 +1569,8 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
 	struct ieee80211_sub_if_data *tmp_sdata, *sdata;
 	u16 len_rthdr;
 	int hdrlen;
+	bool dfs_supported = !!(local->hw.wiphy->flags &
+				WIPHY_FLAG_SUPPORTS_DFS);
 
 	/*
 	 * Frame injection is not allowed if beaconing is not allowed
@@ -1581,15 +1583,16 @@ netdev_tx_t ieee80211_monitor_start_xmit(struct sk_buff *skb,
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
+	    IEEE80211_CHAN_PASSIVE_SCAN))))
 		goto fail;
 
+
 	/* check for not even having the fixed radiotap header part */
 	if (unlikely(skb->len < sizeof(struct ieee80211_radiotap_header)))
 		goto fail; /* too short to be possibly valid */
-- 
1.7.5.4

