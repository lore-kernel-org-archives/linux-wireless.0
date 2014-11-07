Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2321 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaKGNOu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 08:14:50 -0500
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Advertise support for AP mode channel width changes
Date: Fri, 7 Nov 2014 18:46:45 +0530
Message-ID: <1415366205-11672-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20141107_141452_785891_E58E6AA2)
In-Reply-To: <1415366205-11672-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1415366205-11672-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will enable AP mode to change channel width dynamically
based on 20/40 intolerance report sent by associated client.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/mac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index a726107..d6799f4 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4916,6 +4916,7 @@ int ath10k_mac_register(struct ath10k *ar)
 	ar->hw->wiphy->max_remain_on_channel_duration = 5000;
 
 	ar->hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
+	ar->hw->wiphy->features |= NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE;
 	/*
 	 * on LL hardware queues are managed entirely by the FW
 	 * so we only advertise to mac we can do the queues thing
-- 
2.1.3

