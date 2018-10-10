Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E4EC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 132082075C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 132082075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbeJJSWt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:22:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeJJSWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:22:49 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5295307D912;
        Wed, 10 Oct 2018 11:01:12 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A3EDA44FBF;
        Wed, 10 Oct 2018 11:01:07 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 2/6] brcmfmac: Remove recursion from firmware load error handling
Date:   Wed, 10 Oct 2018 13:00:59 +0200
Message-Id: <20181010110103.21857-2-hdegoede@redhat.com>
In-Reply-To: <20181010110103.21857-1-hdegoede@redhat.com>
References: <20181010110103.21857-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Wed, 10 Oct 2018 11:01:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Before this commit brcmf_fw_request_done would call
brcmf_fw_request_next_item to load the next item, which on an error would
call brcmf_fw_request_done, which if the error is recoverable (*) will
then continue calling brcmf_fw_request_next_item for the next item again
which on an error will call brcmf_fw_request_done again...

This does not blow up because we only have a limited number of items so
we never recurse too deep. But the recursion is still quite ugly and
frankly is giving me a headache, so lets fix this.

This commit fixes this by removing brcmf_fw_request_next_item and by
making brcmf_fw_get_firmwares and brcmf_fw_request_done directly call
firmware_request_nowait resp. firmware_request themselves.

*) brcmf_fw_request_nvram_done fallback path succeeds or
   BRCMF_FW_REQF_OPTIONAL is set

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 65 ++++++-------------
 1 file changed, 19 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 784c84f0e9e7..08aaf99fee34 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -532,33 +532,6 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
 }
 
-static int brcmf_fw_request_next_item(struct brcmf_fw *fwctx, bool async)
-{
-	struct brcmf_fw_item *cur;
-	const struct firmware *fw = NULL;
-	int ret;
-
-	cur = &fwctx->req->items[fwctx->curpos];
-
-	brcmf_dbg(TRACE, "%srequest for %s\n", async ? "async " : "",
-		  cur->path);
-
-	if (async)
-		ret = request_firmware_nowait(THIS_MODULE, true, cur->path,
-					      fwctx->dev, GFP_KERNEL, fwctx,
-					      brcmf_fw_request_done);
-	else
-		ret = request_firmware(&fw, cur->path, fwctx->dev);
-
-	if (ret < 0) {
-		brcmf_fw_request_done(NULL, fwctx);
-	} else if (!async && fw) {
-		brcmf_fw_complete_request(fw, fwctx);
-		return -EAGAIN;
-	}
-	return 0;
-}
-
 static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
@@ -568,26 +541,19 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 	cur = &fwctx->req->items[fwctx->curpos];
 
 	ret = brcmf_fw_complete_request(fw, fwctx);
-	if (ret < 0)
-		goto fail;
-
-	do {
-		if (++fwctx->curpos == fwctx->req->n_items) {
-			ret = 0;
-			goto done;
-		}
 
-		ret = brcmf_fw_request_next_item(fwctx, false);
-	} while (ret == -EAGAIN);
-
-	return;
+	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
+		cur = &fwctx->req->items[fwctx->curpos];
+		request_firmware(&fw, cur->path, fwctx->dev);
+		ret = brcmf_fw_complete_request(fw, ctx);
+	}
 
-fail:
-	brcmf_dbg(TRACE, "failed err=%d: dev=%s, fw=%s\n", ret,
-		  dev_name(fwctx->dev), cur->path);
-	brcmf_fw_free_request(fwctx->req);
-	fwctx->req = NULL;
-done:
+	if (ret) {
+		brcmf_dbg(TRACE, "failed err=%d: dev=%s, fw=%s\n", ret,
+			  dev_name(fwctx->dev), cur->path);
+		brcmf_fw_free_request(fwctx->req);
+		fwctx->req = NULL;
+	}
 	fwctx->done(fwctx->dev, ret, fwctx->req);
 	kfree(fwctx);
 }
@@ -611,7 +577,9 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 			   void (*fw_cb)(struct device *dev, int err,
 					 struct brcmf_fw_request *req))
 {
+	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
+	int ret;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
 	if (!fw_cb)
@@ -628,7 +596,12 @@ int brcmf_fw_get_firmwares(struct device *dev, struct brcmf_fw_request *req,
 	fwctx->req = req;
 	fwctx->done = fw_cb;
 
-	brcmf_fw_request_next_item(fwctx, true);
+	ret = request_firmware_nowait(THIS_MODULE, true, first->path,
+				      fwctx->dev, GFP_KERNEL, fwctx,
+				      brcmf_fw_request_done);
+	if (ret < 0)
+		brcmf_fw_request_done(NULL, fwctx);
+
 	return 0;
 }
 
-- 
2.19.0

