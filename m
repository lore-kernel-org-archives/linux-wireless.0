Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:34548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933290Ab2JZOYE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2012 10:24:04 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH 07/18] brcmsmac: Add module parameter for setting the debug level
Date: Fri, 26 Oct 2012 09:23:22 -0500
Message-Id: <1351261413-20821-8-git-send-email-seth.forshee@canonical.com> (sfid-20121026_162411_090100_A1EC3A08)
In-Reply-To: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
References: <1351261413-20821-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The debug level can be set by passing debug=... to brcmsmac whenever
CONFIG_BRCMDBG is enabled.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |   16 ++++++++--------
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    7 +------
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index a744ea5..37b9966 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -98,10 +98,14 @@ static struct bcma_device_id brcms_coreid_table[] = {
 };
 MODULE_DEVICE_TABLE(bcma, brcms_coreid_table);
 
-#ifdef DEBUG
-static int msglevel = 0xdeadbeef;
-module_param(msglevel, int, 0);
-#endif				/* DEBUG */
+#if defined(CONFIG_BRCMDBG)
+/*
+ * Module parameter for setting the debug message level. Available
+ * flags are specified by the BRCM_DL_* macros in
+ * drivers/net/wireless/brcm80211/include/defs.h.
+ */
+module_param_named(debug, brcm_msg_level, uint, S_IRUGO | S_IWUSR);
+#endif
 
 static struct ieee80211_channel brcms_2ghz_chantable[] = {
 	CHAN2GHZ(1, 2412, IEEE80211_CHAN_NO_HT40MINUS),
@@ -1184,10 +1188,6 @@ static DECLARE_WORK(brcms_driver_work, brcms_driver_init);
 
 static int __init brcms_module_init(void)
 {
-#ifdef DEBUG
-	if (msglevel != 0xdeadbeef)
-		brcm_msg_level = msglevel;
-#endif
 	if (!schedule_work(&brcms_driver_work))
 		return -EBUSY;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 0df2d65..fbc39b1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -285,12 +285,7 @@ struct edcf_acparam {
 } __packed;
 
 /* debug/trace */
-uint brcm_msg_level =
-#if defined(DEBUG)
-	BRCM_DL_INFO;
-#else
-	0;
-#endif				/* DEBUG */
+uint brcm_msg_level;
 
 /* TX FIFO number to WME/802.1E Access Category */
 static const u8 wme_fifo2ac[] = {
-- 
1.7.9.5

