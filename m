Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35929 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbaITRpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2014 13:45:35 -0400
Received: by mail-wi0-f177.google.com with SMTP id q5so989468wiv.16
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2014 10:45:34 -0700 (PDT)
From: Andrea Merello <andrea.merello@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	bernhard@schiffner-limbach.de, dan.carpenter@oracle.com,
	xose.vazquez@gmail.com, ralf@czekalla.com,
	"andrea.merello" <andrea.merello@gmail.com>
Subject: [PATCH 1/1] rtl818x_pci: add RSSI information for rtl8187SE
Date: Sat, 20 Sep 2014 19:45:24 +0200
Message-Id: <1411235124-32022-1-git-send-email-andrea.merello@gmail.com> (sfid-20140920_194539_289500_60E38791)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "andrea.merello" <andrea.merello@gmail.com>

This patch makes the driver to report signal strength information
to mac80211 for rtl8187se boards.

It differs from my previous RFT patch:
http://marc.info/?l=linux-wireless&m=140155388332534&w=2
because:
- I have now a working rtl8187se card, so I could serve my RFT by myself. :)
- CCK measurement code has changed a bit, but it does basically the same things.
- OFDM measurement method is changed because the older method reported incorrect
  measures, at least for signals stronger than -40dBm).

CCK measurement seems quite good. OFDM seems less accurate, but this is the
same as the "reference" staging driver dose. I wanted not to change things just
to make measures of _one_ (my) card a bit more close to what _I_ (in my setup)
expected..

IMHO results are still good enough to justify reporting signal in dBm rather than in
"unspecified" units, so this is what this patch actually does.

Results of my tests with a working rtl8187se card connected with coaxes and
various RF attenuators to my AP are:

Input (approx) | CCK meas | OFDM meas
--------------------------------------
      -30dBm   |  -32dBm  |  -31dBm
      -40dBm   |  -40dBm  |  -41dBm
      -50dBm   |  -50dBm  |  -55dBm
      -60dBm   |  -59dBm  |  -63dBm
      -70dBm   |  -69dBm  |  -73dBm
      -80dBm   |  -79dBm  |  -83dBm

Also some real-field tests has been done (no coax, packets in the air) for the CCK
measure method, and they resulted in reasonable values.

Thanks-to: Bernhard Schiffner <bernhard@schiffner-limbach.de> [ for real-field tests]
Signed-off-by: andrea.merello <andrea.merello@gmail.com>
---
 drivers/net/wireless/rtl818x/rtl8180/dev.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
index 026d912..ded967a 100644
--- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
@@ -189,6 +189,9 @@ static const int rtl8187se_queues_map[RTL8187SE_NR_TX_QUEUES] = {5, 4, 3, 2, 7};
 
 static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {4, 7};
 
+/* LNA gain table for rtl8187se */
+static const u8 rtl8187se_lna_gain[4] = {02, 17, 29, 39};
+
 void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
 {
 	struct rtl8180_priv *priv = dev->priv;
@@ -210,13 +213,14 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 	struct rtl8180_priv *priv = dev->priv;
 	struct rtl818x_rx_cmd_desc *cmd_desc;
 	unsigned int count = 32;
-	u8 agc, sq, signal = 1;
+	u8 agc, sq;
+	s8 signal = 1;
 	dma_addr_t mapping;
 
 	while (count--) {
 		void *entry = priv->rx_ring + priv->rx_idx * priv->rx_ring_sz;
 		struct sk_buff *skb = priv->rx_buf[priv->rx_idx];
-		u32 flags, flags2;
+		u32 flags, flags2, flags3 = 0;
 		u64 tsft;
 
 		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
@@ -229,6 +233,7 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 			 * the ownership flag
 			 */
 			rmb();
+			flags3 = le32_to_cpu(desc->flags3);
 			flags2 = le32_to_cpu(desc->flags2);
 			tsft = le64_to_cpu(desc->tsft);
 		} else {
@@ -287,8 +292,21 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
 				signal = priv->rf->calc_rssi(agc, sq);
 				break;
 			case RTL818X_CHIP_FAMILY_RTL8187SE:
-				/* TODO: rtl8187se rssi */
-				signal = 10;
+				/* OFDM measure reported by HW is signed,
+				 * in 0.5dBm unit, with zero centered @ -41dBm
+				 * input signal.
+				 */
+				if (rx_status.rate_idx > 3) {
+					signal = (s8)((flags3 >> 16) & 0xff);
+					signal = signal / 2 - 41;
+				} else {
+					int idx, bb;
+
+					idx = (agc & 0x60) >> 5;
+					bb = (agc & 0x1F) * 2;
+					/* bias + BB gain + LNA gain */
+					signal = 4 - bb - rtl8187se_lna_gain[idx];
+				}
 				break;
 			}
 			rx_status.signal = signal;
@@ -1835,7 +1853,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		pci_try_set_mwi(pdev);
 	}
 
-	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
+	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180)
 		dev->flags |= IEEE80211_HW_SIGNAL_DBM;
 	else
 		dev->flags |= IEEE80211_HW_SIGNAL_UNSPEC;
-- 
1.9.1

