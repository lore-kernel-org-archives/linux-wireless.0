Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59823 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754466Ab2LLVzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:55:37 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 5/6] ath9k: Report rx-crc-errors in ethtool stats.
Date: Wed, 12 Dec 2012 13:54:54 -0800
Message-Id: <1355349295-30960-5-git-send-email-greearb@candelatech.com> (sfid-20121212_225540_488699_791348E9)
In-Reply-To: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
References: <1355349295-30960-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 429be51..fe66be2 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1627,6 +1627,7 @@ static const char ath9k_gstrings_stats[][ETH_GSTRING_LEN] = {
 	AMKSTR(d_tx_desc_cfg_err),
 	AMKSTR(d_tx_data_underrun),
 	AMKSTR(d_tx_delim_underrun),
+	"d_rx_crc_err",
 	"d_rx_decrypt_crc_err",
 	"d_rx_phy_err",
 	"d_rx_mic_err",
@@ -1707,6 +1708,7 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	AWDATA(data_underrun);
 	AWDATA(delim_underrun);
 
+	AWDATA_RX(crc_err);
 	AWDATA_RX(decrypt_crc_err);
 	AWDATA_RX(phy_err);
 	AWDATA_RX(mic_err);
-- 
1.7.3.4

