Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:47387 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275Ab3GaIzX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 04:55:23 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 2/5] ath10k: make sure to use passive scan when n_ssids is 0
Date: Wed, 31 Jul 2013 10:55:12 +0200
Message-ID: <1375260915-22500-3-git-send-email-michal.kazior@tieto.com> (sfid-20130731_105541_001183_95C4606F)
In-Reply-To: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
References: <1375260915-22500-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Normally user specifies broadcast ssid for
scanning. If the user wants to do a passive scan
it does not pass any ssids.

The patch makes sure we ath10k tells firmware to
not send anything at all in case it decides no
ssids equals broadcast ssid.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/mac.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 344ad27..1ea386e 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2338,6 +2338,8 @@ static int ath10k_hw_scan(struct ieee80211_hw *hw,
 			arg.ssids[i].len  = req->ssids[i].ssid_len;
 			arg.ssids[i].ssid = req->ssids[i].ssid;
 		}
+	} else {
+		arg.scan_ctrl_flags |= WMI_SCAN_FLAG_PASSIVE;
 	}
 
 	if (req->n_channels) {
-- 
1.7.9.5

