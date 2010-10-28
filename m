Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:18365 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758691Ab0J1OVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 10:21:54 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 28 Oct 2010 07:21:43 -0700
From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <lrodriguez@atheros.com>,
	<stable@kernel.org>,
	Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Subject: [PATCH v2] ath9k: Fix incorrect access of rate flags in RC
Date: Thu, 28 Oct 2010 19:51:47 +0530
Message-ID: <1288275707-10904-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

The index variable to access the rate flags should be obtained from the
inner loop counter which corresponds to the rate table structure.This
fixes the invalid rate selection i.e when the supported basic rate is
invalid on a particular band and also the following warning message.
Thanks to Raj for finding this out.

Call Trace:

 [<ffffffff8104ee4a>] warn_slowpath_common+0x7a/0xb0

 [<ffffffff8104ee95>] warn_slowpath_null+0x15/0x20

 [<ffffffffa0583c45>] ath_get_rate+0x595/0x5b0 [ath9k]

 [<ffffffff811a0636>] ? cpumask_next_and+0x36/0x50

 [<ffffffffa0405186>] rate_control_get_rate+0x86/0x160 [mac80211]

 [<ffffffffa040dfac>] invoke_tx_handlers+0x81c/0x12d0 [mac80211]

 [<ffffffffa040eae9>] ieee80211_tx+0x89/0x2b0 [mac80211]

 [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0

 [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]

 [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]

 [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]

 [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150
[mac80211]

 [<ffffffff812891bc>] ? pskb_expand_head+0x1cc/0x1f0

 [<ffffffffa040edc5>] ieee80211_xmit+0xb5/0x1c0 [mac80211]

 [<ffffffffa041026f>] ieee80211_tx_skb+0x4f/0x60 [mac80211]

 [<ffffffffa03fe016>] ieee80211_send_nullfunc+0x46/0x60 [mac80211]

 [<ffffffffa03f91d7>] ieee80211_offchannel_stop_station+0x107/0x150
[mac80211]

 [<ffffffffa03f8896>] ieee80211_scan_work+0x146/0x600 [mac80211]

 [<ffffffff8133a375>] ? schedule+0x2f5/0x8e0

 [<ffffffffa03f8750>] ? ieee80211_scan_work+0x0/0x600 [mac80211]

 [<ffffffff81064fcf>] process_one_work+0x10f/0x380

 [<ffffffff81066bc2>] worker_thread+0x162/0x340

 [<ffffffff81066a60>] ? worker_thread+0x0/0x340

Cc: stable@kernel.org
Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/rc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 0cee90c..89978d7 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -527,7 +527,7 @@ static u8 ath_rc_setvalid_rates(struct ath_rate_priv *ath_rc_priv,
 	for (i = 0; i < rateset->rs_nrates; i++) {
 		for (j = 0; j < rate_table->rate_cnt; j++) {
 			u32 phy = rate_table->info[j].phy;
-			u16 rate_flags = rate_table->info[i].rate_flags;
+			u16 rate_flags = rate_table->info[j].rate_flags;
 			u8 rate = rateset->rs_rates[i];
 			u8 dot11rate = rate_table->info[j].dot11rate;
 
-- 
1.7.0.4

