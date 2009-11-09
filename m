Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:10530 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755682AbZKIXrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 18:47:22 -0500
Received: by ey-out-2122.google.com with SMTP id 4so87857eyf.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 15:47:27 -0800 (PST)
From: Rui Paulo <rpaulo@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Rui Paulo <rpaulo@gmail.com>,
	Javier Cardona <javier@cozybit.com>
Subject: [PATCH v2 10/20] mac80211: improve peer link management debugging
Date: Mon,  9 Nov 2009 23:46:48 +0000
Message-Id: <1257810418-30075-11-git-send-email-rpaulo@gmail.com>
In-Reply-To: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
References: <1257810418-30075-1-git-send-email-rpaulo@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Print the FSM state strings instead of just the numbers.

Signed-off-by: Rui Paulo <rpaulo@gmail.com>
Signed-off-by: Javier Cardona <javier@cozybit.com>
Reviewed-by: Andrey Yurovsky <andrey@cozybit.com>
Tested-by: Brian Cavagnolo <brian@cozybit.com>
---
 net/mac80211/mesh_plink.c |   15 +++++++++++++--
 1 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 8a54bc8..cf12f61 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -398,6 +398,17 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 	u8 ie_len;
 	u8 *baseaddr;
 	__le16 plid, llid, reason;
+#ifdef CONFIG_MAC80211_VERBOSE_MPL_DEBUG
+	static const char *mplstates[] = {
+		[PLINK_LISTEN] = "LISTEN",
+		[PLINK_OPN_SNT] = "OPN-SNT",
+		[PLINK_OPN_RCVD] = "OPN-RCVD",
+		[PLINK_CNF_RCVD] = "CNF_RCVD",
+		[PLINK_ESTAB] = "ESTAB",
+		[PLINK_HOLDING] = "HOLDING",
+		[PLINK_BLOCKED] = "BLOCKED"
+	};
+#endif
 
 	/* need action_code, aux */
 	if (len < IEEE80211_MIN_ACTION_SIZE + 3)
@@ -536,8 +547,8 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 		}
 	}
 
-	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %d %d %d %d\n",
-		mgmt->sa, sta->plink_state,
+	mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
+		mgmt->sa, mplstates[sta->plink_state],
 		le16_to_cpu(sta->llid), le16_to_cpu(sta->plid),
 		event);
 	reason = 0;
-- 
1.5.6.5

