Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53071 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab0ALTiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2010 14:38:24 -0500
Received: by ey-out-2122.google.com with SMTP id 22so2214291eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2010 11:38:22 -0800 (PST)
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] b43: N-PHY: add b43_nphy_iq_cal_gain_params
Date: Tue, 12 Jan 2010 20:38:20 +0100
MIME-Version: 1.0
From: =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Message-ID: <op.u6fp56sg9lhzdc@linux-g0th.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
  drivers/net/wireless/b43/phy_n.c       |   40 ++++++++++++++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.c |   25 ++++++++++++++++++++
  drivers/net/wireless/b43/tables_nphy.h |    1 +
  3 files changed, 66 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/b43/phy_n.c b/drivers/net/wireless/b43/phy_n.c
index 7b2468d..ea1af25 100644
--- a/drivers/net/wireless/b43/phy_n.c
+++ b/drivers/net/wireless/b43/phy_n.c
@@ -31,6 +31,8 @@


  struct nphy_txgains { u16 txgm[2]; u16 pga[2]; u16 pad[2]; u16 ipa[2]; };
+struct nphy_iqcal_params { u16 txgm; u16 pga; u16 pad; u16 ipa; u16 cal_gain;
+				u16 ncorr[5]; };
  struct nphy_iq_est { s32 iq0_prod; u32 i0_pwr; u32 q0_pwr; s32 iq1_prod;
  			u32 i1_pwr; u32 q1_pwr; };

@@ -512,6 +514,44 @@ static void b43_nphy_rx_iq_est(struct b43_wldev *dev, struct nphy_iq_est *est,
  	memset(est, 0, sizeof(*est));
  }

+/* http://bcm-v4.sipsolutions.net/802.11/PHY/N/IqCalGainParams */
+static void b43_nphy_iq_cal_gain_params(struct b43_wldev *dev, u16 core,
+					struct nphy_txgains target,
+					struct nphy_iqcal_params *params)
+{
+	int i, j, indx;
+	u16 gain;
+
+	if (dev->phy.rev >= 3) {
+		params->txgm = target.txgm[core];
+		params->pga = target.pga[core];
+		params->pad = target.pad[core];
+		params->ipa = target.ipa[core];
+		params->cal_gain = (params->txgm << 12) | (params->pga << 8) |
+					(params->pad << 4) | (params->ipa);
+		for (j = 0; j < 5; j++)
+			params->ncorr[j] = 0x79;
+	} else {
+		gain = (target.pad[core]) | (target.pga[core] << 4) |
+			(target.txgm[core] << 8);
+
+		indx = (b43_current_band(dev->wl) == IEEE80211_BAND_5GHZ) ?
+			1 : 0;
+		for (i = 0; i < 9; i++)
+			if (tbl_iqcal_gainparams[indx][i][0] == gain)
+				break;
+		i = min(i, 8);
+
+		params->txgm = tbl_iqcal_gainparams[indx][i][1];
+		params->pga = tbl_iqcal_gainparams[indx][i][2];
+		params->pad = tbl_iqcal_gainparams[indx][i][3];
+		params->cal_gain = (params->txgm << 7) | (params->pga << 4) |
+					(params->pad << 2);
+		for (j = 0; j < 4; j++)
+			params->ncorr[j] = tbl_iqcal_gainparams[indx][i][4 + j];
+	}
+}
+
  /* http://bcm-v4.sipsolutions.net/802.11/PHY/N/TxIqWar */
  static void b43_nphy_tx_iq_workaround(struct b43_wldev *dev)
  {
diff --git a/drivers/net/wireless/b43/tables_nphy.c b/drivers/net/wireless/b43/tables_nphy.c
index 3779f1d..de8a609 100644
--- a/drivers/net/wireless/b43/tables_nphy.c
+++ b/drivers/net/wireless/b43/tables_nphy.c
@@ -2721,6 +2721,31 @@ const u32 txpwrctrl_tx_gain_ipa_5g[] = {
  	0x70f70021, 0x70f70020, 0x70f70020, 0x70f7001f,
  };

+const u16 tbl_iqcal_gainparams[2][9][8] = {
+	{
+		{ 0x000, 0, 0, 2, 0x69, 0x69, 0x69, 0x69 },
+		{ 0x700, 7, 0, 0, 0x69, 0x69, 0x69, 0x69 },
+		{ 0x710, 7, 1, 0, 0x68, 0x68, 0x68, 0x68 },
+		{ 0x720, 7, 2, 0, 0x67, 0x67, 0x67, 0x67 },
+		{ 0x730, 7, 3, 0, 0x66, 0x66, 0x66, 0x66 },
+		{ 0x740, 7, 4, 0, 0x65, 0x65, 0x65, 0x65 },
+		{ 0x741, 7, 4, 1, 0x65, 0x65, 0x65, 0x65 },
+		{ 0x742, 7, 4, 2, 0x65, 0x65, 0x65, 0x65 },
+		{ 0x743, 7, 4, 3, 0x65, 0x65, 0x65, 0x65 }
+	},
+	{
+		{ 0x000, 7, 0, 0, 0x79, 0x79, 0x79, 0x79 },
+		{ 0x700, 7, 0, 0, 0x79, 0x79, 0x79, 0x79 },
+		{ 0x710, 7, 1, 0, 0x79, 0x79, 0x79, 0x79 },
+		{ 0x720, 7, 2, 0, 0x78, 0x78, 0x78, 0x78 },
+		{ 0x730, 7, 3, 0, 0x78, 0x78, 0x78, 0x78 },
+		{ 0x740, 7, 4, 0, 0x78, 0x78, 0x78, 0x78 },
+		{ 0x741, 7, 4, 1, 0x78, 0x78, 0x78, 0x78 },
+		{ 0x742, 7, 4, 2, 0x78, 0x78, 0x78, 0x78 },
+		{ 0x743, 7, 4, 3, 0x78, 0x78, 0x78, 0x78 }
+	}
+};
+
  static inline void assert_ntab_array_sizes(void)
  {
  #undef check
diff --git a/drivers/net/wireless/b43/tables_nphy.h b/drivers/net/wireless/b43/tables_nphy.h
index 62b1745..86c394c 100644
--- a/drivers/net/wireless/b43/tables_nphy.h
+++ b/drivers/net/wireless/b43/tables_nphy.h
@@ -141,5 +141,6 @@ extern const u32 txpwrctrl_tx_gain_ipa[];
  extern const u32 txpwrctrl_tx_gain_ipa_rev5[];
  extern const u32 txpwrctrl_tx_gain_ipa_rev6[];
  extern const u32 txpwrctrl_tx_gain_ipa_5g[];
+extern const u16 tbl_iqcal_gainparams[2][9][8];

  #endif /* B43_TABLES_NPHY_H_ */
-- 
1.6.4.2

