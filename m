Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:49813 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbZCVUCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 16:02:32 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.2.6/Switch-3.2.6) with ESMTP id n2MK2Moa015714
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 15:02:29 -0500
Received: from [127.0.1.1] (essapo-nirac253178.europe.nokia.com [10.162.253.178])
	by mgw-int01.ntc.nokia.com (Switch-3.2.5/Switch-3.2.5) with ESMTP id n2MK2MhJ031422
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 22:02:22 +0200
From: Kalle Valo <kalle.valo@nokia.com>
Subject: [PATCH] stlc45xx: add beacon filtering support
To: linux-wireless@vger.kernel.org
Date: Sun, 22 Mar 2009 22:02:22 +0200
Message-ID: <20090322200221.26623.95692.stgit@tikku> (sfid-20090322_210235_312144_0F28FEB5)
In-Reply-To: <20090322195619.26460.48292.stgit@tikku>
References: <20090322195619.26460.48292.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Experimental patch.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 stlc45xx.c |   40 ++++++++++++++++++++++++++++++++++------
 1 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/stlc45xx.c b/stlc45xx.c
index ca7bfa2..6d5d4e5 100644
--- a/stlc45xx.c
+++ b/stlc45xx.c
@@ -1263,6 +1263,28 @@ static int stlc45xx_rx_txack(struct stlc45xx *stlc, struct sk_buff *skb)
 	return 0;
 }
 
+static int stlc45xx_rx_trap(struct stlc45xx *stlc, struct sk_buff *skb)
+{
+	struct s_lm_control *control;
+	struct s_lmo_trap *trap;
+
+	stlc45xx_debug(DEBUG_FUNC, "%s", __func__);
+
+	control = (struct s_lm_control *) skb->data;
+	trap = (struct s_lmo_trap *) (control + 1);
+
+	switch (trap->event) {
+	case LM_TRAP_NO_BEACON:
+		ieee80211_beacon_loss(stlc->vif);
+		break;
+	default:
+		stlc45xx_warning("unhandled trap: %d\n", trap->event);
+		break;
+	}
+	
+	return 0;
+}
+
 static int stlc45xx_rx_control(struct stlc45xx *stlc, struct sk_buff *skb)
 {
 	struct s_lm_control *control;
@@ -1276,9 +1298,11 @@ static int stlc45xx_rx_control(struct stlc45xx *stlc, struct sk_buff *skb)
 	case LM_OID_TX:
 		ret = stlc45xx_rx_txack(stlc, skb);
 		break;
+	case LM_OID_TRAP:
+		ret = stlc45xx_rx_trap(stlc, skb);
+		break;
 	case LM_OID_SETUP:
 	case LM_OID_SCAN:
-	case LM_OID_TRAP:
 	case LM_OID_EDCF:
 	case LM_OID_KEYCACHE:
 	case LM_OID_PSM:
@@ -1643,7 +1667,7 @@ static void stlc45xx_setup_mac(struct stlc45xx *stlc,u16 mode,const u8 *bssid)
 	setup->rx_buffer = FIRMWARE_RXBUFFER_START;
 	setup->rx_mtu = FIRMWARE_MTU;
 	setup->frontend = 5;
-	setup->timeout = 0;
+	setup->timeout = 2;
 	setup->truncate = 48896;
 	setup->bratemask = 0xffffffff;
 	setup->ref_clock = 644245094;
@@ -1827,11 +1851,13 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	control->oid = LM_OID_PSM;
 
 	if (enable)
-		psm->flags |= LM_PSM;
+		psm->flags |= LM_PSM | LM_PSM_MCBC |
+			LM_PSM_CHECKSUM | LM_PSM_BEACON_TIMEOUT;
 
 	psm->aid = stlc->aid;
 
-	psm->beacon_rcpi_skip_max = 60;
+	psm->beacon_rcpi_skip_max = 200;
+	psm->rcpi_delta_threshold = 0;
 
 	psm->intervals[0].interval = 1;
 	psm->intervals[0].periods = 1;
@@ -1842,7 +1868,7 @@ static void stlc45xx_tx_psm(struct stlc45xx *stlc, bool enable)
 	psm->intervals[3].interval = 1;
 	psm->intervals[3].periods = 1;
 
-	psm->nr = 0;
+	psm->nr = 10;
 	psm->exclude[0] = 0;
 
 	stlc45xx_debug(DEBUG_PSM, "sending LM_OID_PSM (aid %d, interval %d)",
@@ -2428,7 +2454,9 @@ static int __devinit stlc45xx_probe(struct spi_device *spi)
 		IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM |
 		IEEE80211_HW_SUPPORTS_PS |
-		IEEE80211_HW_PS_NULLFUNC_STACK;
+		IEEE80211_HW_PS_NULLFUNC_STACK |
+		IEEE80211_HW_BEACON_FILTER;
+
 	/* four bytes for padding */
 	hw->extra_tx_headroom = sizeof(struct s_lm_data_out) + 4;
 

