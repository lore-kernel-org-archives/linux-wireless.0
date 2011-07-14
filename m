Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:5566 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752085Ab1GNBik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 21:38:40 -0400
Subject: [PATCH] carl9170: fix formatting issues found by checkpatch
To: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Wed, 13 Jul 2011 21:38:18 -0400
Message-ID: <20110714013818.22578.94134.stgit@mj.roinet.com> (sfid-20110714_033843_570044_FB9AD2E2)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/carl9170/cmd.h   |    4 ++--
 drivers/net/wireless/ath/carl9170/debug.c |    2 +-
 drivers/net/wireless/ath/carl9170/led.c   |    2 +-
 drivers/net/wireless/ath/carl9170/main.c  |    2 +-
 drivers/net/wireless/ath/carl9170/phy.c   |    6 +++---
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/carl9170/cmd.h b/drivers/net/wireless/ath/carl9170/cmd.h
index 568174c..d5f95bd 100644
--- a/drivers/net/wireless/ath/carl9170/cmd.h
+++ b/drivers/net/wireless/ath/carl9170/cmd.h
@@ -87,7 +87,7 @@ do {									\
 	__ar->cmd_buf[2 * __nreg + 1] = cpu_to_le32(r);			\
 	__ar->cmd_buf[2 * __nreg + 2] = cpu_to_le32(v);			\
 	__nreg++;							\
-	if ((__nreg >= PAYLOAD_MAX/2)) {				\
+	if ((__nreg >= PAYLOAD_MAX / 2)) {				\
 		if (IS_ACCEPTING_CMD(__ar))				\
 			__err = carl9170_exec_cmd(__ar,			\
 				CARL9170_CMD_WREG, 8 * __nreg,		\
@@ -160,7 +160,7 @@ do {									\
 } while (0)
 
 #define carl9170_async_regwrite_finish() do {				\
-__async_regwrite_out :							\
+__async_regwrite_out:							\
 	if (__cmd != NULL && __err == 0)				\
 		carl9170_async_regwrite_flush();			\
 	kfree(__cmd);							\
diff --git a/drivers/net/wireless/ath/carl9170/debug.c b/drivers/net/wireless/ath/carl9170/debug.c
index 0ac1124..de57f90 100644
--- a/drivers/net/wireless/ath/carl9170/debug.c
+++ b/drivers/net/wireless/ath/carl9170/debug.c
@@ -695,7 +695,7 @@ static char *carl9170_debugfs_bug_read(struct ar9170 *ar, char *buf,
 }
 __DEBUGFS_DECLARE_RW_FILE(bug, 400, CARL9170_STOPPED);
 
-static const char *erp_modes[] = {
+static const char *const erp_modes[] = {
 	[CARL9170_ERP_INVALID] = "INVALID",
 	[CARL9170_ERP_AUTO] = "Automatic",
 	[CARL9170_ERP_MAC80211] = "Set by MAC80211",
diff --git a/drivers/net/wireless/ath/carl9170/led.c b/drivers/net/wireless/ath/carl9170/led.c
index 4bb2cbd..78dadc7 100644
--- a/drivers/net/wireless/ath/carl9170/led.c
+++ b/drivers/net/wireless/ath/carl9170/led.c
@@ -118,7 +118,7 @@ static void carl9170_led_set_brightness(struct led_classdev *led,
 	}
 
 	if (likely(IS_ACCEPTING_CMD(ar) && arl->toggled))
-		ieee80211_queue_delayed_work(ar->hw, &ar->led_work, HZ/10);
+		ieee80211_queue_delayed_work(ar->hw, &ar->led_work, HZ / 10);
 }
 
 static int carl9170_led_register_led(struct ar9170 *ar, int i, char *name,
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index a61cf67..0122930 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1630,7 +1630,7 @@ static int carl9170_read_eeprom(struct ar9170 *ar)
 	BUILD_BUG_ON(sizeof(ar->eeprom) % RB);
 #endif
 
-	for (i = 0; i < sizeof(ar->eeprom)/RB; i++) {
+	for (i = 0; i < sizeof(ar->eeprom) / RB; i++) {
 		for (j = 0; j < RW; j++)
 			offsets[j] = cpu_to_le32(AR9170_EEPROM_START +
 						 RB * i + 4 * j);
diff --git a/drivers/net/wireless/ath/carl9170/phy.c b/drivers/net/wireless/ath/carl9170/phy.c
index da1ab96..aa147a9 100644
--- a/drivers/net/wireless/ath/carl9170/phy.c
+++ b/drivers/net/wireless/ath/carl9170/phy.c
@@ -1098,7 +1098,7 @@ static u8 carl9170_interpolate_u8(u8 x, u8 x1, u8 y1, u8 x2, u8 y2)
 	 *	Isn't it just DIV_ROUND_UP(y, 1<<SHIFT)?
 	 *	Can we rely on the compiler to optimise away the div?
 	 */
-	return (y >> SHIFT) + ((y & (1<<(SHIFT-1))) >> (SHIFT - 1));
+	return (y >> SHIFT) + ((y & (1 << (SHIFT - 1))) >> (SHIFT - 1));
 #undef SHIFT
 }
 
@@ -1379,7 +1379,7 @@ static void carl9170_calc_ctl(struct ar9170 *ar, u32 freq, enum carl9170_bw bw)
 
 			modes[i].max_power =
 				carl9170_get_max_edge_power(ar,
-					freq+f_off, EDGES(ctl_idx, 1));
+					freq + f_off, EDGES(ctl_idx, 1));
 
 			/*
 			 * TODO: check if the regulatory max. power is
@@ -1441,7 +1441,7 @@ static int carl9170_set_power_cal(struct ar9170 *ar, u32 freq,
 	if (freq < 3000)
 		f = freq - 2300;
 	else
-		f = (freq - 4800)/5;
+		f = (freq - 4800) / 5;
 
 	/*
 	 * cycle through the various modes
