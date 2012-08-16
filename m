Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4800 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150Ab2HPAP0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Aug 2012 20:15:26 -0400
From: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>
Subject: [PATCH] ath6kl: protect firmware from excessive WoW pattern length
Date: Wed, 15 Aug 2012 17:15:16 -0700
Message-ID: <1345076116-5053-1-git-send-email-c_tpeder@qca.qualcomm.com> (sfid-20120816_021530_554431_E3CCD682)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't accept WoW patterns longer than supported by firmware.

Reported-by: Haijun Jin <nhjin@qca.qualcomm.com>
Signed-off-by: Thomas Pedersen <c_tpeder@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index bd003fe..ffa18f3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1876,6 +1876,9 @@ static int ath6kl_wow_usr(struct ath6kl *ar, struct ath6kl_vif *vif,
 	/* Configure the patterns that we received from the user. */
 	for (i = 0; i < wow->n_patterns; i++) {
 
+		if (wow->patterns[i].pattern_len > WOW_MASK_SIZE)
+			return -EINVAL;
+
 		/*
 		 * Convert given nl80211 specific mask value to equivalent
 		 * driver specific mask value and send it to the chip along
-- 
1.7.4.1

