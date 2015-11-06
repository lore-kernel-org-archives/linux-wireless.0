Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:36504 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031107AbbKFCLJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 21:11:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 07/73] staging: wilc1000: fixes add blank line after function declaration
Date: Fri, 6 Nov 2015 11:12:28 +0900
Message-ID: <1446776014-28094-7-git-send-email-glen.lee@atmel.com> (sfid-20151106_031113_351390_426A40B7)
In-Reply-To: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
References: <1446776014-28094-1-git-send-email-glen.lee@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Leo Kim <leo.kim@atmel.com>

This patch fixes the warnings reported by checkpatch.pl
for please use a blank line after function/struct/union/enum declarations

Signed-off-by: Leo Kim <leo.kim@atmel.com>
Signed-off-by: Glen Lee <glen.lee@atmel.com>
---
 drivers/staging/wilc1000/wilc_wlan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/wilc1000/wilc_wlan.c b/drivers/staging/wilc1000/wilc_wlan.c
index 603541c..d3117f9 100644
--- a/drivers/staging/wilc1000/wilc_wlan.c
+++ b/drivers/staging/wilc1000/wilc_wlan.c
@@ -68,6 +68,7 @@ static inline void acquire_bus(BUS_ACQUIRE_T acquire)
 			chip_wakeup();
 	}
 }
+
 static inline void release_bus(BUS_RELEASE_T release)
 {
 	#ifdef WILC_OPTIMIZE_SLEEP_INT
@@ -224,6 +225,7 @@ static inline int Init_TCP_tracking(void)
 {
 	return 0;
 }
+
 static inline int add_TCP_track_session(u32 src_prt, u32 dst_prt, u32 seq)
 {
 	Acks_keep_track_info[Opened_TCP_session].Ack_seq_num = seq;
@@ -242,6 +244,7 @@ static inline int Update_TCP_track_session(u32 index, u32 Ack)
 		Acks_keep_track_info[index].Bigger_Ack_num = Ack;
 	return 0;
 }
+
 static inline int add_TCP_Pending_Ack(u32 Ack, u32 Session_index, struct txq_entry_t  *txqe)
 {
 	Statisitcs_totalAcks++;
@@ -1045,6 +1048,7 @@ static void wilc_unknown_isr_ext(void)
 {
 	g_wlan.hif_func.hif_clear_int_ext(0);
 }
+
 static void wilc_pllupdate_isr_ext(u32 int_stats)
 {
 	int trials = 10;
@@ -1507,6 +1511,7 @@ int wilc_wlan_cfg_set(int start, u32 wid, u8 *buffer, u32 buffer_size,
 
 	return ret_size;
 }
+
 int wilc_wlan_cfg_get(int start, u32 wid, int commit, u32 drvHandler)
 {
 	wilc_wlan_dev_t *p = &g_wlan;
@@ -1562,6 +1567,7 @@ void wilc_bus_set_default_speed(void)
 {
 	g_wlan.hif_func.hif_set_default_bus_speed();
 }
+
 u32 init_chip(struct net_device *dev)
 {
 	u32 chipid;
-- 
1.9.1

