Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62832 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbcDGGmb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 02:42:31 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>,
	<stable@vger.kernel.org>
Subject: [PATCH] ath10k: fix rx_channel during hw reconfigure
Date: Thu, 7 Apr 2016 12:11:54 +0530
Message-ID: <1460011314-15978-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160407_084233_955345_74E0E8A2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon firmware assert, restart work will be triggered so that mac80211
will reconfigure the driver. An issue is reported that after restart
work, survey dump data do not contain in-use (SURVEY_INFO_IN_USE) info
for operating channel. During reconfigure, since mac80211 already has
valid channel context for given radio, channel context iteration return
num_chanctx > 0. Hence rx_channel is always NULL. Fix this by assigning
channel context to rx_channel when driver restart is in progress.

Cc: stable@vger.kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index b0e613bc10a5..e31469dd58dd 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -6867,7 +6867,13 @@ ath10k_mac_update_rx_channel(struct ath10k *ar,
 			def = &vifs[0].new_ctx->def;
 
 		ar->rx_channel = def->chan;
-	} else if (ctx && ath10k_mac_num_chanctxs(ar) == 0) {
+	} else if ((ctx && ath10k_mac_num_chanctxs(ar) == 0) ||
+		   (ctx && (ar->state == ATH10K_STATE_RESTARTED))) {
+		/* During driver restart due to firmware assert, since mac80211
+		 * already has valid channel context for given radio, channel
+		 * context iteration return num_chanctx > 0. So fix rx_channel
+		 * when restart is in progress.
+		 */
 		ar->rx_channel = ctx->def.chan;
 	} else {
 		ar->rx_channel = NULL;
-- 
2.7.4

