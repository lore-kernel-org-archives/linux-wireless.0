Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17918 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbZKQQtQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:16 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 08/16] wl1251: Add acx command to set tbtt and dtim period
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:08 +0200
Message-ID: <20091117164907.2236.41929.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

The dtim period obtained from the mac80211 is not set to the firmware.
This patch implements the acx command to set correct tbtt and dtim value
to the firmware.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_acx.c |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h |   18 ++++++++++++++++++
 2 files changed, 46 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 50633e0..acfa086 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -948,3 +948,31 @@ out:
 	kfree(mem_conf);
 	return ret;
 }
+
+int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim)
+{
+	struct wl1251_acx_wr_tbtt_and_dtim *acx;
+	int ret;
+
+	wl1251_debug(DEBUG_ACX, "acx tbtt and dtim");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	acx->tbtt = tbtt;
+	acx->dtim = dtim;
+
+	ret = wl1251_cmd_configure(wl, ACX_WR_TBTT_AND_DTIM,
+				   acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("failed to set tbtt and dtim: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index ce1c995..44a4b04 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -1149,6 +1149,23 @@ struct wl1251_acx_mem_map {
 	u32 num_rx_mem_blocks;
 } __attribute__ ((packed));
 
+
+struct wl1251_acx_wr_tbtt_and_dtim {
+
+	struct acx_header header;
+
+	/* Time in TUs between two consecutive beacons */
+	u16 tbtt;
+
+	/*
+	 * DTIM period
+	 * For BSS: Number of TBTTs in a DTIM period (range: 1-10)
+	 * For IBSS: value shall be set to 1
+	*/
+	u8  dtim;
+	u8  padding;
+} __attribute__ ((packed));
+
 /*************************************************************************
 
     Host Interrupt Register (WiLink -> Host)
@@ -1304,5 +1321,6 @@ int wl1251_acx_statistics(struct wl1251 *wl, struct acx_statistics *stats);
 int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime);
 int wl1251_acx_rate_policies(struct wl1251 *wl);
 int wl1251_acx_mem_cfg(struct wl1251 *wl);
+int wl1251_acx_wr_tbtt_and_dtim(struct wl1251 *wl, u16 tbtt, u8 dtim);
 
 #endif /* __WL1251_ACX_H__ */

