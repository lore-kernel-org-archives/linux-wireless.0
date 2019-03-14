Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5973C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:19:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B468920657
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 14:19:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QpUTSrmF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfCNOTe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 10:19:34 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53688 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfCNOTd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 10:19:33 -0400
Received: by mail-wm1-f66.google.com with SMTP id e74so3174828wmg.3
        for <linux-wireless@vger.kernel.org>; Thu, 14 Mar 2019 07:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b2/1uARsWqr+DLR5n7mQOJELmFcUp5B6WDBm9ZMjZmk=;
        b=QpUTSrmFMbuPFMXH5QrBFmUHpV7jWu1IyTRqDucfqAUIoR13SpewasERon2SeJp80l
         rAHfj4ohbpirKSlyAWD6fj4gnYtv/RQl1IryMg5a2gtLYBlkKLx/uJhg0gltKAPN6U4E
         8wPCvQlaSOPwUO2xXEg2HPV+G+tI1S9BBHUV3YzDqmWNCbbRB8RFRlzkjvn0/8ez7boZ
         PDx6Awq+MFufAASX65mXbP0tNP1KakYP9hyFLEMXQ3X8hP4YP6/wfuTDZbP0vB8RB3uI
         IjsK6m0Rn9VeSvTxok/0DndizcExLGM0BFbatvodUcZNuUo6bEZ3tWu2cxRu6EK0s1J1
         B56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=b2/1uARsWqr+DLR5n7mQOJELmFcUp5B6WDBm9ZMjZmk=;
        b=ILYK9J/FCZa6nw0WMIW2OA5eJNxFDKQcaAmTIEgNHeScmely+kAWFrbYH6z2ZEJJ0C
         V4NmoW0DptWk6tc/APuguYepYCcadBXTSQdpKhMmTC6+33U/gDVpVpmKRR3UaE27RHyC
         aQ8L1Q7YFeOQ+pdYZdKXLuBtH+7wEUETTyWFVj5sidHg9u9FkMldN37qy52FBb3HJQ74
         9Uoo6fLgQwuBGDTL1uuyucrQ6vAlK4Wbxt4wpo7wnsiaGIn8LSw3XKpBb3SqY2IRbf6F
         VRXjiREAQR0wxe3RJxzODj+a/UEtGf8b/nnks3/e0PVd/nGtOofPkdbQDwDiAZmv0Mag
         uFng==
X-Gm-Message-State: APjAAAU5++H7OUUmzir6gH9OFUoEqXHRMCAFXw99z1SlPRM8NLPeus44
        3OldStubNhzEE/QyywVkQE8AKgoR
X-Google-Smtp-Source: APXvYqwOXQakP/oQBfs9xBil5xJCcAgtcSRL3/2nA02PazD34Zl5q5Ly83jcphouQ0Xmu8sfHLgwJA==
X-Received: by 2002:a7b:cc10:: with SMTP id f16mr2662035wmh.49.1552573171444;
        Thu, 14 Mar 2019 07:19:31 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id z20sm3937555wma.9.2019.03.14.07.19.30
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 14 Mar 2019 07:19:30 -0700 (PDT)
From:   =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org
Subject: [PATCH] rt2x00: code-style fix in rt2800usb.c
Date:   Thu, 14 Mar 2019 15:19:20 +0100
Message-Id: <1552573160-3268-1-git-send-email-pozega.tomislav@gmail.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove space leftovers.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 19eabf1..091a607 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -562,13 +562,13 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 		 * stripped it from the frame. Signal this to mac80211.
 		 */
 		rxdesc->flags |= RX_FLAG_MMIC_STRIPPED;
-        
+
 		if (rxdesc->cipher_status == RX_CRYPTO_SUCCESS) {
 			rxdesc->flags |= RX_FLAG_DECRYPTED;
 		} else if (rxdesc->cipher_status == RX_CRYPTO_FAIL_MIC) {
 			/*
 			 * In order to check the Michael Mic, the packet must have
-			 * been decrypted.  Mac80211 doesnt check the MMIC failure 
+			 * been decrypted.  Mac80211 doesnt check the MMIC failure
 			 * flag to initiate MMIC countermeasures if the decoded flag
 			 * has not been set.
 			 */
-- 
1.7.0.4

