Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38712 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0EGClP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 May 2010 22:41:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/3] ath9k_common: drop incomming frames with an invalid hardware rate
Date: Thu,  6 May 2010 22:41:13 -0400
Message-Id: <1273200074-9127-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1273200074-9127-1-git-send-email-lrodriguez@atheros.com>
References: <1273200074-9127-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_common (used by ath9k and ath9k_htc) trusts the frames
blessed by hardware as OK are infact correct even if the rate
seen by the driver is unrecognized. ath9k_common just treats
these frames in mac80211 as frames as frames under 1 mbps rate.
It seems this might not be the best thing to do as other parts of
the frame might not be valid so just drop these frames for now.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/common.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless/ath/ath9k/common.c
index 9a33c3a..b22f9c9 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -147,8 +147,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	if ((common->debug_mask & ATH_DBG_XMIT))
 		print_hex_dump_bytes("", DUMP_PREFIX_NONE, skb->data, skb->len);
 
-	rxs->rate_idx = 0;
-	return 0;
+	return -EINVAL;
 }
 
 static void ath9k_process_rssi(struct ath_common *common,
-- 
1.6.3.3

