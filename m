Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36433 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbbFDULU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jun 2015 16:11:20 -0400
Received: by wibdq8 with SMTP id dq8so136183001wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Jun 2015 13:11:19 -0700 (PDT)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH RESEND] brcmfmac: use direct data pointer in NVRAM parser struct
Date: Thu,  4 Jun 2015 22:11:07 +0200
Message-Id: <1433448667-3493-1-git-send-email-zajec5@gmail.com> (sfid-20150604_221123_547510_34C0FBB1)
In-Reply-To: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
References: <1432813063-30922-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As we plan to add support for platform NVRAM we should store direct
data pointer without the extra struct firmware layer. This will allow
us to support other sources with the only requirement being u8 buffer.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Acked-by: Arend van Spriel <arend@broadcom.com>
---
RESEND with updated S-o-b & added Acked-by.

Thank you Arend!
---
 drivers/net/wireless/brcm80211/brcmfmac/firmware.c | 40 +++++++++++-----------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
index 7ae6461..b72df87 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/firmware.c
@@ -43,7 +43,7 @@ enum nvram_parser_state {
  * struct nvram_parser - internal info for parser.
  *
  * @state: current parser state.
- * @fwnv: input buffer being parsed.
+ * @data: input buffer being parsed.
  * @nvram: output buffer with parse result.
  * @nvram_len: lenght of parse result.
  * @line: current line.
@@ -55,7 +55,7 @@ enum nvram_parser_state {
  */
 struct nvram_parser {
 	enum nvram_parser_state state;
-	const struct firmware *fwnv;
+	const u8 *data;
 	u8 *nvram;
 	u32 nvram_len;
 	u32 line;
@@ -91,7 +91,7 @@ static enum nvram_parser_state brcmf_nvram_handle_idle(struct nvram_parser *nvp)
 {
 	char c;
 
-	c = nvp->fwnv->data[nvp->pos];
+	c = nvp->data[nvp->pos];
 	if (c == '\n')
 		return COMMENT;
 	if (is_whitespace(c))
@@ -115,16 +115,16 @@ static enum nvram_parser_state brcmf_nvram_handle_key(struct nvram_parser *nvp)
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
 	} else if (!is_nvram_char(c) || c == ' ') {
 		brcmf_dbg(INFO, "warning: ln=%d:col=%d: '=' expected, skip invalid key entry\n",
@@ -145,11 +145,11 @@ brcmf_nvram_handle_value(struct nvram_parser *nvp)
 	char *ekv;
 	u32 cplen;
 
-	c = nvp->fwnv->data[nvp->pos];
+	c = nvp->data[nvp->pos];
 	if (!is_nvram_char(c)) {
 		/* key,value pair complete */
-		ekv = (u8 *)&nvp->fwnv->data[nvp->pos];
-		skv = (u8 *)&nvp->fwnv->data[nvp->entry];
+		ekv = (u8 *)&nvp->data[nvp->pos];
+		skv = (u8 *)&nvp->data[nvp->entry];
 		cplen = ekv - skv;
 		if (nvp->nvram_len + cplen + 1 >= BRCMF_FW_MAX_NVRAM_SIZE)
 			return END;
@@ -170,7 +170,7 @@ brcmf_nvram_handle_comment(struct nvram_parser *nvp)
 {
 	char *eoc, *sol;
 
-	sol = (char *)&nvp->fwnv->data[nvp->pos];
+	sol = (char *)&nvp->data[nvp->pos];
 	eoc = strchr(sol, '\n');
 	if (!eoc) {
 		eoc = strchr(sol, '\0');
@@ -201,17 +201,17 @@ static enum nvram_parser_state
 };
 
 static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
-				   const struct firmware *nv)
+				   const u8 *data, size_t data_len)
 {
 	size_t size;
 
 	memset(nvp, 0, sizeof(*nvp));
-	nvp->fwnv = nv;
+	nvp->data = data;
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
@@ -356,18 +356,18 @@ fail:
  * and converts newlines to NULs. Shortens buffer as needed and pads with NULs.
  * End of buffer is completed with token identifying length of buffer.
  */
-static void *brcmf_fw_nvram_strip(const struct firmware *nv, u32 *new_length,
-				  u16 domain_nr, u16 bus_nr)
+static void *brcmf_fw_nvram_strip(const u8 *data, size_t data_len,
+				  u32 *new_length, u16 domain_nr, u16 bus_nr)
 {
 	struct nvram_parser nvp;
 	u32 pad;
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
@@ -426,7 +426,7 @@ static void brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 		goto fail;
 
 	if (fw) {
-		nvram = brcmf_fw_nvram_strip(fw, &nvram_length,
+		nvram = brcmf_fw_nvram_strip(fw->data, fw->size, &nvram_length,
 					     fwctx->domain_nr, fwctx->bus_nr);
 		release_firmware(fw);
 		if (!nvram && !(fwctx->flags & BRCMF_FW_REQ_NV_OPTIONAL))
-- 
1.8.4.5

