Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41130 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZKWVXB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:23:01 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/8] wl1271: set radio and general params also for PLT
Date: Mon, 23 Nov 2009 23:22:16 +0200
Message-Id: <1259011339-28149-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We need to set the radio and general parameters when starting PLT mode.  This
patch adds calls to TEST_CMD_INI_RADIO_PARAMS and
TEST_CMD_INIT_GENERAL_PARAMS when initializing PLT mode.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |    4 ++--
 drivers/net/wireless/wl12xx/wl1271_init.h |    2 ++
 drivers/net/wireless/wl12xx/wl1271_main.c |   11 +++++++++++
 3 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 7c2017f..95ee036 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -193,7 +193,7 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_general_parms(struct wl1271 *wl)
+int wl1271_init_general_parms(struct wl1271 *wl)
 {
 	struct wl1271_general_parms *gen_parms;
 	struct conf_general_parms *g = &wl->conf.init.genparam;
@@ -224,7 +224,7 @@ static int wl1271_init_general_parms(struct wl1271 *wl)
 	return 0;
 }
 
-static int wl1271_init_radio_parms(struct wl1271 *wl)
+int wl1271_init_radio_parms(struct wl1271 *wl)
 {
 	struct wl1271_radio_parms *radio_parms;
 	struct conf_radio_parms *r = &wl->conf.init.radioparam;
diff --git a/drivers/net/wireless/wl12xx/wl1271_init.h b/drivers/net/wireless/wl12xx/wl1271_init.h
index 6e21cee..539b57f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.h
+++ b/drivers/net/wireless/wl12xx/wl1271_init.h
@@ -28,6 +28,8 @@
 
 int wl1271_hw_init_power_auth(struct wl1271 *wl);
 int wl1271_hw_init(struct wl1271 *wl);
+int wl1271_init_general_parms(struct wl1271 *wl);
+int wl1271_init_radio_parms(struct wl1271 *wl);
 
 /* These are not really a TEST_CMD, but the ref driver uses them as such */
 #define TEST_CMD_INI_FILE_RADIO_PARAM   0x19
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index c8652ee..d4e6039 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -354,6 +354,17 @@ static int wl1271_plt_init(struct wl1271 *wl)
 {
 	int ret;
 
+	/* FIXME: the following parameter setting functions return error
+	 * codes - the reason is so far unknown. The -EIO is therefore
+	 * ignored for the time being. */
+	ret = wl1271_init_general_parms(wl);
+	if (ret < 0 && ret != -EIO)
+		return ret;
+
+	ret = wl1271_init_radio_parms(wl);
+	if (ret < 0 && ret != -EIO)
+		return ret;
+
 	ret = wl1271_acx_init_mem_config(wl);
 	if (ret < 0)
 		return ret;
-- 
1.6.3.3

