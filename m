Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63957 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab2EAKBp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 06:01:45 -0400
Received: by wgbdr13 with SMTP id dr13so1341341wgb.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 03:01:44 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, distro11s@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211_hwsim: Fix rate control by correctly reporting transmission counts
Date: Tue,  1 May 2012 03:01:28 -0700
Message-Id: <1335866488-23244-1-git-send-email-javier@cozybit.com> (sfid-20120501_120149_481306_16C4204B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Drivers need to report the number of transmission attempts for each rate
as well as to terminate the rate array with -1.  The in-kernel datapath
of hwsim simulates a perfect medium, therefore the driver only needs to
report that the first transmission attempt was sucessfully completed at
the most favorable rate.

Rate control is working again for this driver.  Tested mesh mode with
minstrel.

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3edd473..840cd53 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -741,6 +741,11 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		hwsim_check_sta_magic(txi->control.sta);
 
 	ieee80211_tx_info_clear_status(txi);
+
+	/* frame was transmitted at most favorable rate at first attempt */
+	txi->control.rates[0].count = 1;
+	txi->control.rates[1].idx = -1;
+
 	if (!(txi->flags & IEEE80211_TX_CTL_NO_ACK) && ack)
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	ieee80211_tx_status_irqsafe(hw, skb);
-- 
1.7.5.4

