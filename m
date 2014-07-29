Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:60067 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaG2Ggm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2014 02:36:42 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so2047269pab.5
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 23:36:42 -0700 (PDT)
From: Denton Gentry <denton.gentry@gmail.com>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Cc: Denton Gentry <denton.gentry@gmail.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix start_seq_num in Rx reorder offload
Date: Mon, 28 Jul 2014 23:36:32 -0700
Message-Id: <1406615792-1899-1-git-send-email-denton.gentry@gmail.com> (sfid-20140729_083646_259966_121DE7E1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sta->last_seq_ctrl is the seq_ctrl field from the last header
seen, need to shift it 4 bits to extract the sequence number.
Otherwise the ieee80211_sn_less() check at the top of
ieee80211_sta_manage_reorder_buf drops frames until the sequence
number catches up.

Cc: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Denton Gentry <denton.gentry@gmail.com>
---
 net/mac80211/iface.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7e5afaa..7434ffe 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1195,8 +1195,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 			if (sta) {
 				u16 last_seq;
 
-				last_seq = le16_to_cpu(
-					sta->last_seq_ctrl[rx_agg->tid]);
+				last_seq = IEEE80211_SEQ_TO_SN(le16_to_cpu(
+					sta->last_seq_ctrl[rx_agg->tid]));
 
 				__ieee80211_start_rx_ba_session(sta,
 						0, 0,
-- 
2.0.0.526.g5318336

