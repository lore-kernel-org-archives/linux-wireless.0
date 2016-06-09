Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:36288 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161701AbcFIFgk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 01:36:40 -0400
From: Prasun Maiti <prasunmaiti87@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Prasun Maiti <prasunmaii87@gmail.com>
Subject: [PATCH] Add .set_antenna callback in ath6kl driver to fix wireless core warns
Date: Thu,  9 Jun 2016 11:06:31 +0530
Message-Id: <1465450591-23543-1-git-send-email-prasunmaiti87@gmail.com> (sfid-20160609_073700_555858_D064B679)
In-Reply-To: <CAGRGNgV4sL2TypkR+zsaDHN26KCF0kjtWPsi9y9D_JkGpvWrUw@mail.gmail.com>
References: <CAGRGNgV4sL2TypkR+zsaDHN26KCF0kjtWPsi9y9D_JkGpvWrUw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since add more warnings for inconsistent ops in cfg80211, the wireless
core warns if a driver implements a cfg80211 callback but doesn't
implements the inverse operation. The ath6kl driver implements a cfg80211
.get_antenna operation handler but doesn't have the inverse .set_antenna
callback. So, it makes warning.

To remove this warning, add .set_antenna callback in ath6kl driver which
is unimplemented.

Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 4e11ba0..e638296 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -3231,6 +3231,16 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 					wait, buf, len, no_cck);
 }
 
+static int ath6kl_set_antenna(struct wiphy *wiphy,
+				u32 tx_ant, u32 rx_ant)
+{
+	/*
+	 * Note: This callback should be implement when firmware support this
+	 * command.
+	 */
+	return 0;
+}
+
 static int ath6kl_get_antenna(struct wiphy *wiphy,
 			      u32 *tx_ant, u32 *rx_ant)
 {
@@ -3456,6 +3466,7 @@ static struct cfg80211_ops ath6kl_cfg80211_ops = {
 	.cancel_remain_on_channel = ath6kl_cancel_remain_on_channel,
 	.mgmt_tx = ath6kl_mgmt_tx,
 	.mgmt_frame_register = ath6kl_mgmt_frame_register,
+	.set_antenna = ath6kl_set_antenna,
 	.get_antenna = ath6kl_get_antenna,
 	.sched_scan_start = ath6kl_cfg80211_sscan_start,
 	.sched_scan_stop = ath6kl_cfg80211_sscan_stop,
-- 
1.9.1

