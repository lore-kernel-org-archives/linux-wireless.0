Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:63350 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730Ab0KSBS5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 20:18:57 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 17:18:44 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [RFC] mac80211: disable aggregatin for voice traffic
Date: Thu, 18 Nov 2010 17:18:54 -0800
Message-ID: <1290129534-21785-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should help with latency issues which can happen when
using aggregation.

Cc: Matt Smith <matt.smith@atheros.com>
Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

We discussed this a while ago but never to around to it.

 net/mac80211/tx.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e694836..405ddc9 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1225,7 +1225,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 		tx->sta = sta_info_get(sdata, hdr->addr1);
 
 	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
-	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
+	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
+	    (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {
 		struct tid_ampdu_tx *tid_tx;
 
 		qc = ieee80211_get_qos_ctl(hdr);
-- 
1.7.3.2.90.gd4c43

