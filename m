Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39571 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756177Ab2DSTSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 15:18:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v3 7/8] ath9k_hw: disable fast channel change when changing from/to half/quarter mode
Date: Thu, 19 Apr 2012 21:18:28 +0200
Message-Id: <1334863109-95726-7-git-send-email-nbd@openwrt.org> (sfid-20120419_211841_712432_9D8D4A47)
In-Reply-To: <1334863109-95726-6-git-send-email-nbd@openwrt.org>
References: <1334863109-95726-1-git-send-email-nbd@openwrt.org>
 <1334863109-95726-2-git-send-email-nbd@openwrt.org>
 <1334863109-95726-3-git-send-email-nbd@openwrt.org>
 <1334863109-95726-4-git-send-email-nbd@openwrt.org>
 <1334863109-95726-5-git-send-email-nbd@openwrt.org>
 <1334863109-95726-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index e576a92..75fd87f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1687,6 +1687,10 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	if (chan->channel == ah->curchan->channel)
 		goto fail;
 
+	if ((ah->curchan->channelFlags | chan->channelFlags) &
+	    (CHANNEL_HALF | CHANNEL_QUARTER))
+		goto fail;
+
 	if ((chan->channelFlags & CHANNEL_ALL) !=
 	    (ah->curchan->channelFlags & CHANNEL_ALL))
 		goto fail;
-- 
1.7.3.2

