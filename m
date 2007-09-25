Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.185]:8076 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbXIYSog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Sep 2007 14:44:36 -0400
Received: by fk-out-0910.google.com with SMTP id z23so2123530fkz
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2007 11:44:34 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/12] rt2x00: Make *_beacon_update static
Date: Tue, 25 Sep 2007 20:53:43 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200709252052.34803.IvDoorn@gmail.com>
In-Reply-To: <200709252052.34803.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200709252053.44107.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make rt61pci_beacon_update and rt73usb_beacon_update static,
they are only used inside their own source file and then only
for setting it as callback funtion for mac80211.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt61pci.c |    2 +-
 drivers/net/wireless/rt2x00/rt73usb.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 09c8c96..69ed178 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2462,7 +2462,7 @@ static void rt61pci_reset_tsf(struct ieee80211_hw *hw)
 	rt2x00pci_register_write(rt2x00dev, TXRX_CSR13, 0);
 }
 
-int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 3397881..890b449 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1939,7 +1939,7 @@ static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
 	rt73usb_register_write(rt2x00dev, TXRX_CSR13, 0);
 }
 
-int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
+static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
-- 
1.5.3.2

