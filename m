Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:63157 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753150Ab3G2Ijk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 04:39:40 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 3/3] ath10k: respect chan_time parameter in scan request
Date: Mon, 29 Jul 2013 10:39:18 +0200
Message-ID: <1375087158-22077-4-git-send-email-michal.kazior@tieto.com> (sfid-20130729_103944_688024_3F2B8DE8)
In-Reply-To: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
References: <1375087158-22077-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Respect the new scan request parameter.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index da5c333..cd20a20 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2150,6 +2150,12 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 	arg.vdev_id = arvif->vdev_id;
 	arg.scan_id = ATH10K_SCAN_ID;
 
+	if (req->chan_time) {
+		arg.dwell_time_active = req->chan_time;
+		arg.dwell_time_passive = req->chan_time;
+		arg.max_scan_time = 2 * req->chan_time * req->n_channels;
+	}
+
 	if (!req->no_cck)
 		arg.scan_ctrl_flags |= WMI_SCAN_ADD_CCK_RATES;
 
-- 
1.7.9.5

