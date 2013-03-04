Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49982 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252Ab3CDXbq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 18:31:46 -0500
From: greearb@candelatech.com
To: ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 2/2] ath9k: Report rx-crc-errors in ethtool stats.
Date: Mon,  4 Mar 2013 15:31:17 -0800
Message-Id: <1362439877-12345-2-git-send-email-greearb@candelatech.com> (sfid-20130305_003148_914842_BEFDF80F)
In-Reply-To: <1362439877-12345-1-git-send-email-greearb@candelatech.com>
References: <1362439877-12345-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index daae4d0..67a2a4b 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1912,6 +1912,7 @@ static const char ath9k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	AMKSTR(d_tx_desc_cfg_err),
 	AMKSTR(d_tx_data_underrun),
 	AMKSTR(d_tx_delim_underrun),
+	"d_rx_crc_err",
 	"d_rx_decrypt_crc_err",
 	"d_rx_phy_err",
 	"d_rx_mic_err",
@@ -1992,6 +1993,7 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	AWDATA(data_underrun);
 	AWDATA(delim_underrun);
 
+	AWDATA_RX(crc_err);
 	AWDATA_RX(decrypt_crc_err);
 	AWDATA_RX(phy_err);
 	AWDATA_RX(mic_err);
-- 
1.7.3.4

