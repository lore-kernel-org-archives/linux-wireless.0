Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D12B5C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A05572075C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:01:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A05572075C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJJSWw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:22:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbeJJSWw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:22:52 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C2E0030820D3;
        Wed, 10 Oct 2018 11:01:14 +0000 (UTC)
Received: from shalem.localdomain.com (ovpn-116-109.ams2.redhat.com [10.36.116.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0495169608;
        Wed, 10 Oct 2018 11:01:12 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
Subject: [PATCH v2 3/6] brcmfmac: Add support for first trying to get a board specific nvram file
Date:   Wed, 10 Oct 2018 13:01:00 +0200
Message-Id: <20181010110103.21857-3-hdegoede@redhat.com>
In-Reply-To: <20181010110103.21857-1-hdegoede@redhat.com>
References: <20181010110103.21857-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 10 Oct 2018 11:01:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The nvram files which some brcmfmac chips need are board-specific. To be
able to distribute these as part of linux-firmware, so that devices with
such a wifi chip will work OOTB, multiple (one per board) versions must
co-exist under /lib/firmware.

This commit adds support for callers of the brcmfmac/firmware.c code to
pass in a board_type parameter through the request structure.

If that parameter is set then the code will first try to load
chipmodel.board_type.txt before falling back to the old chipmodel.txt name.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 27 ++++++++++++++++++-
 .../broadcom/brcm80211/brcmfmac/firmware.h    |  1 +
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 08aaf99fee34..6755b2388fbc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -532,6 +532,31 @@ static int brcmf_fw_complete_request(const struct firmware *fw,
 	return (cur->flags & BRCMF_FW_REQF_OPTIONAL) ? 0 : ret;
 }
 
+static int brcmf_fw_request_firmware(const struct firmware **fw,
+				     struct brcmf_fw *fwctx)
+{
+	struct brcmf_fw_item *cur = &fwctx->req->items[fwctx->curpos];
+	int ret;
+
+	/* nvram files are board-specific, first try a board-specific path */
+	if (cur->type == BRCMF_FW_TYPE_NVRAM && fwctx->req->board_type) {
+		char alt_path[BRCMF_FW_NAME_LEN];
+
+		strlcpy(alt_path, cur->path, BRCMF_FW_NAME_LEN);
+		/* strip .txt at the end */
+		alt_path[strlen(alt_path) - 4] = 0;
+		strlcat(alt_path, ".", BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, fwctx->req->board_type, BRCMF_FW_NAME_LEN);
+		strlcat(alt_path, ".txt", BRCMF_FW_NAME_LEN);
+
+		ret = request_firmware(fw, alt_path, fwctx->dev);
+		if (ret == 0)
+			return ret;
+	}
+
+	return request_firmware(fw, cur->path, fwctx->dev);
+}
+
 static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 {
 	struct brcmf_fw *fwctx = ctx;
@@ -544,7 +569,7 @@ static void brcmf_fw_request_done(const struct firmware *fw, void *ctx)
 
 	while (ret == 0 && ++fwctx->curpos < fwctx->req->n_items) {
 		cur = &fwctx->req->items[fwctx->curpos];
-		request_firmware(&fw, cur->path, fwctx->dev);
+		brcmf_fw_request_firmware(&fw, fwctx);
 		ret = brcmf_fw_complete_request(fw, ctx);
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
index 2893e56910f0..a0834be8864e 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.h
@@ -70,6 +70,7 @@ struct brcmf_fw_request {
 	u16 domain_nr;
 	u16 bus_nr;
 	u32 n_items;
+	const char *board_type;
 	struct brcmf_fw_item items[0];
 };
 
-- 
2.19.0

