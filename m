Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55925 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753893AbaEDXdS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2014 19:33:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH] ath9k_hw: get QCA953x WMAC revision via platform_data
Date: Mon,  5 May 2014 01:33:01 +0200
Message-Id: <1399246381-51997-1-git-send-email-nbd@openwrt.org> (sfid-20140505_013333_906514_680BE0D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SREV register in the WMAC register space does not contain the chip
revision, so it needs to be passed in from the kernel.

With an updated kernel, this fixes tx gain table selection.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c8a9dfa..dffefee 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -246,6 +246,8 @@ static void ath9k_hw_read_revisions(struct ath_hw *ah)
 		return;
 	case AR9300_DEVID_AR953X:
 		ah->hw_version.macVersion = AR_SREV_VERSION_9531;
+		if (ah->get_mac_revision)
+			ah->hw_version.macRev = ah->get_mac_revision();
 		return;
 	}
 
-- 
1.8.5.2 (Apple Git-48)

