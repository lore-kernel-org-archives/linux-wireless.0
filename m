Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:29592 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562Ab3LLK7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Dec 2013 05:59:19 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 13/18] brcmfmac: Fix hex dump for FWIL.
Date: Thu, 12 Dec 2013 11:59:01 +0100
Message-ID: <1386845946-9859-14-git-send-email-arend@broadcom.com> (sfid-20131212_115931_315691_9F196006)
In-Reply-To: <1386845946-9859-1-git-send-email-arend@broadcom.com>
References: <1386845946-9859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

The debug function brcmf_dbg_hex_dump API got changed and the
information string should preferably contain a \n at the end
of the string. Update the FWIL so debug output looks better.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index b72d339..22adbe3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -68,7 +68,7 @@ brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 
 	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	err = brcmf_fil_cmd_data(ifp, cmd, data, len, true);
 	mutex_unlock(&ifp->drvr->proto_block);
@@ -86,7 +86,7 @@ brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 
 	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	mutex_unlock(&ifp->drvr->proto_block);
 
@@ -155,7 +155,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, void *data,
 
 	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	buflen = brcmf_create_iovar(name, data, len, drvr->proto_buf,
 				    sizeof(drvr->proto_buf));
@@ -195,7 +195,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 
 	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	mutex_unlock(&drvr->proto_block);
 	return err;
@@ -278,7 +278,7 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 
 	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	buflen = brcmf_create_bsscfg(ifp->bssidx, name, data, len,
 				     drvr->proto_buf, sizeof(drvr->proto_buf));
@@ -317,7 +317,7 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 	}
 	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
-			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data");
+			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
 	mutex_unlock(&drvr->proto_block);
 	return err;
-- 
1.7.10.4

