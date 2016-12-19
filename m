Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757691AbcLSKzA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:00 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/11] rt2800: make rx ampdu_factor depend on number of rx chains
Date: Mon, 19 Dec 2016 11:52:47 +0100
Message-Id: <1482144777-16760-2-git-send-email-sgruszka@redhat.com> (sfid-20161219_120337_096294_CE7A1B40)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initalize max ampdu_factor supported by us based on rx chains, vendor
driver do the same.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 2515702..62bb9a6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7596,7 +7596,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	spec->ht.cap |= rx_chains << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
-	spec->ht.ampdu_factor = 3;
+	spec->ht.ampdu_factor = (rx_chains > 1) ? 3 : 2;
 	spec->ht.ampdu_density = 4;
 	spec->ht.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	if (tx_chains != rx_chains) {
-- 
1.7.1
