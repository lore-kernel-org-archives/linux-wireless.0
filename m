Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-db5eur01on0118.outbound.protection.outlook.com ([104.47.2.118]:51456
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1032204AbeBNQ0o (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Feb 2018 11:26:44 -0500
From: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@qca.qualcomm.com" <ath9k-devel@qca.qualcomm.com>
Subject: [PATCH v2] ath9k: mark RSSI as invalid if frame received during
 channel setup
Date: Wed, 14 Feb 2018 16:26:42 +0000
Message-ID: <AM4PR0101MB230538DEEFCFFC0E0F4437A2E4F50@AM4PR0101MB2305.eurprd01.prod.exchangelabs.com> (sfid-20180214_172648_842860_6A5D18EB)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k returns a wrong RSSI value for frames received in a 30ms time
window after a channel change. The correct value is typically 10dB
below the returned value.

This was found with a Atheros AR9300 Rev:3 chip (WLE350NX / JWX6083
cards), during offchannel scans.

Mark the signal value as invalid in this case.

Signed-off-by: Jean Pierre TOSONI <jp.tosoni@acksys.fr>
---
V2: replace LEDE patch with due kernel patch (with excuses to Kalle Valo)

 drivers/net/wireless/ath/ath9k/ani.c    |    1 +
 drivers/net/wireless/ath/ath9k/common.c |   10 ++++++++++
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ani.c b/drivers/net/wireless/at=
h/ath9k/ani.c
index 5214dd7..a7e07ed 100644
--- a/drivers/net/wireless/ath/ath9k/ani.c
+++ b/drivers/net/wireless/ath/ath9k/ani.c
@@ -317,6 +317,7 @@ void ath9k_ani_reset(struct ath_hw *ah, bool is_scannin=
g)
 		return;
=20
 	BUG_ON(aniState =3D=3D NULL);
+	ah->chan_stable_time =3D jiffies + (30*HZ)/1000; /* 30ms */
 	ah->stats.ast_ani_reset++;
=20
 	ofdm_nil =3D max_t(int, ATH9K_ANI_OFDM_DEF_LEVEL,
diff --git a/drivers/net/wireless/ath/ath9k/common.c b/drivers/net/wireless=
/ath/ath9k/common.c
index 099f3d4..7e5f7a3 100644
--- a/drivers/net/wireless/ath/ath9k/common.c
+++ b/drivers/net/wireless/ath/ath9k/common.c
@@ -221,6 +221,16 @@ void ath9k_cmn_process_rssi(struct ath_common *common,
 	int i, j;
=20
 	/*
+	 * RSSI is not available before 30ms after reset on ath9k.
+	 */
+	if (time_before(jiffies, ah->chan_stable_time)) {
+		ath_dbg(common, ANY, "early frame rssi=3D%d\n",rx_stats->rs_rssi);
+		rxs->flag |=3D RX_FLAG_NO_SIGNAL_VAL;
+		return;
+	}
+	ah->chan_stable_time =3D jiffies; /* advance stable time to cop with jiff=
ies wraparound */
+
+	/*
 	 * RSSI is not available for subframes in an A-MPDU.
 	 */
 	if (rx_stats->rs_moreaggr) {
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath=
/ath9k/hw.h
index 9804a24..ec07da9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -809,6 +809,7 @@ struct ath_hw {
=20
 	bool reset_power_on;
 	bool htc_reset_init;
+	unsigned long chan_stable_time;
=20
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
--=20
1.7.2.5
