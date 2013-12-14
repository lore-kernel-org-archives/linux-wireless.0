Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48963 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab3LNRD5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Dec 2013 12:03:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 01/11] ath9k_common: get rid of an unnecessary variable
Date: Sat, 14 Dec 2013 18:03:35 +0100
Message-Id: <1387040625-38114-1-git-send-email-nbd@openwrt.org> (sfid-20131214_180404_938817_1D6DF321)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to truncate curchan->hw_value to u8

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/common.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index a7e5a05..768c733 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -98,10 +98,8 @@ struct ath9k_channel *ath9k_cmn_get_channel(struct ieee80211_hw *hw,
 {
 	struct ieee80211_channel *curchan = chandef->chan;
 	struct ath9k_channel *channel;
-	u8 chan_idx;
 
-	chan_idx = curchan->hw_value;
-	channel = &ah->channels[chan_idx];
+	channel = &ah->channels[curchan->hw_value];
 	ath9k_cmn_update_ichannel(channel, chandef);
 
 	return channel;
-- 
1.8.3.4 (Apple Git-47)

