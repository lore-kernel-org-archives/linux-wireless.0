Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from multi.imgtec.com ([194.200.65.239]:51631 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab3LZNmZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Dec 2013 08:42:25 -0500
From: Chaitanya Tata <Chaitanya.Tata@imgtec.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"chaitanya.mgit@gmail.com" <chaitanya.mgit@gmail.com>
Subject: [PATCH] mac80211: Return untuned timestamp in case of invalid
 bitrates
Date: Thu, 26 Dec 2013 13:42:20 +0000
Message-ID: <82A67CC48AF04D43A69EB66645975134107C6285@hbmail01.hb.imgtec.org> (sfid-20131226_144228_645532_DC629EE0)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case the driver sends MCS9 and doesn't advertise CBW
(or) advertises 20MHz bandwidth, return the timestamp As is, 
instead of returning 0 as timestamp.

Signed-off-by: Chaitanya T K <Chaitanya.mgit@gmail.com>
---
net/mac80211/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c index 06265d7..bc92b25 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2265,7 +2265,7 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 	if (WARN_ONCE(!rate,
 		      "Invalid bitrate: flags=0x%x, idx=%d, vht_nss=%d\n",
 		      status->flag, status->rate_idx, status->vht_nss))
-		return 0;
+		return ts;
 
 	/* rewind from end of MPDU */
 	if (status->flag & RX_FLAG_MACTIME_END)



