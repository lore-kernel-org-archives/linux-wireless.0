Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:57162 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175AbZK3RNg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2009 12:13:36 -0500
Date: Mon, 30 Nov 2009 18:13:42 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 10/12] mwl8k: struct ieee80211_rx_status::qual is deprecated
Message-ID: <20091130171342.GM20214@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>
---
 drivers/net/wireless/mwl8k.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
index 5e67ae9..ca6162b 100644
--- a/drivers/net/wireless/mwl8k.c
+++ b/drivers/net/wireless/mwl8k.c
@@ -915,7 +915,6 @@ mwl8k_rxd_8687_process(void *_rxd, struct ieee80211_rx_status *status,
 
 	status->signal = -rxd->rssi;
 	status->noise = -rxd->noise_level;
-	status->qual = rxd->link_quality;
 	status->antenna = MWL8K_8687_RATE_INFO_ANTSELECT(rate_info);
 	status->rate_idx = MWL8K_8687_RATE_INFO_RATEID(rate_info);
 
-- 
1.5.6.4
