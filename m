Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:28903 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYBQQgA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 17 Feb 2008 11:36:00 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1209783mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 17 Feb 2008 08:35:58 -0800 (PST)
To: linville@tuxdriver.com
Subject: [PATCH 05/11] rt2x00: Remove reset_tsf()
Date: Sun, 17 Feb 2008 17:33:57 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200802171730.44353.IvDoorn@gmail.com>
In-Reply-To: <200802171730.44353.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802171733.58144.IvDoorn@gmail.com> (sfid-20080217_163614_330086_9D78E8A4)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Specifications indicate the TSF registers are read-only,
so there is no point in writing 0 to those registers.

As far as I know there isn't another way to reset the
TSF registers. So removing these callbacks will notify
mac80211 about the lack of support.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    9 ---------
 drivers/net/wireless/rt2x00/rt2500pci.c |    9 ---------
 drivers/net/wireless/rt2x00/rt61pci.c   |    9 ---------
 drivers/net/wireless/rt2x00/rt73usb.c   |    9 ---------
 4 files changed, 0 insertions(+), 36 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index a80385d..23b14b0 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1506,14 +1506,6 @@ static u64 rt2400pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void rt2400pci_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt2x00pci_register_write(rt2x00dev, CSR16, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR17, 0);
-}
-
 static int rt2400pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 				   struct ieee80211_tx_control *control)
 {
@@ -1582,7 +1574,6 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.conf_tx		= rt2400pci_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2400pci_get_tsf,
-	.reset_tsf		= rt2400pci_reset_tsf,
 	.beacon_update		= rt2400pci_beacon_update,
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 };
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 4a6a60a..26e1fcc 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1817,14 +1817,6 @@ static u64 rt2500pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void rt2500pci_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt2x00pci_register_write(rt2x00dev, CSR16, 0);
-	rt2x00pci_register_write(rt2x00dev, CSR17, 0);
-}
-
 static int rt2500pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 				   struct ieee80211_tx_control *control)
 {
@@ -1893,7 +1885,6 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt2500pci_get_tsf,
-	.reset_tsf		= rt2500pci_reset_tsf,
 	.beacon_update		= rt2500pci_beacon_update,
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 };
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 722d734..3b10452 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2362,14 +2362,6 @@ static u64 rt61pci_get_tsf(struct ieee80211_hw *hw)
 	return tsf;
 }
 
-static void rt61pci_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR12, 0);
-	rt2x00pci_register_write(rt2x00dev, TXRX_CSR13, 0);
-}
-
 static int rt61pci_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_tx_control *control)
 {
@@ -2446,7 +2438,6 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt61pci_get_tsf,
-	.reset_tsf		= rt61pci_reset_tsf,
 	.beacon_update		= rt61pci_beacon_update,
 };
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 615415a..43f5676 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -1968,14 +1968,6 @@ static u64 rt73usb_get_tsf(struct ieee80211_hw *hw)
 #define rt73usb_get_tsf	NULL
 #endif
 
-static void rt73usb_reset_tsf(struct ieee80211_hw *hw)
-{
-	struct rt2x00_dev *rt2x00dev = hw->priv;
-
-	rt73usb_register_write(rt2x00dev, TXRX_CSR12, 0);
-	rt73usb_register_write(rt2x00dev, TXRX_CSR13, 0);
-}
-
 static int rt73usb_beacon_update(struct ieee80211_hw *hw, struct sk_buff *skb,
 				 struct ieee80211_tx_control *control)
 {
@@ -2043,7 +2035,6 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.conf_tx		= rt2x00mac_conf_tx,
 	.get_tx_stats		= rt2x00mac_get_tx_stats,
 	.get_tsf		= rt73usb_get_tsf,
-	.reset_tsf		= rt73usb_reset_tsf,
 	.beacon_update		= rt73usb_beacon_update,
 };
 
-- 
1.5.4

