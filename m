Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1336 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab2JHQBe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2012 12:01:34 -0400
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH 4/4] ath9k: Advertize beacon_int_infra_match
Date: Mon, 8 Oct 2012 21:30:54 +0530
Message-ID: <1349712054-3963-4-git-send-email-mohammed@qca.qualcomm.com> (sfid-20121008_180137_008028_860F085D)
In-Reply-To: <1349712054-3963-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1349712054-3963-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Currently ath9k need to have beacon interval matched
between STA mode and beaconing mode. Advertize this
through interface combinations.

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

