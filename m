Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:41129 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaEaQbL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 12:31:11 -0400
Received: by mail-wi0-f181.google.com with SMTP id n15so2652038wiw.8
        for <linux-wireless@vger.kernel.org>; Sat, 31 May 2014 09:31:10 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	Andrea Merello <andrea.merello@gmail.com>
Subject: [RFT] rtl818x_pci: add RSSI information for rtl8187SE
Date: Sat, 31 May 2014 18:30:58 +0200
Message-Id: <1401553858-7784-1-git-send-email-andrea.merello@gmail.com> (sfid-20140531_183126_632022_4CD23F62)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch makes the driver to report signal stength information
to mac80211 for rtl8187se boards.

My card has probably an HW problem, because it suffers of bad
RX sensitivity (even on other OSes), so I could only test that
the information is somewhat proportional to the signal RXed.

Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 1e25929..b41267c 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -188,6 +188,9 @@ static const int rtl8187se_queues_map[RTL8187SE_NR_TX_QUEUES] = {5, 4, 3, 2, 7};

 static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {4, 7};

+/* LNA gain table for rtl8187se */
+static const u8 rtl8187se_lna_gain[4] = {02, 17, 29, 39};
+
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -215,7 +218,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 	while (count--) {
 		void *entry = priv->rx_ring + priv->rx_idx * priv->rx_ring_sz;
 		struct sk_buff *skb = priv->rx_buf[priv->rx_idx];
-		u32 flags, flags2;
+		u32 flags, flags2, flags3;
 		u64 tsft;

 		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
@@ -229,6 +232,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			 */
 			rmb();
 			flags2 = le32_to_cpu(desc->flags2);
+			flags3 = le32_to_cpu(desc->flags3);
 			tsft = le64_to_cpu(desc->tsft);
 		} else {
 			struct rtl8180_rx_desc *desc = entry;
@@ -237,6 +241,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			/* same as above */
 			rmb();
 			flags2 = le32_to_cpu(desc->flags2);
+			flags3 = 0; /* not used. get rid of GCC warn */
 			tsft = le64_to_cpu(desc->tsft);
 		}

@@ -275,6 +280,11 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			agc = (flags2 >> 17) & 0x7F;

 			switch (priv->chip_family) {
+			case RTL818X_CHIP_FAMILY_RTL8187SE:
+				/* bias + BB gain + LNA gain */
+				agc = -4 + (agc & 0x1F) * 2 +
+					rtl8187se_lna_gain[(agc & 0x60) >> 5];
+				/* fall through */
 			case RTL818X_CHIP_FAMILY_RTL8185:
 				if (rx_status.rate_idx > 3)
 					signal = -clamp_t(u8, agc, 25, 90) - 9;
@@ -285,10 +295,6 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 				sq = flags2 & 0xff;
 				signal = priv->rf->calc_rssi(agc, sq);
 				break;
-			case RTL818X_CHIP_FAMILY_RTL8187SE:
-				/* TODO: rtl8187se rssi */
-				signal = 10;
-				break;
 			}
 			rx_status.signal = signal;
 			rx_status.freq = dev->conf.chandef.chan->center_freq;
@@ -1819,7 +1825,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		pci_try_set_mwi(pdev);
 	}

-	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
+	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180)
 		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
 	else
 		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
--
1.9.1
