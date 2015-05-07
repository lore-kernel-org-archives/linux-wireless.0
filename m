Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:33181 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbbEGTIE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 15:08:04 -0400
Received: by wgin8 with SMTP id n8so52917186wgi.0
        for <linux-wireless@vger.kernel.org>; Thu, 07 May 2015 12:08:03 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/2] brcmfmac: move strings debugging Broadcom errors to debug.c
Date: Thu,  7 May 2015 21:07:40 +0200
Message-Id: <1431025661-8879-1-git-send-email-zajec5@gmail.com> (sfid-20150507_210809_472889_C1E18210)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are used with CONFIG_BRCMDBG so it makes sense to put them in debug
specific file. Also they aren't really specific to fwil.c.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/debug.c | 64 ++++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/debug.h |  5 ++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c  | 73 +------------------------
 3 files changed, 70 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.c b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
index 9b473d5..2d9a1c0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.c
@@ -115,3 +115,67 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 
 	return PTR_ERR_OR_ZERO(dentry);
 }
+
+static const char * const brcmf_errstr[] = {
+	"BCME_OK",
+	"BCME_ERROR",
+	"BCME_BADARG",
+	"BCME_BADOPTION",
+	"BCME_NOTUP",
+	"BCME_NOTDOWN",
+	"BCME_NOTAP",
+	"BCME_NOTSTA",
+	"BCME_BADKEYIDX",
+	"BCME_RADIOOFF",
+	"BCME_NOTBANDLOCKED",
+	"BCME_NOCLK",
+	"BCME_BADRATESET",
+	"BCME_BADBAND",
+	"BCME_BUFTOOSHORT",
+	"BCME_BUFTOOLONG",
+	"BCME_BUSY",
+	"BCME_NOTASSOCIATED",
+	"BCME_BADSSIDLEN",
+	"BCME_OUTOFRANGECHAN",
+	"BCME_BADCHAN",
+	"BCME_BADADDR",
+	"BCME_NORESOURCE",
+	"BCME_UNSUPPORTED",
+	"BCME_BADLEN",
+	"BCME_NOTREADY",
+	"BCME_EPERM",
+	"BCME_NOMEM",
+	"BCME_ASSOCIATED",
+	"BCME_RANGE",
+	"BCME_NOTFOUND",
+	"BCME_WME_NOT_ENABLED",
+	"BCME_TSPEC_NOTFOUND",
+	"BCME_ACM_NOTSUPPORTED",
+	"BCME_NOT_WME_ASSOCIATION",
+	"BCME_SDIO_ERROR",
+	"BCME_DONGLE_DOWN",
+	"BCME_VERSION",
+	"BCME_TXFAIL",
+	"BCME_RXFAIL",
+	"BCME_NODEVICE",
+	"BCME_NMODE_DISABLED",
+	"BCME_NONRESIDENT",
+	"BCME_SCANREJECT",
+	"BCME_USAGE_ERROR",
+	"BCME_IOCTL_ERROR",
+	"BCME_SERIAL_PORT_ERR",
+	"BCME_DISABLED",
+	"BCME_DECERR",
+	"BCME_ENCERR",
+	"BCME_MICERR",
+	"BCME_REPLAY",
+	"BCME_IE_NOTFOUND",
+};
+
+const char *brcmf_get_errstr(u32 err)
+{
+	if (err >= ARRAY_SIZE(brcmf_errstr))
+		return "(unknown)";
+
+	return brcmf_errstr[err];
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/debug.h b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
index eb0b8c4..d1b2a5c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/debug.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/debug.h
@@ -111,6 +111,7 @@ void brcmf_debugfs_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 			    int (*read_fn)(struct seq_file *seq, void *data));
+const char *brcmf_get_errstr(u32 err);
 #else
 static inline void brcmf_debugfs_init(void)
 {
@@ -131,6 +132,10 @@ int brcmf_debugfs_add_entry(struct brcmf_pub *drvr, const char *fn,
 {
 	return 0;
 }
+static inline const char *brcmf_get_errstr(u32 err)
+{
+	return "";
+}
 #endif
 
 #endif /* BRCMFMAC_DEBUG_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index dcfa0bb..bdbdc9e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -32,77 +32,6 @@
 
 #define MAX_HEX_DUMP_LEN	64
 
-#ifdef DEBUG
-static const char * const brcmf_fil_errstr[] = {
-	"BCME_OK",
-	"BCME_ERROR",
-	"BCME_BADARG",
-	"BCME_BADOPTION",
-	"BCME_NOTUP",
-	"BCME_NOTDOWN",
-	"BCME_NOTAP",
-	"BCME_NOTSTA",
-	"BCME_BADKEYIDX",
-	"BCME_RADIOOFF",
-	"BCME_NOTBANDLOCKED",
-	"BCME_NOCLK",
-	"BCME_BADRATESET",
-	"BCME_BADBAND",
-	"BCME_BUFTOOSHORT",
-	"BCME_BUFTOOLONG",
-	"BCME_BUSY",
-	"BCME_NOTASSOCIATED",
-	"BCME_BADSSIDLEN",
-	"BCME_OUTOFRANGECHAN",
-	"BCME_BADCHAN",
-	"BCME_BADADDR",
-	"BCME_NORESOURCE",
-	"BCME_UNSUPPORTED",
-	"BCME_BADLEN",
-	"BCME_NOTREADY",
-	"BCME_EPERM",
-	"BCME_NOMEM",
-	"BCME_ASSOCIATED",
-	"BCME_RANGE",
-	"BCME_NOTFOUND",
-	"BCME_WME_NOT_ENABLED",
-	"BCME_TSPEC_NOTFOUND",
-	"BCME_ACM_NOTSUPPORTED",
-	"BCME_NOT_WME_ASSOCIATION",
-	"BCME_SDIO_ERROR",
-	"BCME_DONGLE_DOWN",
-	"BCME_VERSION",
-	"BCME_TXFAIL",
-	"BCME_RXFAIL",
-	"BCME_NODEVICE",
-	"BCME_NMODE_DISABLED",
-	"BCME_NONRESIDENT",
-	"BCME_SCANREJECT",
-	"BCME_USAGE_ERROR",
-	"BCME_IOCTL_ERROR",
-	"BCME_SERIAL_PORT_ERR",
-	"BCME_DISABLED",
-	"BCME_DECERR",
-	"BCME_ENCERR",
-	"BCME_MICERR",
-	"BCME_REPLAY",
-	"BCME_IE_NOTFOUND",
-};
-
-static const char *brcmf_fil_get_errstr(u32 err)
-{
-	if (err >= ARRAY_SIZE(brcmf_fil_errstr))
-		return "(unknown)";
-
-	return brcmf_fil_errstr[err];
-}
-#else
-static const char *brcmf_fil_get_errstr(u32 err)
-{
-	return "";
-}
-#endif /* DEBUG */
-
 static s32
 brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 {
@@ -125,7 +54,7 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 		return 0;
 
 	brcmf_dbg(FIL, "Failed: %s (%d)\n",
-		  brcmf_fil_get_errstr((u32)(-err)), err);
+		  brcmf_get_errstr((u32)(-err)), err);
 	return -EBADE;
 }
 
-- 
1.8.4.5

