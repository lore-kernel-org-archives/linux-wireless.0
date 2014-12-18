Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:47315 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbaLRJGD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:03 -0500
Received: by mail-oi0-f45.google.com with SMTP id x69so112056oia.32
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:03 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 07/16] rtlwifi: Remove extraneous argument for rate mapping
Date: Thu, 18 Dec 2014 03:05:31 -0600
Message-Id: <1418893540-19944-8-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100728_791440_A3EB2D0A)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Four of the drivers (92ce, 92cu, 92de, and 92se) supply an argument to the
rate-mapping routine that is never used, thus it can be removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/base.c          |  2 +-
 drivers/net/wireless/rtlwifi/base.h          |  2 +-
 drivers/net/wireless/rtlwifi/rtl8192ce/trx.c |  5 ++---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |  6 ++----
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c |  3 +--
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 11 +++++------
 6 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index 40b6d1d..d4c8e95 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -883,7 +883,7 @@ static u8 _rtl_get_highest_n_rate(struct ieee80211_hw *hw,
  * DESC92_RATEMCS0-->DESC92_RATEMCS15 ==> idx is 0-->15
  */
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
-			 bool isht, u8 desc_rate, bool first_ampdu)
+			 bool isht, u8 desc_rate)
 {
 	int rate_idx;
 
diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 982f245..936c2bb 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -124,7 +124,7 @@ void rtl_deinit_deferred_work(struct ieee80211_hw *hw);
 
 bool rtl_action_proc(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 int rtlwifi_rate_mapping(struct ieee80211_hw *hw,
-			 bool isht, u8 desc_rate, bool first_ampdu);
+			 bool isht, u8 desc_rate);
 bool rtl_tx_mgmt_proc(struct ieee80211_hw *hw, struct sk_buff *skb);
 u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
index e88dcd0..d25aeeb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.c
@@ -400,9 +400,8 @@ bool rtl92ce_rx_query_desc(struct ieee80211_hw *hw,
 	 * are use (RX_FLAG_HT)
 	 * Notice: this is diff with windows define
 	 */
-	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-				stats->is_ht, stats->rate,
-				stats->isfirst_ampdu);
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
+						   stats->rate);
 
 	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index f383d5f..fa30b26 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -340,8 +340,7 @@ bool rtl92cu_rx_query_desc(struct ieee80211_hw *hw,
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
 					(bool)GET_RX_DESC_RX_HT(pdesc),
-					(u8)GET_RX_DESC_RX_MCS(pdesc),
-					(bool)GET_RX_DESC_PAGGR(pdesc));
+					(u8)GET_RX_DESC_RX_MCS(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(skb->data +
@@ -408,8 +407,7 @@ static void _rtl_rx_process(struct ieee80211_hw *hw, struct sk_buff *skb)
 	/* Data rate */
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
 					(bool)GET_RX_DESC_RX_HT(rxdesc),
-					(u8)GET_RX_DESC_RX_MCS(rxdesc),
-					(bool)GET_RX_DESC_PAGGR(rxdesc));
+					(u8)GET_RX_DESC_RX_MCS(rxdesc));
 	/*  There is a phy status after this rx descriptor. */
 	if (GET_RX_DESC_PHY_STATUS(rxdesc)) {
 		p_drvinfo = (struct rx_fwinfo_92c *)(rxdesc + RTL_RX_DESC_SIZE);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
index 8efbcc7..7fbae49 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.c
@@ -514,8 +514,7 @@ bool rtl92de_rx_query_desc(struct ieee80211_hw *hw,	struct rtl_stats *stats,
 		rx_status->flag |= RX_FLAG_DECRYPTED;
 	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
 					(bool)GET_RX_DESC_RXHT(pdesc),
-					(u8)GET_RX_DESC_RXMCS(pdesc),
-					(bool)GET_RX_DESC_PAGGR(pdesc));
+					(u8)GET_RX_DESC_RXMCS(pdesc));
 	rx_status->mactime = GET_RX_DESC_TSFL(pdesc);
 	if (phystatus) {
 		p_drvinfo = (struct rx_fwinfo_92d *)(skb->data +
diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 672fd3b..da053cb 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -264,7 +264,6 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 	struct rx_fwinfo *p_drvinfo;
 	u32 phystatus = (u32)GET_RX_STATUS_DESC_PHY_STATUS(pdesc);
 	struct ieee80211_hdr *hdr;
-	bool first_ampdu = false;
 
 	stats->length = (u16)GET_RX_STATUS_DESC_PKT_LEN(pdesc);
 	stats->rx_drvinfo_size = (u8)GET_RX_STATUS_DESC_DRVINFO_SIZE(pdesc) * 8;
@@ -319,8 +318,8 @@ bool rtl92se_rx_query_desc(struct ieee80211_hw *hw, struct rtl_stats *stats,
 			rx_status->flag |= RX_FLAG_DECRYPTED;
 	}
 
-	rx_status->rate_idx = rtlwifi_rate_mapping(hw,
-			      stats->is_ht, stats->rate, first_ampdu);
+	rx_status->rate_idx = rtlwifi_rate_mapping(hw, stats->is_ht,
+						   stats->rate);
 
 	rx_status->mactime = stats->timestamp_low;
 	if (phystatus) {
@@ -398,9 +397,9 @@ void rtl92se_tx_fill_desc(struct ieee80211_hw *hw,
 
 		if (rtlhal->version == VERSION_8192S_ACUT) {
 			if (ptcb_desc->hw_rate == DESC92_RATE1M ||
-				ptcb_desc->hw_rate  == DESC92_RATE2M ||
-				ptcb_desc->hw_rate == DESC92_RATE5_5M ||
-				ptcb_desc->hw_rate == DESC92_RATE11M) {
+			    ptcb_desc->hw_rate  == DESC92_RATE2M ||
+			    ptcb_desc->hw_rate == DESC92_RATE5_5M ||
+			    ptcb_desc->hw_rate == DESC92_RATE11M) {
 				ptcb_desc->hw_rate = DESC92_RATE12M;
 			}
 		}
-- 
2.1.2

