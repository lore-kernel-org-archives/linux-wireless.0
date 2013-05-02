Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12097 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3EBIna (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 May 2013 04:43:30 -0400
Date: Thu, 2 May 2013 09:43:57 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@venema.h4ckr.net
Subject: [PATCH] ath5k: do not reschedule tx_complete_work on stop
Message-ID: <20130502074357.GA11092@redhat.com> (sfid-20130502_104335_666570_F4CDD03E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch claim to fix "WARNING: at net/mac80211/util.c:599
ieee80211_can_queue_work.isra.7+0x30/0x40", which was reported at:

https://bugzilla.redhat.com/show_bug.cgi?id=922295

We use ATH_STAT_STARTED flag to disallow to perform
ath5k_tx_complete_poll_work() code, hence reschedule
ah->tx_complete_work, when we stop device. This flag was defined in
ath5k code, but it was not used.

I didn't get feedback if the fix works, so patch is compile only tested.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 30ca0a6..9c1f742 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2368,6 +2368,9 @@ ath5k_tx_complete_poll_work(struct work_struct *work)
 	int i;
 	bool needreset = false;
 
+	if (!test_bit(ATH_STAT_STARTED, ah->status))
+		return;
+
 	mutex_lock(&ah->lock);
 
 	for (i = 0; i < ARRAY_SIZE(ah->txqs); i++) {
@@ -2675,6 +2678,7 @@ done:
 	mmiowb();
 	mutex_unlock(&ah->lock);
 
+	set_bit(ATH_STAT_STARTED, ah->status);
 	ieee80211_queue_delayed_work(ah->hw, &ah->tx_complete_work,
 			msecs_to_jiffies(ATH5K_TX_COMPLETE_POLL_INT));
 
@@ -2736,6 +2740,7 @@ void ath5k_stop(struct ieee80211_hw *hw)
 
 	ath5k_stop_tasklets(ah);
 
+	clear_bit(ATH_STAT_STARTED, ah->status);
 	cancel_delayed_work_sync(&ah->tx_complete_work);
 
 	if (!ath5k_modparam_no_hw_rfkill_switch)
-- 
1.7.1

