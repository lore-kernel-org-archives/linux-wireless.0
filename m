Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53020 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJ1N6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 09:58:23 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 04/16] brcmfmac: show firmware error as string in debug message
Date: Tue, 28 Oct 2014 14:56:07 +0100
Message-ID: <1414504579-12562-5-git-send-email-arend@broadcom.com> (sfid-20141028_145825_870248_536EF0EB)
In-Reply-To: <1414504579-12562-1-git-send-email-arend@broadcom.com>
References: <1414504579-12562-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Showing the firmware error allows to quickly give a clue what
went wrong and directly look in the firmware code that gave us
back the error.

Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c | 73 +++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index ded328f..42da73e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -32,6 +32,76 @@
 
 #define MAX_HEX_DUMP_LEN	64
 
+#ifdef DEBUG
+static const char * const brcmf_fil_errstr[] = {
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
+static const char *brcmf_fil_get_errstr(u32 err)
+{
+	if (err >= ARRAY_SIZE(brcmf_fil_errstr))
+		return "(unknown)";
+
+	return brcmf_fil_errstr[err];
+}
+#else
+static const char *brcmf_fil_get_errstr(u32 err)
+{
+	return "";
+}
+#endif /* DEBUG */
 
 static s32
 brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
@@ -54,7 +124,8 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	if (err >= 0)
 		err = 0;
 	else
-		brcmf_dbg(FIL, "Failed err=%d\n", err);
+		brcmf_dbg(FIL, "Failed: %s (%d)\n",
+			  brcmf_fil_get_errstr((u32)(-err)), err);
 
 	return err;
 }
-- 
1.9.1

