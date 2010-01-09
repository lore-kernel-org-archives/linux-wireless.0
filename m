Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f225.google.com ([209.85.220.225]:37494 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab0AIM74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 07:59:56 -0500
Received: by mail-fx0-f225.google.com with SMTP id 25so13340575fxm.21
        for <linux-wireless@vger.kernel.org>; Sat, 09 Jan 2010 04:59:55 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Sat, 09 Jan 2010 14:01:21 +0100
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 3/4] b43: N-PHY: add b43_nphy_get_ipa_gain_table and its
 tables
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u59nsjib9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |   20 +++++-
  drivers/net/wireless/b43/tables_nphy.c |  140 ++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    5 +
  3 files changed, 164 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 739973e..6452cb3 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -413,6 +413,24 @@ static u16 b43_nphy_classifier(struct b43_wldev *dev, u16 mask, u16 val)
  	return tmp;
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/GetIpaGainTbl */
+static const u32 * b43_nphy_get_ipa_gain_table(struct b43_wldev *dev)
+{
+	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
+		if (dev->phy.rev >= 6) {
+			/* TODO If the chip is 47162
+				return txpwrctrl_tx_gain_ipa_rev5 */
+			return txpwrctrl_tx_gain_ipa_rev6;
+		} else if (dev->phy.rev >= 5) {
+			return txpwrctrl_tx_gain_ipa_rev5;
+		} else {
+			return txpwrctrl_tx_gain_ipa;
+		}
+	} else {
+		return txpwrctrl_tx_gain_ipa_5g;
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/carriersearch */
  static void b43_nphy_stay_in_carrier_search(struct b43_wldev *dev, bool enable)
  {
@@ -483,7 +501,7 @@ static struct nphy_txgains b43_nphy_get_tx_gains(struct b43_wldev *dev)

  				if ((nphy->ipa2g_on && band == IEEE80211_BAND_2GHZ) ||
  				    (nphy->ipa5g_on && band == IEEE80211_BAND_5GHZ)) {
-					table = NULL; //FIXME: = output of N PHY Get IPA GainTbl
+					table = b43_nphy_get_ipa_gain_table(dev);
  				} else {
  					if (band == IEEE80211_BAND_5GHZ) {
  						if (dev->phy.rev == 3)
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 9fa527d..3779f1d 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2581,6 +2581,146 @@ const u32 b43_ntab_tx_gain_rev5plus_5ghz[] = {
  	0x0062003b, 0x00620039, 0x00620037, 0x00620035,
  };

+const u32 txpwrctrl_tx_gain_ipa[] = {
+	0x5ff7002d, 0x5ff7002b, 0x5ff7002a, 0x5ff70029,
+	0x5ff70028, 0x5ff70027, 0x5ff70026, 0x5ff70025,
+	0x5ef7002d, 0x5ef7002b, 0x5ef7002a, 0x5ef70029,
+	0x5ef70028, 0x5ef70027, 0x5ef70026, 0x5ef70025,
+	0x5df7002d, 0x5df7002b, 0x5df7002a, 0x5df70029,
+	0x5df70028, 0x5df70027, 0x5df70026, 0x5df70025,
+	0x5cf7002d, 0x5cf7002b, 0x5cf7002a, 0x5cf70029,
+	0x5cf70028, 0x5cf70027, 0x5cf70026, 0x5cf70025,
+	0x5bf7002d, 0x5bf7002b, 0x5bf7002a, 0x5bf70029,
+	0x5bf70028, 0x5bf70027, 0x5bf70026, 0x5bf70025,
+	0x5af7002d, 0x5af7002b, 0x5af7002a, 0x5af70029,
+	0x5af70028, 0x5af70027, 0x5af70026, 0x5af70025,
+	0x59f7002d, 0x59f7002b, 0x59f7002a, 0x59f70029,
+	0x59f70028, 0x59f70027, 0x59f70026, 0x59f70025,
+	0x58f7002d, 0x58f7002b, 0x58f7002a, 0x58f70029,
+	0x58f70028, 0x58f70027, 0x58f70026, 0x58f70025,
+	0x57f7002d, 0x57f7002b, 0x57f7002a, 0x57f70029,
+	0x57f70028, 0x57f70027, 0x57f70026, 0x57f70025,
+	0x56f7002d, 0x56f7002b, 0x56f7002a, 0x56f70029,
+	0x56f70028, 0x56f70027, 0x56f70026, 0x56f70025,
+	0x55f7002d, 0x55f7002b, 0x55f7002a, 0x55f70029,
+	0x55f70028, 0x55f70027, 0x55f70026, 0x55f70025,
+	0x54f7002d, 0x54f7002b, 0x54f7002a, 0x54f70029,
+	0x54f70028, 0x54f70027, 0x54f70026, 0x54f70025,
+	0x53f7002d, 0x53f7002b, 0x53f7002a, 0x53f70029,
+	0x53f70028, 0x53f70027, 0x53f70026, 0x53f70025,
+	0x52f7002d, 0x52f7002b, 0x52f7002a, 0x52f70029,
+	0x52f70028, 0x52f70027, 0x52f70026, 0x52f70025,
+	0x51f7002d, 0x51f7002b, 0x51f7002a, 0x51f70029,
+	0x51f70028, 0x51f70027, 0x51f70026, 0x51f70025,
+	0x50f7002d, 0x50f7002b, 0x50f7002a, 0x50f70029,
+	0x50f70028, 0x50f70027, 0x50f70026, 0x50f70025,
+};
+
+const u32 txpwrctrl_tx_gain_ipa_rev5[] = {
+	0x1ff7002d, 0x1ff7002b, 0x1ff7002a, 0x1ff70029,
+	0x1ff70028, 0x1ff70027, 0x1ff70026, 0x1ff70025,
+	0x1ef7002d, 0x1ef7002b, 0x1ef7002a, 0x1ef70029,
+	0x1ef70028, 0x1ef70027, 0x1ef70026, 0x1ef70025,
+	0x1df7002d, 0x1df7002b, 0x1df7002a, 0x1df70029,
+	0x1df70028, 0x1df70027, 0x1df70026, 0x1df70025,
+	0x1cf7002d, 0x1cf7002b, 0x1cf7002a, 0x1cf70029,
+	0x1cf70028, 0x1cf70027, 0x1cf70026, 0x1cf70025,
+	0x1bf7002d, 0x1bf7002b, 0x1bf7002a, 0x1bf70029,
+	0x1bf70028, 0x1bf70027, 0x1bf70026, 0x1bf70025,
+	0x1af7002d, 0x1af7002b, 0x1af7002a, 0x1af70029,
+	0x1af70028, 0x1af70027, 0x1af70026, 0x1af70025,
+	0x19f7002d, 0x19f7002b, 0x19f7002a, 0x19f70029,
+	0x19f70028, 0x19f70027, 0x19f70026, 0x19f70025,
+	0x18f7002d, 0x18f7002b, 0x18f7002a, 0x18f70029,
+	0x18f70028, 0x18f70027, 0x18f70026, 0x18f70025,
+	0x17f7002d, 0x17f7002b, 0x17f7002a, 0x17f70029,
+	0x17f70028, 0x17f70027, 0x17f70026, 0x17f70025,
+	0x16f7002d, 0x16f7002b, 0x16f7002a, 0x16f70029,
+	0x16f70028, 0x16f70027, 0x16f70026, 0x16f70025,
+	0x15f7002d, 0x15f7002b, 0x15f7002a, 0x15f70029,
+	0x15f70028, 0x15f70027, 0x15f70026, 0x15f70025,
+	0x14f7002d, 0x14f7002b, 0x14f7002a, 0x14f70029,
+	0x14f70028, 0x14f70027, 0x14f70026, 0x14f70025,
+	0x13f7002d, 0x13f7002b, 0x13f7002a, 0x13f70029,
+	0x13f70028, 0x13f70027, 0x13f70026, 0x13f70025,
+	0x12f7002d, 0x12f7002b, 0x12f7002a, 0x12f70029,
+	0x12f70028, 0x12f70027, 0x12f70026, 0x12f70025,
+	0x11f7002d, 0x11f7002b, 0x11f7002a, 0x11f70029,
+	0x11f70028, 0x11f70027, 0x11f70026, 0x11f70025,
+	0x10f7002d, 0x10f7002b, 0x10f7002a, 0x10f70029,
+	0x10f70028, 0x10f70027, 0x10f70026, 0x10f70025,
+};
+
+const u32 txpwrctrl_tx_gain_ipa_rev6[] = {
+	0x0ff7002d, 0x0ff7002b, 0x0ff7002a, 0x0ff70029,
+	0x0ff70028, 0x0ff70027, 0x0ff70026, 0x0ff70025,
+	0x0ef7002d, 0x0ef7002b, 0x0ef7002a, 0x0ef70029,
+	0x0ef70028, 0x0ef70027, 0x0ef70026, 0x0ef70025,
+	0x0df7002d, 0x0df7002b, 0x0df7002a, 0x0df70029,
+	0x0df70028, 0x0df70027, 0x0df70026, 0x0df70025,
+	0x0cf7002d, 0x0cf7002b, 0x0cf7002a, 0x0cf70029,
+	0x0cf70028, 0x0cf70027, 0x0cf70026, 0x0cf70025,
+	0x0bf7002d, 0x0bf7002b, 0x0bf7002a, 0x0bf70029,
+	0x0bf70028, 0x0bf70027, 0x0bf70026, 0x0bf70025,
+	0x0af7002d, 0x0af7002b, 0x0af7002a, 0x0af70029,
+	0x0af70028, 0x0af70027, 0x0af70026, 0x0af70025,
+	0x09f7002d, 0x09f7002b, 0x09f7002a, 0x09f70029,
+	0x09f70028, 0x09f70027, 0x09f70026, 0x09f70025,
+	0x08f7002d, 0x08f7002b, 0x08f7002a, 0x08f70029,
+	0x08f70028, 0x08f70027, 0x08f70026, 0x08f70025,
+	0x07f7002d, 0x07f7002b, 0x07f7002a, 0x07f70029,
+	0x07f70028, 0x07f70027, 0x07f70026, 0x07f70025,
+	0x06f7002d, 0x06f7002b, 0x06f7002a, 0x06f70029,
+	0x06f70028, 0x06f70027, 0x06f70026, 0x06f70025,
+	0x05f7002d, 0x05f7002b, 0x05f7002a, 0x05f70029,
+	0x05f70028, 0x05f70027, 0x05f70026, 0x05f70025,
+	0x04f7002d, 0x04f7002b, 0x04f7002a, 0x04f70029,
+	0x04f70028, 0x04f70027, 0x04f70026, 0x04f70025,
+	0x03f7002d, 0x03f7002b, 0x03f7002a, 0x03f70029,
+	0x03f70028, 0x03f70027, 0x03f70026, 0x03f70025,
+	0x02f7002d, 0x02f7002b, 0x02f7002a, 0x02f70029,
+	0x02f70028, 0x02f70027, 0x02f70026, 0x02f70025,
+	0x01f7002d, 0x01f7002b, 0x01f7002a, 0x01f70029,
+	0x01f70028, 0x01f70027, 0x01f70026, 0x01f70025,
+	0x00f7002d, 0x00f7002b, 0x00f7002a, 0x00f70029,
+	0x00f70028, 0x00f70027, 0x00f70026, 0x00f70025,
+};
+
+const u32 txpwrctrl_tx_gain_ipa_5g[] = {
+	0x7ff70035, 0x7ff70033, 0x7ff70032, 0x7ff70031,
+	0x7ff7002f, 0x7ff7002e, 0x7ff7002d, 0x7ff7002b,
+	0x7ff7002a, 0x7ff70029, 0x7ff70028, 0x7ff70027,
+	0x7ff70026, 0x7ff70024, 0x7ff70023, 0x7ff70022,
+	0x7ef70028, 0x7ef70027, 0x7ef70026, 0x7ef70025,
+	0x7ef70024, 0x7ef70023, 0x7df70028, 0x7df70027,
+	0x7df70026, 0x7df70025, 0x7df70024, 0x7df70023,
+	0x7df70022, 0x7cf70029, 0x7cf70028, 0x7cf70027,
+	0x7cf70026, 0x7cf70025, 0x7cf70023, 0x7cf70022,
+	0x7bf70029, 0x7bf70028, 0x7bf70026, 0x7bf70025,
+	0x7bf70024, 0x7bf70023, 0x7bf70022, 0x7bf70021,
+	0x7af70029, 0x7af70028, 0x7af70027, 0x7af70026,
+	0x7af70025, 0x7af70024, 0x7af70023, 0x7af70022,
+	0x79f70029, 0x79f70028, 0x79f70027, 0x79f70026,
+	0x79f70025, 0x79f70024, 0x79f70023, 0x79f70022,
+	0x78f70029, 0x78f70028, 0x78f70027, 0x78f70026,
+	0x78f70025, 0x78f70024, 0x78f70023, 0x78f70022,
+	0x77f70029, 0x77f70028, 0x77f70027, 0x77f70026,
+	0x77f70025, 0x77f70024, 0x77f70023, 0x77f70022,
+	0x76f70029, 0x76f70028, 0x76f70027, 0x76f70026,
+	0x76f70024, 0x76f70023, 0x76f70022, 0x76f70021,
+	0x75f70029, 0x75f70028, 0x75f70027, 0x75f70026,
+	0x75f70025, 0x75f70024, 0x75f70023, 0x74f70029,
+	0x74f70028, 0x74f70026, 0x74f70025, 0x74f70024,
+	0x74f70023, 0x74f70022, 0x73f70029, 0x73f70027,
+	0x73f70026, 0x73f70025, 0x73f70024, 0x73f70023,
+	0x73f70022, 0x72f70028, 0x72f70027, 0x72f70026,
+	0x72f70025, 0x72f70024, 0x72f70023, 0x72f70022,
+	0x71f70028, 0x71f70027, 0x71f70026, 0x71f70025,
+	0x71f70024, 0x71f70023, 0x70f70028, 0x70f70027,
+	0x70f70026, 0x70f70024, 0x70f70023, 0x70f70022,
+	0x70f70021, 0x70f70020, 0x70f70020, 0x70f7001f,
+};
+
  static inline void assert_ntab_array_sizes(void)
  {
  #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 423c884..62b1745 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -137,4 +137,9 @@ extern const u32 b43_ntab_tx_gain_rev3_5ghz[];
  extern const u32 b43_ntab_tx_gain_rev4_5ghz[];
  extern const u32 b43_ntab_tx_gain_rev5plus_5ghz[];

+extern const u32 txpwrctrl_tx_gain_ipa[];
+extern const u32 txpwrctrl_tx_gain_ipa_rev5[];
+extern const u32 txpwrctrl_tx_gain_ipa_rev6[];
+extern const u32 txpwrctrl_tx_gain_ipa_5g[];
+
  #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

