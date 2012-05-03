Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay2.gtri.gatech.edu ([130.207.199.168]:56097 "EHLO
	relay2.gtri.gatech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab2ECFKt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 01:10:49 -0400
Message-ID: <4FA21357.8090600@gtri.gatech.edu> (sfid-20120503_071052_216197_92DCA6AC)
Date: Thu, 3 May 2012 01:10:47 -0400
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: <Larry.Finger@lwfinger.net>
Subject: [PATCH 2/9] rtlwifi: don't pass a null pointer to fill_tx_desc
References: <4FA212D9.5020602@gtri.gatech.edu>
In-Reply-To: <4FA212D9.5020602@gtri.gatech.edu>
Content-Type: multipart/mixed;
	boundary="------------020004020307020400000305"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------020004020307020400000305
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit



--------------020004020307020400000305
Content-Type: text/x-patch;
	name="0002-rtlwifi-don-t-pass-a-null-pointer-to-fill_tx_desc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0002-rtlwifi-don-t-pass-a-null-pointer-to-fill_tx_desc.patch"

>From bdd269b21d249d75175de4e22c11e2a5bfbb8a08 Mon Sep 17 00:00:00 2001
From: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
Date: Thu, 3 May 2012 00:03:09 -0400
Subject: [PATCH 2/9] rtlwifi: don't pass a null pointer to fill_tx_desc

Take care of "allocating" the txdesc in the usb core, rather than in
each subdriver.  This also avoids passing a rather useless null argument
to fill_tx_desc.

Signed-off-by: Joshua Roys <Joshua.Roys@gtri.gatech.edu>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c |    4 +---
 drivers/net/wireless/rtlwifi/usb.c           |    6 ++++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
index 21bc827..9e01f96 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/trx.c
@@ -513,12 +513,10 @@ void rtl92cu_tx_fill_desc(struct ieee80211_hw *hw,
 	u16 pktlen = skb->len;
 	enum rtl_desc_qsel fw_qsel = _rtl8192cu_mq_to_descq(hw, fc,
 						skb_get_queue_mapping(skb));
-	u8 *txdesc;
+	u8 *txdesc = pdesc_tx;
 
 	seq_number = (le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
 	rtl_get_tcb_desc(hw, info, sta, skb, tcb_desc);
-	txdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
-	memset(txdesc, 0, RTL_TX_HEADER_SIZE);
 	SET_TX_DESC_PKT_SIZE(txdesc, pktlen);
 	SET_TX_DESC_LINIP(txdesc, 0);
 	SET_TX_DESC_PKT_OFFSET(txdesc, RTL_DUMMY_OFFSET);
diff --git a/drivers/net/wireless/rtlwifi/usb.c b/drivers/net/wireless/rtlwifi/usb.c
index d04dbda..91969ee 100644
--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -850,7 +850,7 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw, struct sk_buff *skb,
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_mac *mac = rtl_mac(rtl_priv(hw));
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct rtl_tx_desc *pdesc = NULL;
+	u8 *pdesc = NULL;
 	struct rtl_tcb_desc tcb_desc;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)(skb->data);
 	__le16 fc = hdr->frame_control;
@@ -887,7 +887,9 @@ static void _rtl_usb_tx_preprocess(struct ieee80211_hw *hw, struct sk_buff *skb,
 		seq_number += 1;
 		seq_number <<= 4;
 	}
-	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, (u8 *)pdesc, info, skb,
+	pdesc = (u8 *)skb_push(skb, RTL_TX_HEADER_SIZE);
+	memset(pdesc, 0, RTL_TX_HEADER_SIZE);
+	rtlpriv->cfg->ops->fill_tx_desc(hw, hdr, pdesc, info, skb,
 					hw_queue, &tcb_desc);
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		if (qc)
-- 
1.7.7.6


--------------020004020307020400000305--
