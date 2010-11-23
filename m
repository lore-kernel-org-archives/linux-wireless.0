Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:60498 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932444Ab0KWBXL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Nov 2010 20:23:11 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Nov 2010 17:22:58 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 3/3] mac80211: avoid aggregation for VO traffic
Date: Mon, 22 Nov 2010 17:23:03 -0800
Message-ID: <1290475383-26911-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
References: <1290475383-26911-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should help with latency issues which can happen when
using aggregation.

Cc: Felix Fietkau <nbd@openwrt.org>
Cc: Matt Smith <matt.smith@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/mac80211/rc80211_minstrel_ht.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/rc80211_minstrel_ht.c b/net/mac80211/rc80211_minstrel_ht.c
index 2d6f025..84b13b0 100644
--- a/net/mac80211/rc80211_minstrel_ht.c
+++ b/net/mac80211/rc80211_minstrel_ht.c
@@ -371,6 +371,9 @@ minstrel_aggr_check(struct minstrel_priv *mp, struct ieee80211_sta *pubsta, stru
 	if (likely(sta->ampdu_mlme.tid_tx[tid]))
 		return;
 
+	if (ieee802_1d_to_ac[skb->priority] == IEEE80211_AC_VO)
+		return;
+
 	ieee80211_start_tx_ba_session(pubsta, tid);
 }
 
-- 
1.7.3.2.90.gd4c43

