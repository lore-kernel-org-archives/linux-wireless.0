Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C842C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:33:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 07EB120880
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 10:33:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="p82Txakj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725891AbfBUKdd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 05:33:33 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34140 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbfBUKdd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 05:33:33 -0500
Received: by mail-lj1-f193.google.com with SMTP id l5so20132813lje.1
        for <linux-wireless@vger.kernel.org>; Thu, 21 Feb 2019 02:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J3wkq8BVOiG+cWlYBh4iPXQxstMyGutzZ1BTisCisPI=;
        b=p82TxakjNJjFmnyYB3RHZz+zgZaBaxugqqS5BqO2HX7UpNvK/eRHxsvLkJYQJQiVSx
         /mGBzblwsoJlWvpeyb7uVQHjwh8pZHY0/lWQC0rjkuGQZiDeSLgPs+lzeEu5Qq2C8i86
         y4o2iLpPy+Ct++Xn4DPiwEHW67E2yuW+8x3uE3roB7v4jRU4FhgszxSKnz0GRCDO730w
         f0SzdTHHVaan7f9vQFUzpBaXctNSN1CRc18F7UrcKdc/kj7Jbp4EcuCtWyVNs1Nn2wZI
         karb9KBodrV3AbeGL3LEKRblDUhCHpKb01C4maLNUPucyfH6I+4eHu55y6fwRZSYHeUS
         zt2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J3wkq8BVOiG+cWlYBh4iPXQxstMyGutzZ1BTisCisPI=;
        b=ck0/Mc+NTYeXG76AqNgxji3iunZaMAXY4qC6F0jrbM0GnX0nxeP7Lpm2UuK+uL1mt0
         z4Nkl9e9Zx3avAumx6KZWJOLncCDmA6R6Y9sVJvhJnQib7eHnzaP87VIEvtQlwVaDEbF
         tfbpWevNsp1snSzu1xd/sgzy/PzI2t2ffzVl30HHUZFLv3/OVlsUm1humHR52PKp40UY
         xUQ8XBXr+HYCRBKrqMnSB60krEZOLTRniQyGqcSh5v/9fFO1huS/5oqn60zcrqNPx0Dh
         HA4/ZWLBh5V9bkletnn5CxjOIVq/D/YikyhZPPmCHzn9E0iookHjvqbsGQU5PaizmxCy
         HTRw==
X-Gm-Message-State: AHQUAuYKp/RC3YZHvSjTYv8Tw5BFtDIpcmn8d4oxbnIVCHvWgbf2+Gy7
        NeySSJovBUM7OYR/Cx+wWBY=
X-Google-Smtp-Source: AHgI3IZ+EeKV1/OG6NFnKY7DDRepNafjSFWa5HObAmzhKKDsYjIZnCqsmIYypcLj2TkXkS+dlxSkCg==
X-Received: by 2002:a2e:6c04:: with SMTP id h4-v6mr23543819ljc.92.1550745210722;
        Thu, 21 Feb 2019 02:33:30 -0800 (PST)
Received: from elitebook.lan (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.gmail.com with ESMTPSA id j14sm6059064lfc.28.2019.02.21.02.33.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 02:33:30 -0800 (PST)
From:   =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>
Subject: [PATCH wireless-drivers-next 1/2] brcmfmac: fix size of the struct msgbuf_ring_status
Date:   Thu, 21 Feb 2019 11:33:24 +0100
Message-Id: <20190221103325.28228-1-zajec5@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Rafał Miłecki <rafal@milecki.pl>

This updates host struct to match the in-firmawre definition. It's a
cosmetic change as it only applies to the reserved struct space.

Fixes: c988b78244df ("brcmfmac: print firmware reported ring status errors")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index aef2d4092872..d711dc8ed606 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -139,7 +139,7 @@ struct msgbuf_ring_status {
 	struct msgbuf_common_hdr	msg;
 	struct msgbuf_completion_hdr	compl_hdr;
 	__le16				write_idx;
-	__le32				rsvd0[5];
+	__le16				rsvd0[5];
 };
 
 struct msgbuf_rx_event {
-- 
2.20.1

