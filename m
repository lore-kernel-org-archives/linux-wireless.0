Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:28975 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbaLCUFk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Dec 2014 15:05:40 -0500
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/7] brcmfmac: Add ifidx to logging of fwil cmds.
Date: Wed, 3 Dec 2014 21:05:32 +0100
Message-ID: <1417637133-6966-7-git-send-email-arend@broadcom.com> (sfid-20141203_210553_587699_FF5F1962)
In-Reply-To: <1417637133-6966-1-git-send-email-arend@broadcom.com>
References: <1417637133-6966-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 51f88c1..03f2c40 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -136,7 +136,7 @@ brcmf_fil_cmd_data_set(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 
 	mutex_lock(&ifp->drvr->proto_block);
 
-	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, len=%d\n", ifp->ifidx, cmd, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
@@ -154,7 +154,7 @@ brcmf_fil_cmd_data_get(struct brcmf_if *ifp, u32 cmd, void *data, u32 len)
 	mutex_lock(&ifp->drvr->proto_block);
 	err = brcmf_fil_cmd_data(ifp, cmd, data, len, false);
 
-	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, len=%d\n", ifp->ifidx, cmd, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
@@ -171,7 +171,7 @@ brcmf_fil_cmd_int_set(struct brcmf_if *ifp, u32 cmd, u32 data)
 	__le32 data_le = cpu_to_le32(data);
 
 	mutex_lock(&ifp->drvr->proto_block);
-	brcmf_dbg(FIL, "cmd=%d, value=%d\n", cmd, data);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, data);
 	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), true);
 	mutex_unlock(&ifp->drvr->proto_block);
 
@@ -188,7 +188,7 @@ brcmf_fil_cmd_int_get(struct brcmf_if *ifp, u32 cmd, u32 *data)
 	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), false);
 	mutex_unlock(&ifp->drvr->proto_block);
 	*data = le32_to_cpu(data_le);
-	brcmf_dbg(FIL, "cmd=%d, value=%d\n", cmd, *data);
+	brcmf_dbg(FIL, "ifidx=%d, cmd=%d, value=%d\n", ifp->ifidx, cmd, *data);
 
 	return err;
 }
@@ -224,7 +224,7 @@ brcmf_fil_iovar_data_set(struct brcmf_if *ifp, char *name, const void *data,
 
 	mutex_lock(&drvr->proto_block);
 
-	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
+	brcmf_dbg(FIL, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
@@ -264,7 +264,7 @@ brcmf_fil_iovar_data_get(struct brcmf_if *ifp, char *name, void *data,
 		brcmf_err("Creating iovar failed\n");
 	}
 
-	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
+	brcmf_dbg(FIL, "ifidx=%d, name=%s, len=%d\n", ifp->ifidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
@@ -347,7 +347,8 @@ brcmf_fil_bsscfg_data_set(struct brcmf_if *ifp, char *name,
 
 	mutex_lock(&drvr->proto_block);
 
-	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
+	brcmf_dbg(FIL, "ifidx=%d, bssidx=%d, name=%s, len=%d\n", ifp->ifidx,
+		  ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
@@ -386,7 +387,8 @@ brcmf_fil_bsscfg_data_get(struct brcmf_if *ifp, char *name,
 		err = -EPERM;
 		brcmf_err("Creating bsscfg failed\n");
 	}
-	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", ifp->bssidx, name, len);
+	brcmf_dbg(FIL, "ifidx=%d, bssidx=%d, name=%s, len=%d\n", ifp->ifidx,
+		  ifp->bssidx, name, len);
 	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data,
 			   min_t(uint, len, MAX_HEX_DUMP_LEN), "data\n");
 
-- 
1.9.1

