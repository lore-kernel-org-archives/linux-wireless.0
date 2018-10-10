Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6611BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A9C214FF
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 24A9C214FF
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbeJJSW6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:22:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeJJSW6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:22:58 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E53875F793;
        Wed, 10 Oct 2018 11:01:20 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 274442E199;
        Wed, 10 Oct 2018 11:01:19 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 6/6] brcmfmac: Cleanup brcmf_fw_request_done()
Date:   Wed, 10 Oct 2018 13:01:03 +0200
Message-Id: <20181010110103.21857-6-hdegoede@redhat.com>
In-Reply-To: <20181010110103.21857-1-hdegoede@redhat.com>
References: <20181010110103.21857-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 10 Oct 2018 11:01:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The "cur" variable is now only used for a debug print and we already
print the same info from brcmf_fw_complete_request(), so the debug print
does not provide any extra info and we can remove it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c   | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 6755b2388fbc..b38c4b40b235 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -560,22 +560,16 @@ static int brcmf_fw_request_firmware(const struct firmware **fw,
 static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
-	struct brcmf_fw_item *cur;
-	int ret = 0;
-
-	cur = &fwctx->req->items[fwctx->curpos];
+	int ret;
 
 	ret = brcmf_fw_complete_request(fw, fwctx);
 
 	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
-		cur = &fwctx->req->items[fwctx->curpos];
 		brcmf_fw_request_firmware(&fw, fwctx);
 		ret = brcmf_fw_complete_request(fw, ctx);
 	}
 
 	if (ret) {
-		brcmf_dbg(TRACE, "failed err=%d: dev=%s, fw=%s\n", ret,
-			  dev_name(fwctx->dev), cur->path);
 		brcmf_fw_free_request(fwctx->req);
 		fwctx->req = NULL;
 	}
-- 
2.19.0

