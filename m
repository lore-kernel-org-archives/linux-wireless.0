Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.10]:14413 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbFBTLo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:11:44 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH 4/4] mt7601u: set promiscous mode based on FIF_OTHER_BSS
Date: Tue,  2 Jun 2015 21:11:28 +0200
Message-Id: <1433272288-6450-4-git-send-email-moorray3@wp.pl> (sfid-20150602_211148_904300_A9E72796)
In-Reply-To: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
References: <1433272288-6450-1-git-send-email-moorray3@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

Most drivers use FIF_OTHER_BSS to set promiscous mode.  Let us
follow their lead even though it doesn't match exactly the HW
filter flags.

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 drivers/net/wireless/mediatek/mt7601u/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
index ced82abb414f..169384b48b27 100644
--- a/drivers/net/wireless/mediatek/mt7601u/main.c
+++ b/drivers/net/wireless/mediatek/mt7601u/main.c
@@ -119,6 +119,7 @@ mt76_configure_filter(struct ieee80211_hw *hw, unsigned int changed_flags,
 
 	dev->rxfilter &= ~MT_RX_FILTR_CFG_OTHER_BSS;
 
+	MT76_FILTER(OTHER_BSS, MT_RX_FILTR_CFG_PROMISC);
 	MT76_FILTER(FCSFAIL, MT_RX_FILTR_CFG_CRC_ERR);
 	MT76_FILTER(PLCPFAIL, MT_RX_FILTR_CFG_PHY_ERR);
 	MT76_FILTER(CONTROL, MT_RX_FILTR_CFG_ACK |
-- 
2.1.0

