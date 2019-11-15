Return-Path: <SRS0=1RAM=ZH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16681C43141
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 09:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DCAAD2073C
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Nov 2019 09:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="i8k502/b";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="U4YXsSxk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfKOJb1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Nov 2019 04:31:27 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33016 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfKOJb1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Nov 2019 04:31:27 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3E4FB6167E; Fri, 15 Nov 2019 09:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573810286;
        bh=kyoQzIqk/N0biphIO3T0zVmlSOFk/cboG6nBTmAQ75k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i8k502/boHBtsa1myBGCF+xc6RnngxvNXhshYubcKdG3wT8Utq9T9DuwTce7Bgo9R
         kAm0dAfznwMuLQWluuTtNOugPF0d7rRNHNL40mTTvgZ2MdPMwfCSAIGvhDtAb4vIH/
         7jypb7UWDjSIDMhCYeMp8tNO9ySRierlNth7/0vg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84DF26169D;
        Fri, 15 Nov 2019 09:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573810264;
        bh=kyoQzIqk/N0biphIO3T0zVmlSOFk/cboG6nBTmAQ75k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U4YXsSxk7l88iO5g/eXc6KPTFpPHhnOkHhpAEoGYkc7YUXmwEAS/nsxe07Fuq13TR
         GXJ+DM8Xb2cfP3aU0H3rENa0qXSK3CTjnbGqxIzhAF/TuO1IRiHdYxQvJ1NfcRUsr6
         wYYQ613DXjBLrkiQvf4IFNgTp0BqGA/HcHNQykq8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 84DF26169D
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org, devicetree@vger.kernel.org
Subject: [PATCH v3 43/49] ath11k: add trace.c
Date:   Fri, 15 Nov 2019 11:29:07 +0200
Message-Id: <1573810153-29623-44-git-send-email-kvalo@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573810153-29623-1-git-send-email-kvalo@codeaurora.org>
References: <1573810153-29623-1-git-send-email-kvalo@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(patches split for easier review, see the cover letter for more)

Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
---
 drivers/net/wireless/ath/ath11k/trace.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/trace.c b/drivers/net/wireless/ath/ath11k/trace.c
new file mode 100644
index 000000000000..f0cc49ba0387
--- /dev/null
+++ b/drivers/net/wireless/ath/ath11k/trace.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: BSD-3-Clause-Clear
+/*
+ * Copyright (c) 2019 The Linux Foundation. All rights reserved.
+ */
+
+#include <linux/module.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace.h"

