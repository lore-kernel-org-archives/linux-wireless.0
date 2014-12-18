Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:33881 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaLRJGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:10 -0500
Received: by mail-oi0-f51.google.com with SMTP id e131so109479oig.10
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:10 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 14/16] rtlwifi: rtl8192cu: Rework calls to rate-control routine
Date: Thu, 18 Dec 2014 03:05:38 -0600
Message-Id: <1418893540-19944-15-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100629_937463_37D219A1)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code uses macros to determine the parameters that are passed to the
rate setting routine. A simpler method is implemented.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index fe29876..5eccaba 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -325,6 +325,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 				   && (GET_RX_DESC_FAGGR(pdesc) == 1));
 	stats->timestamp_low = GET_RX_DESC_TSFL(pdesc);
 	stats->rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(pdesc);
+	stats->is_ht = (bool)GET_RX_DESC_RX_HT(pdesc);
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
 	rx_status->band = hw->conf.chandef.chan->band;
 	if (GET_RX_DESC_CRC32(pdesc))
@@ -338,9 +339,8 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 	rx_status->flag |= RX_FLAG_MACTIME_START;
 	if (stats->decrypted)
 		rx_status->flag |= RX_FLAG_DECRYPTED;
-	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-					(bool)GET_RX_DESC_RX_HT(pdesc),
-					(u8)GET_RX_DESC_RX_MCS(pdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
+						   stats->rate);
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
@@ -392,6 +392,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 				   && (GET_RX_DESC_FAGGR(rxdesc) == 1));
 	stats.timestamp_low = GET_RX_DESC_TSFL(rxdesc);
 	stats.rx_is40Mhzpacket = (bool) GET_RX_DESC_BW(rxdesc);
+	stats.is_ht = (bool)GET_RX_DESC_RX_HT(rxdesc);
 	/* TODO: is center_freq changed when doing scan? */
 	/* TODO: Shall we add protection or just skip those two step? */
 	rx_status->freq = hw->conf.chandef.chan->center_freq;
@@ -405,9 +406,8 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	if (GET_RX_DESC_RX_HT(rxdesc))
 		rx_status->flag |= RX_FLAG_HT;
 	/* Data rate */
-	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-					(bool)GET_RX_DESC_RX_HT(rxdesc),
-					(u8)GET_RX_DESC_RX_MCS(rxdesc));
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats.is_ht,
+						   stats.rate);
 	/*  There is a phy status after this rx descriptor. */
 	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
-- 
2.1.2

