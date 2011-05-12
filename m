Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:50801 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755202Ab1ELOPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:51 -0400
Received: by mail-ey0-f180.google.com with SMTP id 24so615841eyg.11
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:49 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/7] wl12xx: add configuration values for scheduled scan
Date: Thu, 12 May 2011 17:15:34 +0300
Message-Id: <1305209740-30287-2-git-send-email-coelho@ti.com> (sfid-20110512_161554_754303_D1E90134)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add the structures and values for driver-configured scheduled scan
parameters.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/conf.h |   21 +++++++++++++++++++++
 drivers/net/wireless/wl12xx/main.c |    9 +++++++++
 2 files changed, 30 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 6620840..1ab6c86 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1147,6 +1147,26 @@ struct conf_scan_settings {
 
 };
 
+struct conf_sched_scan_settings {
+	/* minimum time to wait on the channel for active scans (in TUs) */
+	u16 min_dwell_time_active;
+
+	/* maximum time to wait on the channel for active scans (in TUs) */
+	u16 max_dwell_time_active;
+
+	/* time to wait on the channel for passive scans (in TUs) */
+	u32 dwell_time_passive;
+
+	/* number of probe requests to send on each channel in active scans */
+	u8 num_probe_reqs;
+
+	/* RSSI threshold to be used for filtering */
+	s8 rssi_threshold;
+
+	/* SNR threshold to be used for filtering */
+	s8 snr_threshold;
+};
+
 /* these are number of channels on the band divided by two, rounded up */
 #define CONF_TX_PWR_COMPENSATION_LEN_2 7
 #define CONF_TX_PWR_COMPENSATION_LEN_5 18
@@ -1234,6 +1254,7 @@ struct conf_drv_settings {
 	struct conf_pm_config_settings pm_config;
 	struct conf_roam_trigger_settings roam_trigger;
 	struct conf_scan_settings scan;
+	struct conf_sched_scan_settings sched_scan;
 	struct conf_rf_settings rf;
 	struct conf_ht_setting ht;
 	struct conf_memory_settings mem_wl127x;
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index f82e736..cb4ed90 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -302,6 +302,15 @@ static struct conf_drv_settings default_conf = {
 		.max_dwell_time_passive       = 100000,
 		.num_probe_reqs               = 2,
 	},
+	.sched_scan = {
+		/* sched_scan requires dwell times in TU instead of TU/1000 */
+		.min_dwell_time_active = 8,
+		.max_dwell_time_active = 30,
+		.dwell_time_passive    = 100,
+		.num_probe_reqs        = 2,
+		.rssi_threshold        = -90,
+		.snr_threshold         = 0,
+	},
 	.rf = {
 		.tx_per_channel_power_compensation_2 = {
 			0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
-- 
1.7.1

