Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42280 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212AbYKGUbR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 15:31:17 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Berg <johannes@sipsolutions.net>, stable@kernel.org
Subject: [PATCH] mac80211: avoid possible buffer overrun in sta_agg_status_write
Date: Fri,  7 Nov 2008 15:26:59 -0500
Message-Id: <1226089619-726-1-git-send-email-linville@tuxdriver.com> (sfid-20081107_213122_183832_EE35D3B4)
In-Reply-To: <>
References: <>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This addresses the bug report here:

	http://bugzilla.kernel.org/show_bug.cgi?id=3D11975

Reported-by: Daniel Marjam=C3=A4ki <danielm77@spray.se>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/debugfs_sta.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/debugfs_sta.c b/net/mac80211/debugfs_sta.c
index 189d0ba..2e6752a 100644
--- a/net/mac80211/debugfs_sta.c
+++ b/net/mac80211/debugfs_sta.c
@@ -184,7 +184,6 @@ static ssize_t sta_agg_status_write(struct file *fi=
le,
 	char buf[32];
 	int buf_size, rs;
 	unsigned int tid_num;
-	char state[4];
=20
 	memset(buf, 0x00, sizeof(buf));
 	buf_size =3D min(count, (sizeof(buf)-1));
@@ -199,35 +198,31 @@ static ssize_t sta_agg_status_write(struct file *=
file,
 		/* toggle Rx aggregation command */
 		tid_num =3D tid_num - 100;
 		if (tid_static_rx[tid_num] =3D=3D 1) {
-			strcpy(state, "off ");
 			ieee80211_sta_stop_rx_ba_session(sta->sdata, da, tid_num, 0,
 					WLAN_REASON_QSTA_REQUIRE_SETUP);
 			sta->ampdu_mlme.tid_state_rx[tid_num] |=3D
 					HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] =3D 0;
 		} else {
-			strcpy(state, "on ");
 			sta->ampdu_mlme.tid_state_rx[tid_num] &=3D
 					~HT_AGG_STATE_DEBUGFS_CTL;
 			tid_static_rx[tid_num] =3D 1;
 		}
 		printk(KERN_DEBUG "debugfs - try switching tid %u %s\n",
-				tid_num, state);
+				tid_num, tid_static_rx[tid_num] ? "on" : "off");
 	} else if ((tid_num >=3D 0) && (tid_num <=3D 15)) {
 		/* toggle Tx aggregation command */
 		if (tid_static_tx[tid_num] =3D=3D 0) {
-			strcpy(state, "on ");
 			rs =3D  ieee80211_start_tx_ba_session(hw, da, tid_num);
 			if (rs =3D=3D 0)
 				tid_static_tx[tid_num] =3D 1;
 		} else {
-			strcpy(state, "off");
 			rs =3D  ieee80211_stop_tx_ba_session(hw, da, tid_num, 1);
 			if (rs =3D=3D 0)
 				tid_static_tx[tid_num] =3D 0;
 		}
 		printk(KERN_DEBUG "debugfs - switching tid %u %s, return=3D%d\n",
-				tid_num, state, rs);
+				tid_num, tid_static_tx[tid_num] ? "on" : "off", rs);
 	}
=20
 	return count;
--=20
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
