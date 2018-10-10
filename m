Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA30EC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662D02075C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 662D02075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbeJJSWo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41994 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeJJSWo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:22:44 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 66FEBA4D29;
        Wed, 10 Oct 2018 11:01:07 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8A0D658772;
        Wed, 10 Oct 2018 11:01:05 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 1/6] brcmfmac: Remove firmware-loading code duplication
Date:   Wed, 10 Oct 2018 13:00:58 +0200
Message-Id: <20181010110103.21857-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 10 Oct 2018 11:01:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

brcmf_fw_request_next_item and brcmf_fw_request_done both have identical
code to complete the fw-request depending on the item-type.

This commit adds a new brcmf_fw_complete_request helper removing this code
duplication.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 62 +++++++++----------
 1 file changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 9095b830ae4d..784c84f0e9e7 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -504,6 +504,34 @@ static int brcmf_fw_request_nvram_done(const struct firmware *fw, void *ctx)
 	return -ENOENT;
 }
 
+static int brcmf_fw_complete_request(const struct firmware *fw,
+				     struct brcmf_fw *fwctx)
+{
+	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
+	int ret = 0;
+
+	brcmf_dbg(TRACE, "firmware %s %sfound\n", cur->path, fw ? "" : "not ");
+
+	switch (cur->type) {
+	case BRCMF_FW_TYPE_NVRAM:
+		ret = brcmf_fw_request_nvram_done(fw, fwctx);
+		break;
+	case BRCMF_FW_TYPE_BINARY:
+		if (fw)
+			cur->binary = fw;
+		else
+			ret = -ENOENT;
+		break;
+	default:
+		/* something fishy here so bail out early */
+		brcmf_err("unknown fw type: %d\n", cur->type);
+		release_firmware(fw);
+		ret = -EINVAL;
+	}
+
+	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
+}
+
 static int brcmf_fw_request_next_item(struct brcmf_fw *fwctx, bool async)
 {
 	struct brcmf_fw_item *cur;
@@ -525,15 +553,7 @@ static int brcmf_fw_request_next_item(struct brcmf_fw *fwctx, bool async)
 	if (ret < 0) {
 		brcmf_fw_request_done(NULL, fwctx);
 	} else if (!async && fw) {
-		brcmf_dbg(TRACE, "firmware %s %sfound\n", cur->path,
-			  fw ? "" : "not ");
-		if (cur->type == BRCMF_FW_TYPE_BINARY)
-			cur->binary = fw;
-		else if (cur->type == BRCMF_FW_TYPE_NVRAM)
-			brcmf_fw_request_nvram_done(fw, fwctx);
-		else
-			release_firmware(fw);
-
+		brcmf_fw_complete_request(fw, fwctx);
 		return -EAGAIN;
 	}
 	return 0;
@@ -547,28 +567,8 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 
 	cur = &fwctx->req->items[fwctx->curpos];
 
-	brcmf_dbg(TRACE, "enter: firmware %s %sfound\n", cur->path,
-		  fw ? "" : "not ");
-
-	if (!fw)
-		ret = -ENOENT;
-
-	switch (cur->type) {
-	case BRCMF_FW_TYPE_NVRAM:
-		ret = brcmf_fw_request_nvram_done(fw, fwctx);
-		break;
-	case BRCMF_FW_TYPE_BINARY:
-		cur->binary = fw;
-		break;
-	default:
-		/* something fishy here so bail out early */
-		brcmf_err("unknown fw type: %d\n", cur->type);
-		release_firmware(fw);
-		ret = -EINVAL;
-		goto fail;
-	}
-
-	if (ret < 0 && !(cur->flags & BRCMF_FW_REQF_OPTIONAL))
+	ret = brcmf_fw_complete_request(fw, fwctx);
+	if (ret < 0)
 		goto fail;
 
 	do {
-- 
2.19.0

