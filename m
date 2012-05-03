Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56180 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2ECFMv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:12:51 -0400
Message-ID: <4FA213D1.9030506@gtri.gatech.edu> (sfid-20120503_071254_219549_D93C580C)
Date: Thu, 3 May 2012 01:12:49 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 6/9] rtlwifi: add short circuit in the receive path
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------060401080204030606050906"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------060401080204030606050906
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------060401080204030606050906
Content-Type: text/x-patch;
	name="0006-rtlwifi-add-short-circuit-in-the-receive-path.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0006-rtlwifi-add-short-circuit-in-the-receive-path.patch"

>From 78b5e60d9797583172d3e1f755a9f354b5a20759 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:16:39 -0400
Subject: [PATCH 6/9] rtlwifi: add short circuit in the receive path

Allow things like C2H events without any actual 802.11 data to avoid
the rest of the receive path.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/usb.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 88dbef0..00e90bc 100644
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
1.7.7.6


--------------060401080204030606050906--
