Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62118 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758872Ab2EONfT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 May 2012 09:35:19 -0400
Received: by bkcji2 with SMTP id ji2so4802555bkc.19
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2012 06:35:18 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx/wl18xx: add erp protection IE to the beacon filter
Date: Tue, 15 May 2012 16:35:20 +0300
Message-Id: <1337088920-29014-1-git-send-email-eliad@wizery.com> (sfid-20120515_153523_492058_077BB5C6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have to reconfigure the fw when erp protection should
be enabled/disabled. Pass beacons containing changes
in the ERP protection IE, so we could analyze them.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |    6 +++++-
 drivers/net/wireless/ti/wl18xx/main.c |    6 +++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index eec5eaa..7bc8f47 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -217,7 +217,7 @@ static struct wlcore_conf wl12xx_conf = {
 		.suspend_wake_up_event       = CONF_WAKE_UP_EVENT_N_DTIM,
 		.suspend_listen_interval     = 3,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
-		.bcn_filt_ie_count           = 2,
+		.bcn_filt_ie_count           = 3,
 		.bcn_filt_ie = {
 			[0] = {
 				.ie          = WLAN_EID_CHANNEL_SWITCH,
@@ -227,6 +227,10 @@ static struct wlcore_conf wl12xx_conf = {
 				.ie          = WLAN_EID_HT_OPERATION,
 				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			},
+			[2] = {
+				.ie	     = WLAN_EID_ERP_INFO,
+				.rule	     = CONF_BCN_RULE_PASS_ON_CHANGE,
+			},
 		},
 		.synch_fail_thold            = 12,
 		.bss_lose_timeout            = 400,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 1bbf195..baf0bb4 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -340,7 +340,7 @@ static struct wlcore_conf wl18xx_conf = {
 		.suspend_wake_up_event       = CONF_WAKE_UP_EVENT_N_DTIM,
 		.suspend_listen_interval     = 3,
 		.bcn_filt_mode               = CONF_BCN_FILT_MODE_ENABLED,
-		.bcn_filt_ie_count           = 2,
+		.bcn_filt_ie_count           = 3,
 		.bcn_filt_ie = {
 			[0] = {
 				.ie          = WLAN_EID_CHANNEL_SWITCH,
@@ -350,6 +350,10 @@ static struct wlcore_conf wl18xx_conf = {
 				.ie          = WLAN_EID_HT_OPERATION,
 				.rule        = CONF_BCN_RULE_PASS_ON_CHANGE,
 			},
+			[2] = {
+				.ie	     = WLAN_EID_ERP_INFO,
+				.rule	     = CONF_BCN_RULE_PASS_ON_CHANGE,
+			},
 		},
 		.synch_fail_thold            = 12,
 		.bss_lose_timeout            = 400,
-- 
1.7.6.401.g6a319

