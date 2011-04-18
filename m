Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40169 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab1DRNgW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 09:36:22 -0400
Received: by mail-fx0-f46.google.com with SMTP id 17so2833906fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 18 Apr 2011 06:36:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 22/23] rt2x00: Implement get_ringparam callback function
Date: Mon, 18 Apr 2011 15:34:41 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201104181526.01722.IvDoorn@gmail.com> <201104181534.02553.IvDoorn@gmail.com> <201104181534.23133.IvDoorn@gmail.com>
In-Reply-To: <201104181534.23133.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201104181534.42625.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ivo van Doorn <IvDoorn@gmail.com>

With the get_ringparam callback function we can export ring parameters
to ethtool through the mac80211 interface.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2800pci.c |    1 +
 drivers/net/wireless/rt2x00/rt2800usb.c |    1 +
 drivers/net/wireless/rt2x00/rt2x00.h    |    2 ++
 drivers/net/wireless/rt2x00/rt2x00mac.c |   16 ++++++++++++++++
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 +
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 +
 9 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2400pci.c b/drivers/net/wireless/rt2x00/rt2400pci.c
index d4acdde..bbe76f7 100644
--- a/drivers/net/wireless/rt2x00/rt2400pci.c
+++ b/drivers/net/wireless/rt2x00/rt2400pci.c
@@ -1720,6 +1720,7 @@ static const struct ieee80211_ops rt2400pci_mac80211_ops = {
 	.tx_last_beacon		= rt2400pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2x00lib_ops rt2400pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 15f5649..6f48996 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -2013,6 +2013,7 @@ static const struct ieee80211_ops rt2500pci_mac80211_ops = {
 	.tx_last_beacon		= rt2500pci_tx_last_beacon,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2x00lib_ops rt2500pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index d88c367..5ef3386 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1823,6 +1823,7 @@ static const struct ieee80211_ops rt2500usb_mac80211_ops = {
 	.conf_tx		= rt2x00mac_conf_tx,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2x00lib_ops rt2500usb_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800pci.c b/drivers/net/wireless/rt2x00/rt2800pci.c
index b0c729b..08d3947 100644
--- a/drivers/net/wireless/rt2x00/rt2800pci.c
+++ b/drivers/net/wireless/rt2x00/rt2800pci.c
@@ -1028,6 +1028,7 @@ static const struct ieee80211_ops rt2800pci_mac80211_ops = {
 	.ampdu_action		= rt2800_ampdu_action,
 	.flush			= rt2x00mac_flush,
 	.get_survey		= rt2800_get_survey,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2800_ops rt2800pci_rt2800_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 44ead75..0d4e8fa 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -673,6 +673,7 @@ static const struct ieee80211_ops rt2800usb_mac80211_ops = {
 	.ampdu_action		= rt2800_ampdu_action,
 	.flush			= rt2x00mac_flush,
 	.get_survey		= rt2800_get_survey,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2800_ops rt2800usb_rt2800_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index dcdc50d..f1d8f55 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -1254,6 +1254,8 @@ int rt2x00mac_conf_tx(struct ieee80211_hw *hw, u16 queue,
 		      const struct ieee80211_tx_queue_params *params);
 void rt2x00mac_rfkill_poll(struct ieee80211_hw *hw);
 void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop);
+void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
+			     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max);
 
 /*
  * Driver allocation handlers.
diff --git a/drivers/net/wireless/rt2x00/rt2x00mac.c b/drivers/net/wireless/rt2x00/rt2x00mac.c
index 4770156..6d1d383 100644
--- a/drivers/net/wireless/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/rt2x00/rt2x00mac.c
@@ -737,3 +737,19 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, bool drop)
 		rt2x00queue_flush_queue(queue, drop);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
+
+void rt2x00mac_get_ringparam(struct ieee80211_hw *hw,
+			     u32 *tx, u32 *tx_max, u32 *rx, u32 *rx_max)
+{
+	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct data_queue *queue;
+
+	tx_queue_for_each(rt2x00dev, queue) {
+		*tx += queue->length;
+		*tx_max += queue->limit;
+	}
+
+	*rx = rt2x00dev->rx->length;
+	*rx_max = rt2x00dev->rx->limit;
+}
+EXPORT_SYMBOL_GPL(rt2x00mac_get_ringparam);
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index c5dccdb..eb54031 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -2979,6 +2979,7 @@ static const struct ieee80211_ops rt61pci_mac80211_ops = {
 	.get_tsf		= rt61pci_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2x00lib_ops rt61pci_rt2x00_ops = {
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index be3eb5e..bf7fea4 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -2310,6 +2310,7 @@ static const struct ieee80211_ops rt73usb_mac80211_ops = {
 	.get_tsf		= rt73usb_get_tsf,
 	.rfkill_poll		= rt2x00mac_rfkill_poll,
 	.flush			= rt2x00mac_flush,
+	.get_ringparam		= rt2x00mac_get_ringparam,
 };
 
 static const struct rt2x00lib_ops rt73usb_rt2x00_ops = {
-- 
1.7.2.3

