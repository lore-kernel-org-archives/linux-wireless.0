Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35454 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdBXQdR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Feb 2017 11:33:17 -0500
Received: by mail-lf0-f66.google.com with SMTP id z127so1814705lfa.2
        for <linux-wireless@vger.kernel.org>; Fri, 24 Feb 2017 08:33:16 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <frankyl@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH] brcmfmac: always print error when PSM's watchdog fires
Date: Fri, 24 Feb 2017 17:32:46 +0100
Message-Id: <20170224163246.7748-1-zajec5@gmail.com> (sfid-20170224_173323_347310_35C66A40)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rafał Miłecki <rafal@milecki.pl>

So far we were attaching BRCMF_E_PSM_WATCHDOG event listener in
brcmf_debug_attach which gets compiled only with CONFIG_BRCMDBG. This
event means something went wrong and firmware / hardware usually can't
be expected to work (reliably).

Such a problem is significant for user experience so I believe we should
print an error unconditionally (even with debugging disabled). What can
be indeed optional is dumping bus memory as this is clearly part of
debugging process.

In the future we may also try to extend this listener by trying to
recover from the error or at least signal it to the cfg80211.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    | 22 ++++++++++++++++++
 .../wireless/broadcom/brcm80211/brcmfmac/debug.c   | 26 +++-------------------
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |  9 ++++++++
 3 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 60da86a8d95b..2f2f3a5ad86a 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -738,6 +738,24 @@ void brcmf_remove_interface(struct brcmf_if *ifp, bool rtnl_locked)
 	brcmf_del_if(ifp->drvr, ifp->bsscfgidx, rtnl_locked);
 }
 
+static int brcmf_psm_watchdog_notify(struct brcmf_if *ifp,
+				     const struct brcmf_event_msg *evtmsg,
+				     void *data)
+{
+	int err;
+
+	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
+
+	brcmf_err("PSM's watchdog has fired!\n");
+
+	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
+					 evtmsg->datalen);
+	if (err)
+		brcmf_err("Failed to get memory dump, %d\n", err);
+
+	return err;
+}
+
 #ifdef CONFIG_INET
 #define ARPOL_MAX_ENTRIES	8
 static int brcmf_inetaddr_changed(struct notifier_block *nb,
@@ -917,6 +935,10 @@ int brcmf_attach(struct device *dev, struct brcmf_mp_device *settings)
 		goto fail;
 	}
 
+	/* Attach to events important for core code */
+	brcmf_fweh_register(drvr, BRCMF_E_PSM_WATCHDOG,
+			    brcmf_psm_watchdog_notify);
+
 	/* attach firmware event handler */
 	brcmf_fweh_attach(drvr);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
index f4644cf371c7..1447a8352383 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.c
@@ -27,8 +27,8 @@
 
 static struct dentry *root_folder;
 
-static int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
-				      size_t len)
+int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
+			       size_t len)
 {
 	void *dump;
 	size_t ramsize;
@@ -54,24 +54,6 @@ static int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
 	return 0;
 }
 
-static int brcmf_debug_psm_watchdog_notify(struct brcmf_if *ifp,
-					   const struct brcmf_event_msg *evtmsg,
-					   void *data)
-{
-	int err;
-
-	brcmf_dbg(TRACE, "enter: bsscfgidx=%d\n", ifp->bsscfgidx);
-
-	brcmf_err("PSM's watchdog has fired!\n");
-
-	err = brcmf_debug_create_memdump(ifp->drvr->bus_if, data,
-					 evtmsg->datalen);
-	if (err)
-		brcmf_err("Failed to get memory dump, %d\n", err);
-
-	return err;
-}
-
 void brcmf_debugfs_init(void)
 {
 	root_folder = debugfs_create_dir(KBUILD_MODNAME, NULL);
@@ -99,9 +81,7 @@ int brcmf_debug_attach(struct brcmf_pub *drvr)
 	if (IS_ERR(drvr->dbgfs_dir))
 		return PTR_ERR(drvr->dbgfs_dir);
 
-
-	return brcmf_fweh_register(drvr, BRCMF_E_PSM_WATCHDOG,
-				   brcmf_debug_psm_watchdog_notify);
+	return 0;
 }
 
 void brcmf_debug_detach(struct brcmf_pub *drvr)
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
index 066126123e96..389166abb520 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/debug.h
@@ -99,6 +99,7 @@ do {									\
 
 extern int brcmf_msg_level;
 
+struct brcmf_bus;
 struct brcmf_pub;
 #ifdef DEBUG
 void brcmf_debugfs_init(void);
@@ -108,6 +109,8 @@ void brcmf_debug_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data));
+int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
+			       size_t len);
 #else
 static inline void brcmf_debugfs_init(void)
 {
@@ -128,6 +131,12 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 {
 	return 0;
 }
+static inline
+int brcmf_debug_create_memdump(struct brcmf_bus *bus, const void *data,
+			       size_t len)
+{
+	return 0;
+}
 #endif
 
 #endif /* BRCMFMAC_DEBUG_H */
-- 
2.11.0
