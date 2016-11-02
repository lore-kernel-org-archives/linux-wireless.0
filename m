Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49744 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751795AbcKBOMY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Nov 2016 10:12:24 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/10] rt2800: correctly report MCS TX parameters
Date: Wed,  2 Nov 2016 15:10:56 +0100
Message-Id: <1478095865-8651-2-git-send-email-sgruszka@redhat.com> (sfid-20161102_151228_173275_159CA70F)
In-Reply-To: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
References: <1478095865-8651-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should only set IEEE80211_HT_MCS_TX_RX_DIF when TX and RX MCS sets
are not equal, i.e. when number of tx streams is different than
number of RX streams.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   23 +++++++++++++----------
 1 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index bf3f0a3..aab59f6 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -7464,7 +7464,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	char *default_power1;
 	char *default_power2;
 	char *default_power3;
-	unsigned int i;
+	unsigned int i, tx_chains, rx_chains;
 	u32 reg;
 
 	/*
@@ -7589,21 +7589,24 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	    IEEE80211_HT_CAP_SGI_20 |
 	    IEEE80211_HT_CAP_SGI_40;
 
-	if (rt2x00dev->default_ant.tx_chain_num >= 2)
+	tx_chains = rt2x00dev->default_ant.tx_chain_num;
+	rx_chains = rt2x00dev->default_ant.rx_chain_num;
+
+	if (tx_chains >= 2)
 		spec->ht.cap |= IEEE80211_HT_CAP_TX_STBC;
 
-	spec->ht.cap |= rt2x00dev->default_ant.rx_chain_num <<
-			IEEE80211_HT_CAP_RX_STBC_SHIFT;
+	spec->ht.cap |= rx_chains << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
 	spec->ht.ampdu_factor = 3;
 	spec->ht.ampdu_density = 4;
-	spec->ht.mcs.tx_params =
-	    IEEE80211_HT_MCS_TX_DEFINED |
-	    IEEE80211_HT_MCS_TX_RX_DIFF |
-	    ((rt2x00dev->default_ant.tx_chain_num - 1) <<
-	     IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT);
+	spec->ht.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
+	if (tx_chains != rx_chains) {
+		spec->ht.mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;
+		spec->ht.mcs.tx_params |=
+		    (tx_chains - 1) << IEEE80211_HT_MCS_TX_MAX_STREAMS_SHIFT;
+	}
 
-	switch (rt2x00dev->default_ant.rx_chain_num) {
+	switch (rx_chains) {
 	case 3:
 		spec->ht.mcs.rx_mask[2] = 0xff;
 	case 2:
-- 
1.7.1
