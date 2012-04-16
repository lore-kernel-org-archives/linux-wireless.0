Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48154 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755071Ab2DPVJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:09:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 7/8] ath9k_hw: disable fast channel change when changing from/to half/quarter mode
Date: Mon, 16 Apr 2012 23:09:24 +0200
Message-Id: <1334610565-37399-7-git-send-email-nbd@openwrt.org> (sfid-20120416_230939_438042_9909BA6E)
In-Reply-To: <1334610565-37399-6-git-send-email-nbd@openwrt.org>
References: <1334610565-37399-1-git-send-email-nbd@openwrt.org>
 <1334610565-37399-2-git-send-email-nbd@openwrt.org>
 <1334610565-37399-3-git-send-email-nbd@openwrt.org>
 <1334610565-37399-4-git-send-email-nbd@openwrt.org>
 <1334610565-37399-5-git-send-email-nbd@openwrt.org>
 <1334610565-37399-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ff8d58d..26e6083 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1440,6 +1440,10 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
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

