Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48286 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaLRJGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:06:02 -0500
Received: by mail-ob0-f175.google.com with SMTP id wp4so2334248obc.6
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:06:02 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 06/16] rtlwifi: rtl8192ce: Improve RF sleep routine
Date: Thu, 18 Dec 2014 03:05:30 -0600
Message-Id: <1418893540-19944-7-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100724_690421_C408AE18)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These changes match those of the latest vendor driver.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8192ce/phy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
index bc5ca98..1ee5a6a 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192ce/phy.c
@@ -518,11 +518,12 @@ static bool _rtl92ce_phy_set_rf_power_state(struct ieee80211_hw *hw,
 		}
 	case ERFSLEEP:{
 			if (ppsc->rfpwr_state == ERFOFF)
-				return false;
+				break;
 			for (queue_id = 0, i = 0;
 			     queue_id < RTL_PCI_MAX_TX_QUEUE_COUNT;) {
 				ring = &pcipriv->dev.tx_ring[queue_id];
-				if (skb_queue_len(&ring->queue) == 0) {
+				if (queue_id == BEACON_QUEUE ||
+				    skb_queue_len(&ring->queue) == 0) {
 					queue_id++;
 					continue;
 				} else {
-- 
2.1.2

