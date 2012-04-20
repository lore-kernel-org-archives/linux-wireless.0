Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29242 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547Ab2DTJNH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 05:13:07 -0400
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	rodrigue@qca.qualcomm.com, jouni@qca.qualcomm.com,
	Michael Liang <mliang@qca.qualcomm.com>
From: <mliang@qca.qualcomm.com>
To: <linville@tuxdriver.com>
Subject: [PATCH 1/1] ath9k: don't strip mic on non-encrypted frames in tkip
Date: Fri, 20 Apr 2012 17:11:57 +0800
Message-ID: <1334913117-4037-2-git-send-email-mliang@qca.qualcomm.com> (sfid-20120420_111312_935697_9764F0AB)
In-Reply-To: <1334913117-4037-1-git-send-email-mliang@qca.qualcomm.com>
References: <1334913117-4037-1-git-send-email-mliang@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michael Liang <mliang@qca.qualcomm.com>

Fix the following bug: in tkip mode, qos-null ps on/off packets
are dropped due to incorrect packet length so that ath9k softap
can't handle powersave state transition of peer STA correctly.

Signed-off-by: Michael Liang <mliang@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 301ef3e..48f7a52 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -812,6 +812,7 @@ static bool ath9k_rx_accept(struct ath_common *common,
 	is_valid_tkip = rx_stats->rs_keyix != ATH9K_RXKEYIX_INVALID &&
 		test_bit(rx_stats->rs_keyix, common->tkip_keymap);
 	strip_mic = is_valid_tkip && ieee80211_is_data(fc) &&
+		ieee80211_has_protected(fc) &&
 		!(rx_stats->rs_status &
 		(ATH9K_RXERR_DECRYPT | ATH9K_RXERR_CRC | ATH9K_RXERR_MIC |
 		 ATH9K_RXERR_KEYMISS));
-- 
1.7.0.4

