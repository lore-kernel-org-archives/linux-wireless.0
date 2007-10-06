Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:17023 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756750AbXJFMET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Oct 2007 08:04:19 -0400
Received: by ug-out-1314.google.com with SMTP id z38so605537ugc
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2007 05:04:19 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 15/16] rt2x00: Allways memset memory obtained from skb_push()
Date: Sat, 6 Oct 2007 14:18:22 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710061410.31765.IvDoorn@gmail.com>
In-Reply-To: <200710061410.31765.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710061418.23152.IvDoorn@gmail.com> (sfid-20071006_131650_593625_DCF096A1)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When skb_push() is used we should memset the memory before
usage. This will prevent bugs which could occur when the
data is treated as TX descriptor.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c |    2 ++
 drivers/net/wireless/rt2x00/rt61pci.c   |    2 ++
 drivers/net/wireless/rt2x00/rt73usb.c   |    2 ++
 3 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index dff051e..fc1c60a 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1663,6 +1663,8 @@ static int rt2500usb_beacon_update(struct ieee80211_hw *hw,
 	 * First we create the beacon.
 	 */
 	skb_push(skb, ring->desc_size);
+	memset(skb->data, 0, ring->desc_size);
+
 	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 ring->desc_size),
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 92ca51c..b6fb1ce 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2435,6 +2435,8 @@ static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * First we create the beacon.
 	 */
 	skb_push(skb, TXD_DESC_SIZE);
+	memset(skb->data, 0, TXD_DESC_SIZE);
+
 	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 TXD_DESC_SIZE),
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 71699a7..091a37f 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1937,6 +1937,8 @@ static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 	 * First we create the beacon.
 	 */
 	skb_push(skb, TXD_DESC_SIZE);
+	memset(skb->data, 0, TXD_DESC_SIZE);
+
 	rt2x00lib_write_tx_desc(rt2x00dev, (struct data_desc *)skb->data,
 				(struct ieee80211_hdr *)(skb->data +
 							 TXD_DESC_SIZE),
-- 
1.5.3.4

