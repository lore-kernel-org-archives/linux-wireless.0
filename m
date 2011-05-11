Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:59390 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774Ab1EKQWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:22:07 -0400
Received: from dlep35.itg.ti.com ([157.170.170.118])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4B8Ed68006417
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 03:14:39 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: Unmask beacons includes IE 'HT information' change
Date: Wed, 11 May 2011 11:14:22 +0300
Message-Id: <1305101662-12247-1-git-send-email-shahar_levi@ti.com> (sfid-20110511_182221_878268_37E9C51A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All beacons includes changes in IE 'HT information' (IE 61) will
be pass to the MAC80211 layer in order to be update with HT
run time setting.
Enable that via beacon filter mechanism.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
 drivers/net/wireless/wl12xx/main.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dea57ea..92d26f4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -256,12 +256,16 @@ static struct conf_drv_settings default_conf = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
 		.listen_interval             = 1,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
-		.bcn_filt_ie_count           = 1,
+		.bcn_filt_ie_count           = 2,
 		.bcn_filt_ie = {
 			[0] = {
 				.ie          = WLAN_EID_CHANNEL_SWITCH,
 				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
-			}
+			},
+			[1] = {
+				.ie          = WLAN_EID_HT_INFORMATION,
+				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
+			},
 		},
 		.synch_fail_thold            = 10,
 		.bss_lose_timeout            = 100,
-- 
1.7.0.4

