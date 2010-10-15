Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15877 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0JOU15 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 16:27:57 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 13:27:47 -0700
Date: Fri, 15 Oct 2010 13:27:49 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: fix sparse complaint on aphy for debugfs
Message-ID: <20101015202749.GM30740@tux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes this sparse complaint:

  CHECK   drivers/net/wireless/ath/ath9k/debug.c
drivers/net/wireless/ath/ath9k/debug.c:548:34: warning: symbol 'aphy' shadows an earlier one
drivers/net/wireless/ath/ath9k/debug.c:491:26: originally declared here

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 74a4570..778d06b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -545,16 +545,16 @@ static ssize_t read_file_wiphy(struct file *file, char __user *user_buf,
 
 	/* Put variable-length stuff down here, and check for overflows. */
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
-		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-		if (aphy == NULL)
+		struct ath_wiphy *aphy_tmp = sc->sec_wiphy[i];
+		if (aphy_tmp == NULL)
 			continue;
-		chan = aphy->hw->conf.channel;
+		chan = aphy_tmp->hw->conf.channel;
 		len += snprintf(buf + len, sizeof(buf) - len,
 			"secondary: %s (%s chan=%d ht=%d)\n",
-			wiphy_name(aphy->hw->wiphy),
-			ath_wiphy_state_str(aphy->state),
+			wiphy_name(aphy_tmp->hw->wiphy),
+			ath_wiphy_state_str(aphy_tmp->state),
 			ieee80211_frequency_to_channel(chan->center_freq),
-			aphy->chan_is_ht);
+						       aphy_tmp->chan_is_ht);
 	}
 	if (len > sizeof(buf))
 		len = sizeof(buf);
-- 
1.7.0.4

