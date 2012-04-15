Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44680 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 8/9] ath9k_hw: disable fast channel change when changing from/to half/quarter mode
Date: Sun, 15 Apr 2012 12:15:40 +0200
Message-Id: <1334484941-27673-8-git-send-email-nbd@openwrt.org> (sfid-20120415_121604_468417_37308858)
In-Reply-To: <1334484941-27673-7-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
 <1334484941-27673-2-git-send-email-nbd@openwrt.org>
 <1334484941-27673-3-git-send-email-nbd@openwrt.org>
 <1334484941-27673-4-git-send-email-nbd@openwrt.org>
 <1334484941-27673-5-git-send-email-nbd@openwrt.org>
 <1334484941-27673-6-git-send-email-nbd@openwrt.org>
 <1334484941-27673-7-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index bb7e097..a48a4cc1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1438,6 +1438,10 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 						    CHANNEL_5GHZ));
 	mode_diff = (chan->chanmode != ah->curchan->chanmode);
 
+	if ((ah->curchan->channelFlags | chan->channelFlags) &
+	    (CHANNEL_HALF | CHANNEL_QUARTER))
+		return false;
+
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
 		if (ath9k_hw_numtxpending(ah, qnum)) {
 			ath_dbg(common, QUEUE,
-- 
1.7.3.2

