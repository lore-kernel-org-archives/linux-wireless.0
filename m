Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 354FBC282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 10:43:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E779621855
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 10:43:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="McknD4Eq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727153AbfAXKnP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 05:43:15 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36346 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfAXKnP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 05:43:15 -0500
Received: by mail-pg1-f193.google.com with SMTP id n2so2493979pgm.3
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jan 2019 02:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8X9BD9qvrb8sMgcXPa7Y/Ie3jPaxIo5DK8ptg9NeE8Y=;
        b=McknD4EqCXU0Ol7RQDl8aHJcfFy0OQ82t5ZPDVE7B885jBTffpHMJGeC+mU+tMnm3A
         O9pH+PnKQnnHTBu9Cek7qXhzlZ0zF0ndcDw2GvBw9jisvuD7XYhoHEr9DHJbkUx3hPIH
         ehrEIJbduPZ760+TJxY1Q0Awp5tF10YC62gLGSZYcJJfJR37Qg036L8ZlpzzG5oCcnBa
         YtSBrwuVkV8hmYiPexyM+dvrw2/vScO6Hyz90BTQ7J7TbI+2lbxeGqBFXoJpTamhohef
         41H4zikq9mlxq/rFJckK58k2GkBC0PRmLmZW1cZ3dwz70dLcyubrgOixnF9T3VycFmoU
         47KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8X9BD9qvrb8sMgcXPa7Y/Ie3jPaxIo5DK8ptg9NeE8Y=;
        b=sKXZExvVi+Txbt2/QWRZcKB09aYM5ygkagpkAvk18rwdt4D/5m1rMSU/9ovC5RRZMC
         IOZXN5Jw4sWT2r9JKHYCciZrex6RnKnd05QMfHmOdLz64Fzumwq2wiuvwpLssoXJL7ZY
         ixSGN9uUIvmAXynWXiMhAdvi2LYN6ya17slfacbOoAbPnGPmUGyPPBg5x8mUxjzhN064
         qLulWhmmfhqAQLMrM5b1CSX9+TgxjCLAF4R4otO8M234N1fCGNv9Oh/DttdLQV3mJlC5
         jeTrATIL0vx8Z38zpzfNratxWWeYGEaGCqPyYC1R6VXuB6MypMRJ+k0wrss2GxYpeqPH
         hQwQ==
X-Gm-Message-State: AJcUukevFzWGtP6mEHkB58O5vYLBa5Jj29JasAF0RqwK4fXbrEreowr9
        s7tX/kLU4mSPlmlu1I06Btjcy4pxr90=
X-Google-Smtp-Source: ALg8bN6FbPiyTaxzwxH38N80b8mX9Kit1yfvcgYioHX0EA0eLn3QR15GYjQd5qR5m9dr6QS3OU84dw==
X-Received: by 2002:a62:26c7:: with SMTP id m190mr6044979pfm.79.1548326593889;
        Thu, 24 Jan 2019 02:43:13 -0800 (PST)
Received: from BWT-FWA-0475.bluwirelesstechnology.com ([103.248.210.66])
        by smtp.gmail.com with ESMTPSA id c13sm26471125pfo.121.2019.01.24.02.43.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Jan 2019 02:43:12 -0800 (PST)
From:   chaitanya.mgit@gmail.com
To:     linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc:     Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
Subject: [PATCH] cfg80211: reg: remove warn_on for a normal case
Date:   Thu, 24 Jan 2019 16:13:02 +0530
Message-Id: <20190124104302.26051-1-chaitanya.mgit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>

If there are simulatenous queries of regdb, then there might be a case
where multiple queries can trigger request_firmware_no_wait and can have
parallel callbacks being executed asynchronously. In this scenario we
might hit the WARN_ON.

So remove the warn_on, as the code already handles multiple callbacks
gracefully.

Signed-off-by: Chaitanya Tata <chaitanya.tata@bluwireless.co.uk>
---
 net/wireless/reg.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index cce4c16eaaa0..dd58b9909ac9 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1024,8 +1024,13 @@ static void regdb_fw_cb(const struct firmware *fw, void *context)
 	}
 
 	rtnl_lock();
-	if (WARN_ON(regdb && !IS_ERR(regdb))) {
-		/* just restore and free new db */
+	if (regdb && !IS_ERR(regdb)) {
+		/* negative case - a bug
+		 * positive case - can happen due to race in case of multiple cb's in
+		 * queue, due to usage of asynchronous callback
+		 *
+		 * Either case, just restore and free new db.
+		 */
 	} else if (set_error) {
 		regdb = ERR_PTR(set_error);
 	} else if (fw) {
-- 
2.17.1

