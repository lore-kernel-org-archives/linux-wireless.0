Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40528 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1IZJnF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Sep 2011 05:43:05 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: Send nullfunc frames at lower rate
Date: Mon, 26 Sep 2011 15:13:45 +0530
Message-ID: <1317030225-3986-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110926_114309_561789_4A4B5E3E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Recently mac80211 was changed to send nullfunc instead of probe
request for connection monitoring. These nullfunc data frames
are being sent at higer rates and also as aggregated ones. This
could probably delays the nullfunc_ack so the connection is getting
disconnected as max retries reached. In order to improve the
connectivity send the nullfunc at lower rate.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/rate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index f61244c..213e1e9 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -208,7 +208,8 @@ static bool rc_no_data_or_no_ack(struct ieee80211_tx_rate_control *txrc)
 
 	fc = hdr->frame_control;
 
-	return (info->flags & IEEE80211_TX_CTL_NO_ACK) || !ieee80211_is_data(fc);
+	return (info->flags & IEEE80211_TX_CTL_NO_ACK) ||
+		!ieee80211_is_data(fc) || ieee80211_is_nullfunc(fc);
 }
 
 static void rc_send_low_broadcast(s8 *idx, u32 basic_rates,
-- 
1.7.6.4

