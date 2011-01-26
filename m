Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:42939 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1AZI3b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 03:29:31 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wl12xx: Add a rule for WLAN_EID_PWR_CONSTRAINT in the beacon filter
Date: Wed, 26 Jan 2011 10:29:25 +0200
Message-Id: <1296030565-23778-3-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1296030565-23778-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The WLAN_EID_PWR_CONSTRAINT is used in .11h to pass a local TX power
constraint value, and may change any time.

Add a rule to the beacon filter to pass any beacons with this value changed,
so that it may be properly handled.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index bc09812..8996ce2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -239,11 +239,15 @@ static struct conf_drv_settings default_conf = {
 		.wake_up_event               = CONF_WAKE_UP_EVENT_DTIM,
 		.listen_interval             = 1,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
-		.bcn_filt_ie_count           = 1,
+		.bcn_filt_ie_count           = 2,
 		.bcn_filt_ie = {
 			[0] = {
 				.ie          = WLAN_EID_CHANNEL_SWITCH,
 				.rule        = CONF_BCN_RULE_PASS_ON_APPEARANCE,
+			},
+			[1] = {
+				.ie          = WLAN_EID_PWR_CONSTRAINT,
+				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			}
 		},
 		.synch_fail_thold            = 10,
-- 
1.7.1

