Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60897 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab2AILxK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jan 2012 06:53:10 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [RFC] mac80211: clear monitoring flag at connection reset
Date: Mon, 9 Jan 2012 17:20:45 +0530
Message-ID: <1326109845-7239-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120109_125317_433541_517D341F)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The connection monitoring probe will be postponded on receiving
tx ack status whereas the connection probe flag is not cleared.
On an idle state, when we start sending probing frame, there
is a posibility to miss the first probing frame. So lets clear
the flag also during connection probe reset.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 net/mac80211/mlme.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index ecb4c84..1f416a0 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -148,6 +148,7 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
 
 	ifmgd->probe_send_count = 0;
+	ifmgd->flags &= ~IEEE80211_STA_CONNECTION_POLL;
 }
 
 static int ecw2cw(int ecw)
-- 
1.7.8.3

