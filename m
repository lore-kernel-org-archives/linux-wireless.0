Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:41521 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbaLRJGL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:11 -0500
Received: by mail-ob0-f182.google.com with SMTP id wo20so2282864obc.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:11 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 15/16] rtlwifi: rtl8192de: Rework calls to rate-control routine
Date: Thu, 18 Dec 2014 03:05:39 -0600
Message-Id: <1418893540-19944-16-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100708_393233_B4E9B2DC)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code uses macros to determine the parameters that are passed to the
rate setting routine. A simpler method is implemented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 381a4c0..547c6d0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -499,6 +499,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 					 && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->is_ht = (bool)GET_RX_DESC_RXHT(pdesc);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 	if (GET_RX_DESC_CRC32(pdesc))
@@ -512,9 +513,8 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-					(bool)GET_RX_DESC_RXHT(pdesc),
-					(u8)GET_RX_DESC_RXMCS(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
+						   stats->rate);
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
-- 
2.1.2

