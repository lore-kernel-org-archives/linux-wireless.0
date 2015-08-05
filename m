Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33857 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbbHEKII (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 06:08:08 -0400
Received: by labow3 with SMTP id ow3so25342235lab.1
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2015 03:08:06 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] ath10k: fix hw reconfig on wow failure
Date: Wed,  5 Aug 2015 12:08:38 +0200
Message-Id: <1438769318-27373-1-git-send-email-michal.kazior@tieto.com> (sfid-20150805_120812_563536_A7C59148)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When WoWLAN resume fails with retval 1 mac80211
will attempt to reconfig the device in a similar
manner when hw restart is requested. This wasn't
handled properly and yielded call trace warnings
and the device ended up not working.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wow.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wow.c b/drivers/net/wireless/ath/ath10k/wow.c
index a68d8fd853a3..8e02b381990f 100644
--- a/drivers/net/wireless/ath/ath10k/wow.c
+++ b/drivers/net/wireless/ath/ath10k/wow.c
@@ -301,8 +301,26 @@ int ath10k_wow_op_resume(struct ieee80211_hw *hw)
 		ath10k_warn(ar, "failed to wakeup from wow: %d\n", ret);
 
 exit:
+	if (ret) {
+		switch (ar->state) {
+		case ATH10K_STATE_ON:
+			ar->state = ATH10K_STATE_RESTARTING;
+			ret = 1;
+			break;
+		case ATH10K_STATE_OFF:
+		case ATH10K_STATE_RESTARTING:
+		case ATH10K_STATE_RESTARTED:
+		case ATH10K_STATE_UTF:
+		case ATH10K_STATE_WEDGED:
+			ath10k_warn(ar, "encountered unexpected device state %d on resume, cannot recover\n",
+				    ar->state);
+			ret = -EIO;
+			break;
+		}
+	}
+
 	mutex_unlock(&ar->conf_mutex);
-	return ret ? 1 : 0;
+	return ret;
 }
 
 int ath10k_wow_init(struct ath10k *ar)
-- 
2.1.4

