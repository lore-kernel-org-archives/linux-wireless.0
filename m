Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33392 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2AHCrK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Jan 2012 21:47:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: linville@tuxdriver.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, Stable <stable@vger.kernel.org>
Subject: [PATCH 1/8] rtlwifi: rtl8192c_common: rtl8192de: Check for allocation failures
Date: Sat,  7 Jan 2012 20:46:40 -0600
Message-Id: <1325990807-13575-2-git-send-email-Larry.Finger@lwfinger.net> (sfid-20120108_034713_829783_E80F6A38)
In-Reply-To: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1325990807-13575-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In https://bugzilla.redhat.com/show_bug.cgi?id=771656, a kernel bug was
triggered due to a failed skb allocation that was not checked. This event
lead to an audit of all memory allocations in the complete rtlwifi family
of drivers. This patch fixes the rest.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>
---
---
 drivers/net/wireless/rtlwifi/pci.c                |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c |    2 ++
 drivers/net/wireless/rtlwifi/rtl8192de/fw.c       |   14 +++++++++-----
 drivers/net/wireless/rtlwifi/usb.c                |   12 +++++++-----
 4 files changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 74d8fbf..ed6f6a9 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -652,6 +652,8 @@ static void _rtl_receive_one(struct ieee80211_hw *hw, struct sk_buff *skb,
 		return;
 
 	uskb = dev_alloc_skb(skb->len + 128);
+	if (!uskb)
+		return;		/* exit if allocation failed */
 	memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status, sizeof(rx_status));
 	pdata = (u8 *)skb_put(uskb, skb->len);
 	memcpy(pdata, skb->data, skb->len);
diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
index 1eae3ba..e9e9c26 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/fw_common.c
@@ -785,6 +785,8 @@ void rtl92c_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 
 
 	skb = dev_alloc_skb(totalpacketlen);
+	if (!skb)
+		return;
 	memcpy((u8 *) skb_put(skb, totalpacketlen),
 	       &reserved_page_packet, totalpacketlen);
 
diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
index 94f5b7d..da58ca4 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192de/fw.c
@@ -756,12 +756,16 @@ void rtl92d_set_fw_rsvdpagepkt(struct ieee80211_hw *hw, bool dl_finished)
 		      "rtl92d_set_fw_rsvdpagepkt(): HW_VAR_SET_TX_CMD: ALL",
 		      u1RsvdPageLoc, 3);
 	skb = dev_alloc_skb(totalpacketlen);
-	memcpy((u8 *) skb_put(skb, totalpacketlen), &reserved_page_packet,
-		totalpacketlen);
-	rtstatus = _rtl92d_cmd_send_packet(hw, skb);
+	if (!skb) {
+		dlok = false;
+	} else {
+		memcpy((u8 *) skb_put(skb, totalpacketlen),
+			&reserved_page_packet, totalpacketlen);
+		rtstatus = _rtl92d_cmd_send_packet(hw, skb);
 
-	if (rtstatus)
-		dlok = true;
+		if (rtstatus)
+			dlok = true;
+	}
 	if (dlok) {
 		RT_TRACE(rtlpriv, COMP_POWER, DBG_LOUD,
 			 "Set RSVD page location to Fw\n");
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index 6ae1b21..4db06f6 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -520,12 +520,14 @@ static void _rtl_usb_rx_process_noagg(struct ieee80211_hw *hw,
 			u8 *pdata;
 
 			uskb = dev_alloc_skb(skb->len + 128);
-			memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
-			       sizeof(rx_status));
-			pdata = (u8 *)skb_put(uskb, skb->len);
-			memcpy(pdata, skb->data, skb->len);
+			if (uskb) {	/* drop packet on allocation failure */
+				memcpy(IEEE80211_SKB_RXCB(uskb), &rx_status,
+				       sizeof(rx_status));
+				pdata = (u8 *)skb_put(uskb, skb->len);
+				memcpy(pdata, skb->data, skb->len);
+				ieee80211_rx_irqsafe(hw, uskb);
+			}
 			dev_kfree_skb_any(skb);
-			ieee80211_rx_irqsafe(hw, uskb);
 		} else {
 			dev_kfree_skb_any(skb);
 		}
-- 
1.7.7

