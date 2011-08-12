Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3106 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752678Ab1HLNfO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:14 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/14] staging: brcm80211: absorb brcmf_sdioh_iovar_op
 into brcmf_sdcard_iovar_op
Date: Fri, 12 Aug 2011 15:34:53 +0200
Message-ID: <1313156101-16817-7-git-send-email-arend@broadcom.com> (sfid-20110812_154257_356638_C99D2063)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

fullmac wrapper function cleanup.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |  112 +++++++++++++++++++-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |  116 ---------------------
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |    5 -
 3 files changed, 110 insertions(+), 123 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index aaf13f4..13b6dbe 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -46,12 +46,120 @@
 
 module_param(sd_f2_blocksize, int, 0);
 
+/* IOVar table */
+enum {
+	IOV_MSGLEVEL = 1,
+	IOV_DEVREG,
+	IOV_HCIREGS,
+	IOV_RXCHAIN
+};
+
+const struct brcmu_iovar sdioh_iovars[] = {
+	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
+	,
+	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
+	,
+	{NULL, 0, 0, 0, 0}
+};
+
 int
 brcmf_sdcard_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
 		void *params, int plen, void *arg, int len, bool set)
 {
-	return brcmf_sdioh_iovar_op(sdiodev, name, params, plen, arg,
-				    len, set);
+	const struct brcmu_iovar *vi = NULL;
+	int bcmerror = 0;
+	int val_size;
+	s32 int_val = 0;
+	bool bool_val;
+	u32 actionid;
+
+	if (name == NULL || len < 0)
+		return -EINVAL;
+
+	/* Set does not take qualifiers */
+	if (set && (params || plen))
+		return -EINVAL;
+
+	/* Get must have return space;*/
+	if (!set && !(arg && len))
+		return -EINVAL;
+
+	BRCMF_TRACE(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
+		  name));
+
+	vi = brcmu_iovar_lookup(sdioh_iovars, name);
+	if (vi == NULL) {
+		bcmerror = -ENOTSUPP;
+		goto exit;
+	}
+
+	bcmerror = brcmu_iovar_lencheck(vi, arg, len, set);
+	if (bcmerror != 0)
+		goto exit;
+
+	/* Set up params so get and set can share the convenience variables */
+	if (params == NULL) {
+		params = arg;
+		plen = len;
+	}
+
+	if (vi->type == IOVT_VOID)
+		val_size = 0;
+	else if (vi->type == IOVT_BUFFER)
+		val_size = len;
+	else
+		val_size = sizeof(int);
+
+	if (plen >= (int)sizeof(int_val))
+		memcpy(&int_val, params, sizeof(int_val));
+
+	bool_val = (int_val != 0) ? true : false;
+
+	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
+	switch (actionid) {
+	case IOV_GVAL(IOV_RXCHAIN):
+		int_val = false;
+		memcpy(arg, &int_val, val_size);
+		break;
+
+	case IOV_GVAL(IOV_DEVREG):
+		{
+			struct brcmf_sdreg *sd_ptr =
+					(struct brcmf_sdreg *) params;
+			u8 data = 0;
+
+			if (brcmf_sdioh_cfg_read
+			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
+				bcmerror = -EIO;
+				break;
+			}
+
+			int_val = (int)data;
+			memcpy(arg, &int_val, sizeof(int_val));
+			break;
+		}
+
+	case IOV_SVAL(IOV_DEVREG):
+		{
+			struct brcmf_sdreg *sd_ptr =
+					(struct brcmf_sdreg *) params;
+			u8 data = (u8) sd_ptr->value;
+
+			if (brcmf_sdioh_cfg_write
+			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
+				bcmerror = -EIO;
+				break;
+			}
+			break;
+		}
+
+	default:
+		bcmerror = -ENOTSUPP;
+		break;
+	}
+exit:
+
+	return bcmerror;
 }
 
 int brcmf_sdcard_intr_reg(struct brcmf_sdio_dev *sdiodev)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 76b3394..1bfeec6 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -236,122 +236,6 @@ int brcmf_sdioh_interrupt_deregister(struct brcmf_sdio_dev *sdiodev)
 	return 0;
 }
 
-/* IOVar table */
-enum {
-	IOV_MSGLEVEL = 1,
-	IOV_DEVREG,
-	IOV_HCIREGS,
-	IOV_RXCHAIN
-};
-
-const struct brcmu_iovar sdioh_iovars[] = {
-	{"sd_devreg", IOV_DEVREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
-	,
-	{"sd_rxchain", IOV_RXCHAIN, 0, IOVT_BOOL, 0}
-	,
-	{NULL, 0, 0, 0, 0}
-};
-
-int
-brcmf_sdioh_iovar_op(struct brcmf_sdio_dev *sdiodev, const char *name,
-		     void *params, int plen, void *arg, int len, bool set)
-{
-	const struct brcmu_iovar *vi = NULL;
-	int bcmerror = 0;
-	int val_size;
-	s32 int_val = 0;
-	bool bool_val;
-	u32 actionid;
-
-	if (name == NULL || len < 0)
-		return -EINVAL;
-
-	/* Set does not take qualifiers */
-	if (set && (params || plen))
-		return -EINVAL;
-
-	/* Get must have return space;*/
-	if (!set && !(arg && len))
-		return -EINVAL;
-
-	BRCMF_TRACE(("%s: Enter (%s %s)\n", __func__, (set ? "set" : "get"),
-		  name));
-
-	vi = brcmu_iovar_lookup(sdioh_iovars, name);
-	if (vi == NULL) {
-		bcmerror = -ENOTSUPP;
-		goto exit;
-	}
-
-	bcmerror = brcmu_iovar_lencheck(vi, arg, len, set);
-	if (bcmerror != 0)
-		goto exit;
-
-	/* Set up params so get and set can share the convenience variables */
-	if (params == NULL) {
-		params = arg;
-		plen = len;
-	}
-
-	if (vi->type == IOVT_VOID)
-		val_size = 0;
-	else if (vi->type == IOVT_BUFFER)
-		val_size = len;
-	else
-		val_size = sizeof(int);
-
-	if (plen >= (int)sizeof(int_val))
-		memcpy(&int_val, params, sizeof(int_val));
-
-	bool_val = (int_val != 0) ? true : false;
-
-	actionid = set ? IOV_SVAL(vi->varid) : IOV_GVAL(vi->varid);
-	switch (actionid) {
-	case IOV_GVAL(IOV_RXCHAIN):
-		int_val = false;
-		memcpy(arg, &int_val, val_size);
-		break;
-
-	case IOV_GVAL(IOV_DEVREG):
-		{
-			struct brcmf_sdreg *sd_ptr =
-					(struct brcmf_sdreg *) params;
-			u8 data = 0;
-
-			if (brcmf_sdioh_cfg_read
-			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -EIO;
-				break;
-			}
-
-			int_val = (int)data;
-			memcpy(arg, &int_val, sizeof(int_val));
-			break;
-		}
-
-	case IOV_SVAL(IOV_DEVREG):
-		{
-			struct brcmf_sdreg *sd_ptr =
-					(struct brcmf_sdreg *) params;
-			u8 data = (u8) sd_ptr->value;
-
-			if (brcmf_sdioh_cfg_write
-			    (sdiodev, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -EIO;
-				break;
-			}
-			break;
-		}
-
-	default:
-		bcmerror = -ENOTSUPP;
-		break;
-	}
-exit:
-
-	return bcmerror;
-}
-
 extern int
 brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fnc_num, u32 addr,
 		     u8 *data)
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 4296c93..4a814e5 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -276,11 +276,6 @@ extern int brcmf_sdioh_cfg_read(struct brcmf_sdio_dev *sdiodev, uint fuc,
 extern int brcmf_sdioh_cfg_write(struct brcmf_sdio_dev *sdiodev, uint fuc,
 				 u32 addr, u8 *data);
 
-/* handle iovars */
-extern int brcmf_sdioh_iovar_op(struct brcmf_sdio_dev *sdiodev,
-				const char *name, void *params, int plen,
-				void *arg, int len, bool set);
-
 /* Issue abort to the specified function and clear controller as needed */
 extern int brcmf_sdioh_abort(struct brcmf_sdio_dev *sdiodev, uint fnc);
 
-- 
1.7.4.1


