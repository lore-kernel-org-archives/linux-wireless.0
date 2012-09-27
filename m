Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33479 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729Ab2I0PTX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Sep 2012 11:19:23 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [RFC/RFT] ath9k: Advertize beacon_int_infra_match
Date: Thu, 27 Sep 2012 20:48:51 +0530
Message-ID: <1348759131-6998-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120927_171926_598073_37A93267)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Currently ath9k need to have beacon interval matched
between STA mode and beaconing mode. Advertize this
through interface combinations. Need to test this
properly.

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fad3ccd..546bae9 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -687,6 +687,7 @@ static const struct ieee80211_iface_combination if_comb = {
 	.n_limits = ARRAY_SIZE(if_limits),
 	.max_interfaces = 2048,
 	.num_different_channels = 1,
+	.beacon_int_infra_match = true,
 };
 
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
-- 
1.7.0.4

