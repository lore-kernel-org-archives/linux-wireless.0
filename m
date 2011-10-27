Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35044 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754535Ab1J0Oby (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 10:31:54 -0400
Date: Thu, 27 Oct 2011 17:31:50 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Advertise support for TDLS
Message-ID: <20111027143150.GA17290@jouni.qca.qualcomm.com> (sfid-20111027_163158_190602_ED5FAB83)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on a quick test, TDLS seemed to be working fine with ath9k, so
let's start advertising support for this in the driver.

Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

Since some rate control algorithms don't really like the idea of a STA
entry with no supported rates, it would be a good idea to make sure that
this gets applied only after a fix for that from Arik goes in:
mac80211: init rate-control for TDLS sta when supp-rates are known


diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index af1b325..c91d464 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -694,6 +694,7 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		hw->wiphy->flags &= ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
 
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
+	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 
 	hw->queues = 4;
 	hw->max_rates = 4;
-- 
1.7.4.1


-- 
Jouni Malinen                                            PGP id EFC895FA
