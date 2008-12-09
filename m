Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:57596 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826AbYLIGha (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 01:37:30 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1201936ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 22:37:28 -0800 (PST)
Message-ID: <eb3ff54b0812082237v35bdd49jbce0ad59c218bc26@mail.gmail.com> (sfid-20081209_073735_148095_BF73E8CD)
Date: Tue, 9 Dec 2008 08:37:28 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: linville@tuxdriver.com
Subject: [PATCH ] iwlwifi: fix build error (iwl-rx.c).
Cc: linux-wireless@vger.kernel.org, reinette.chatre@intel.com,
	m.sujith@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds #ifdef CONFIG_IWLWIFI_DEBUG in iwl_rx_reply_rx() method
in iwlwifi/iwl-rx.c) to avoid build error.
,caused by commit c778f6d6b339bb4981d5d2dd8716286f756b8474.

(wireless-testing tree.)

Signed-off-by: Rami Rosen <ramirose@gmail.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 1938e6d..2a008b1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -1071,9 +1071,10 @@ void iwl_rx_reply_rx(struct iwl_priv *priv,
 		priv->last_rx_noise = IWL_NOISE_MEAS_NOT_AVAILABLE;

 	/* Set "1" to report good data frames in groups of 100 */
+#ifdef CONFIG_IWLWIFI_DEBUG
 	if (unlikely(priv->debug_level & IWL_DL_RX))
 		iwl_dbg_report_frame(priv, rx_start, len, header, 1);
-
+#endif
 	IWL_DEBUG_STATS_LIMIT("Rssi %d, noise %d, qual %d, TSF %llu\n",
 		rx_status.signal, rx_status.noise, rx_status.signal,
 		(unsigned long long)rx_status.mactime);
