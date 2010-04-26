Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34500 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0DZUK1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 16:10:27 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] b43legacy: remove usage of deprecated noise value
Date: Mon, 26 Apr 2010 16:09:23 -0400
Message-Id: <1272312563-22730-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/b43legacy/xmit.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43legacy/xmit.c b/drivers/net/wireless/b43legacy/xmit.c
index 9c8882d..7d177d9 100644
--- a/drivers/net/wireless/b43legacy/xmit.c
+++ b/drivers/net/wireless/b43legacy/xmit.c
@@ -548,7 +548,6 @@ void b43legacy_rx(struct b43legacy_wldev *dev,
 				      (phystat0 & B43legacy_RX_PHYST0_OFDM),
 				      (phystat0 & B43legacy_RX_PHYST0_GAINCTL),
 				      (phystat3 & B43legacy_RX_PHYST3_TRSTATE));
-	status.noise = dev->stats.link_noise;
 	/* change to support A PHY */
 	if (phystat0 & B43legacy_RX_PHYST0_OFDM)
 		status.rate_idx = b43legacy_plcp_get_bitrate_idx_ofdm(plcp, false);
-- 
1.6.6.1

