Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:43046 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbETMJ4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 08:09:56 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	<linux-mips@linux-mips.org>, Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 6/6] brcmfmac: Add support for host platform NVRAM loading.
Date: Wed, 20 May 2015 14:09:52 +0200
Message-ID: <1432123792-4155-7-git-send-email-arend@broadcom.com> (sfid-20150520_141014_775046_FA0E85AE)
In-Reply-To: <1432123792-4155-1-git-send-email-arend@broadcom.com>
References: <1432123792-4155-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Host platforms such as routers supported by OpenWRT can
support NVRAM reading directly from internal NVRAM store.
With this patch the nvram load routines will fall back to
this method when there is no nvram file and support is
available in the kernel.

Cc: linux-mips@linux-mips.org
Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Daniel (Deognyoun) Kim <dekim@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Kalle,

This patch relies on a change which has been submitted to the
linux-mips maintainer [1]. However, the brcmfmac code that relies on
it is under CONFIG_BCM47XX flag. Still need to know whether that
patch will be accepted or not before applying this one.

Regards,
Arend

[1] http://mid.gmane.org/1432122655-3224-1-git-send-email-arend@broadcom.com
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 107 ++++++++++++++-------
 1 file changed, 72 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 8ff31ff..bf8928d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -19,6 +19,9 @@
 #include <linux/device.h>
 #include <linux/firmware.h>
 #include <linux/module.h>
+#if IS_ENABLED(CONFIG_BCM47XX)
+#include <linux/bcm47xx_nvram.h>
+#endif
 
 #include "debug.h"
 #include "firmware.h"
@@ -43,7 +46,8 @@ enum nvram_parser_state {
  * struct nvram_parser - internal info for parser.
  *
  * @state: current parser state.
- * @fwnv: input buffer being parsed.
+ * @data: input buffer data pointer.
+ * @data_len : len of input buffer.
  * @nvram: output buffer with parse result.
  * @nvram_len: lenght of parse result.
  * @line: current line.
@@ -55,7 +59,8 @@ enum nvram_parser_state {
  */
 struct nvram_parser {
 	enum nvram_parser_state state;
-	const struct firmware *fwnv;
+	u8 *data;
+	u32 data_len;
 	u8 *nvram;
 	u32 nvram_len;
 	u32 line;
@@ -66,6 +71,27 @@ struct nvram_parser {
 	bool multi_dev_v2;
 };
 
+#if IS_ENABLED(CONFIG_BCM47XX)
+static char *brcmf_nvram_get_contents(size_t *nvram_size)
+{
+	return bcm47xx_nvram_get_contents(nvram_size);
+}
+
+static void brcmf_nvram_release_contents(char *nvram)
+{
+	bcm47xx_nvram_release_contents(nvram);
+}
+#else
+static char *brcmf_nvram_get_contents(size_t *nvram_size)
+{
+	return NULL;
+}
+
+static void brcmf_nvram_release_contents(char *nvram)
+{
+}
+#endif
+
 static bool is_nvram_char(char c)
 {
 	/* comment marker excluded */
@@ -85,7 +111,7 @@ static enum nvram_parser_state brcmf_nvram_handle_idle(struct nvram_parser *nvp)
 {
 	char c;
 
-	c = nvp->fwnv->data[nvp->pos];
+	c = nvp->data[nvp->pos];
 	if (c == '\n')
 		return COMMENT;
 	if (is_whitespace(c))
@@ -109,16 +135,16 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
 	enum nvram_parser_state st = nvp->state;
 	char c;
 
-	c = nvp->fwnv->data[nvp->pos];
+	c = nvp->data[nvp->pos];
 	if (c == '=') {
 		/* ignore RAW1 by treating as comment */
-		if (strncmp(&nvp->fwnv->data[nvp->entry], "RAW1", 4) == 0)
+		if (strncmp(&nvp->data[nvp->entry], "RAW1", 4) == 0)
 			st = COMMENT;
 		else
 			st = VALUE;
-		if (strncmp(&nvp->fwnv->data[nvp->entry], "devpath", 7) == 0)
+		if (strncmp(&nvp->data[nvp->entry], "devpath", 7) == 0)
 			nvp->multi_dev_v1 = true;
-		if (strncmp(&nvp->fwnv->data[nvp->entry], "pcie/", 5) == 0)
+		if (strncmp(&nvp->data[nvp->entry], "pcie/", 5) == 0)
 			nvp->multi_dev_v2 = true;
 	} else if (!is_nvram_char(c)) {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
@@ -139,11 +165,11 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
 	char *ekv;
 	u32 cplen;
 
-	c = nvp->fwnv->data[nvp->pos];
-	if (!is_nvram_char(c)) {
+	c = nvp->data[nvp->pos];
+	if (!is_nvram_char(c) && (c != ' ')) {
 		/* key,value pair complete */
-		ekv = (u8 *)&nvp->fwnv->data[nvp->pos];
-		skv = (u8 *)&nvp->fwnv->data[nvp->entry];
+		ekv = (u8 *)&nvp->data[nvp->pos];
+		skv = (u8 *)&nvp->data[nvp->entry];
 		cplen = ekv - skv;
 		if (nvp->nvram_len + cplen + 1 >= BRCMF_FW_MAX_NVRAM_SIZE)
 			return END;
@@ -164,7 +190,7 @@ brcmf_nvram_handle_comment(struct nvram_parser *nvp)
 {
 	char *eol, *sol;
 
-	sol = (char *)&nvp->fwnv->data[nvp->pos];
+	sol = (char *)&nvp->data[nvp->pos];
 	eol = strchr(sol, '\n');
 	if (eol == NULL)
 		return END;
@@ -191,18 +217,20 @@ static enum nvram_parser_state
 	brcmf_nvram_handle_end
 };
 
-static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
-				   const struct firmware *nv)
+static int brcmf_init_nvram_parser(struct nvram_parser *nvp, u8 *data,
+				   u32 data_len)
 {
 	size_t size;
 
 	memset(nvp, 0, sizeof(*nvp));
-	nvp->fwnv = nv;
+	nvp->data = data;
+	nvp->data_len = data_len;
+
 	/* Limit size to MAX_NVRAM_SIZE, some files contain lot of comment */
-	if (nv->size > BRCMF_FW_MAX_NVRAM_SIZE)
+	if (data_len > BRCMF_FW_MAX_NVRAM_SIZE)
 		size = BRCMF_FW_MAX_NVRAM_SIZE;
 	else
-		size = nv->size;
+		size = data_len;
 	/* Alloc for extra 0 byte + roundup by 4 + length field */
 	size += 1 + 3 + sizeof(u32);
 	nvp->nvram = kzalloc(size, GFP_KERNEL);
@@ -342,7 +370,7 @@ fail:
  * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
  * End of buffer is completed with token identifying length of buffer.
  */
-static void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length,
+static void *brcmf_fw_nvram_strip(u8 *data, u32 data_len, u32 *new_length,
 				  u16 domain_nr, u16 bus_nr)
 {
 	struct nvram_parser nvp;
@@ -350,10 +378,10 @@ static void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length,
 	u32 token;
 	__le32 token_le;
 
-	if (brcmf_init_nvram_parser(&nvp, nv) < 0)
+	if (brcmf_init_nvram_parser(&nvp, data, data_len) < 0)
 		return NULL;
 
-	while (nvp.pos < nv->size) {
+	while (nvp.pos < data_len) {
 		nvp.state = nv_parser_states[nvp.state](&nvp);
 		if (nvp.state == END)
 			break;
@@ -406,19 +434,34 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	struct brcmf_fw *fwctx = ctx;
 	u32 nvram_length = 0;
 	void *nvram = NULL;
+	u8 *data = NULL;
+	size_t data_len;
+	bool raw_nvram;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(fwctx->dev));
-	if (!fw && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-		goto fail;
+	if ((fw) && (fw->data)) {
+		data = (u8 *)fw->data;
+		data_len = fw->size;
+		raw_nvram = false;
+	} else {
+		data = brcmf_nvram_get_contents(&data_len);
+		if (!data && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+			goto fail;
+		raw_nvram = true;
+	}
 
-	if (fw) {
-		nvram = brcmf_fw_nvram_strip(fw, &nvram_length,
+	if (data) {
+		nvram = brcmf_fw_nvram_strip(data, (u32)data_len, &nvram_length,
 					     fwctx->domain_nr, fwctx->bus_nr);
-		release_firmware(fw);
-		if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-			goto fail;
+		if (raw_nvram)
+			brcmf_nvram_release_contents(data);
 	}
 
+	if (fw)
+		release_firmware(fw);
+	if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
+		goto fail;
+
 	fwctx->done(fwctx->dev, fwctx->code, nvram, nvram_length);
 	kfree(fwctx);
 	return;
@@ -453,15 +496,9 @@ static void brcmf_fw_request_code_done(const struct firmware *fw, void *ctx)
 	if (!ret)
 		return;
 
-	/* when nvram is optional call .done() callback here */
-	if (fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL) {
-		fwctx->done(fwctx->dev, fw, NULL, 0);
-		kfree(fwctx);
-		return;
-	}
+	brcmf_fw_request_nvram_done(NULL, fwctx);
+	return;
 
-	/* failed nvram request */
-	release_firmware(fw);
 fail:
 	brcmf_dbg(TRACE, "failed: dev=%s\n", dev_name(fwctx->dev));
 	device_release_driver(fwctx->dev);
-- 
1.9.1

