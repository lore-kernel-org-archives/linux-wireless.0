Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:54840 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758044Ab2EHCS7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 22:18:59 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 5/9] rtlwifi: add short circuit in the receive path
Date: Mon, 7 May 2012 22:18:37 -0400
Message-ID: <1336443521-15299-6-git-send-email-Joshua.Roys@gtri.gatech.edu> (sfid-20120508_041903_774971_E340E229)
In-Reply-To: <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
References: <4FA212D9.5020602@gtri.gatech.edu>
 <1336443521-15299-1-git-send-email-Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow things like C2H events without any actual 802.11 data to avoid
the rest of the receive path.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/usb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 471a112..d9a0a9f 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -440,7 +440,11 @@ static void _rtl_usb_rx_process_agg(struct ieee80211_hw *hw,
 	};
 
 	skb_pull(skb, RTL_RX_DESC_SIZE);
-	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
+	if (!rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc,
+	    skb)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = hdr->frame_control;
@@ -483,7 +487,11 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
 	};
 
 	skb_pull(skb, RTL_RX_DESC_SIZE);
-	rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc, skb);
+	if (!rtlpriv->cfg->ops->query_rx_desc(hw, &stats, &rx_status, rxdesc,
+	    skb)) {
+		dev_kfree_skb_any(skb);
+		return;
+	}
 	skb_pull(skb, (stats.rx_drvinfo_size + stats.rx_bufshift));
 	hdr = (struct ieee80211_hdr *)(skb->data);
 	fc = hdr->frame_control;
-- 
1.7.4.1

