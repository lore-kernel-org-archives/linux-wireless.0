Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 488C8C433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Nov 2022 16:43:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238928AbiKPQne (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Nov 2022 11:43:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbiKPQm4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2022 11:42:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46AC10DF
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 08:39:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4188161EE1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Nov 2022 16:39:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD8DC433D6;
        Wed, 16 Nov 2022 16:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668616749;
        bh=afi8JZrLiX2wXtdlF6dXd1AGUNdqgAzSllZrAXc550s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mVVBxWpPF0s5Mq62UwKwrz9yI1MJswMVQJyx0TU2uY0Fw1fnI8+9k4kOTw2rNySpE
         aFO2N++BtEBab+lS4NV2pF7f7zTzMVTloZM+a0IxxUmw03wbELi1qp7wg+CKFtgBKk
         D+Q40X41mjYiMtR5ZMXc5NPJYKYxi2HPznZBhEjTYeZ5MulrM3qkd4lnY2lyMFkAdd
         mfXkiI3/w6I7EPcC3n3hboQM18yjxpG1kIdgPYGA+WibcUfJpVzpAI6KfTETKc9jJT
         NdHEnEk+ZlzkIvni7A/cRhU0MKvFdg3AfrfJ5oe7oz2Mdu/uFj6jfGbkdsqBRgpB0q
         Gx47gb7/n1qAQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     linux-wireless@vger.kernel.org
Cc:     ath12k@lists.infradead.org
Subject: [PATCH v2 02/50] wifi: ath12k: add Makefile
Date:   Wed, 16 Nov 2022 18:38:14 +0200
Message-Id: <20221116163902.24996-3-kvalo@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221116163902.24996-1-kvalo@kernel.org>
References: <20221116163902.24996-1-kvalo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Kalle Valo <quic_kvalo@quicinc.com>

(Patches split into one patch per file for easier review, but the final
commit will be one big patch. See the cover letter for more info.)

Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
---
 drivers/net/wireless/ath/ath12k/Makefile | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/Makefile b/drivers/net/wireless/ath/ath12k/Makefile
new file mode 100644
index 000000000000..62c52e733b5e
--- /dev/null
+++ b/drivers/net/wireless/ath/ath12k/Makefile
@@ -0,0 +1,27 @@
+# SPDX-License-Identifier: BSD-3-Clause-Clear
+obj-$(CONFIG_ATH12K) += ath12k.o
+ath12k-y += core.o \
+	    hal.o \
+	    hal_tx.o \
+	    hal_rx.o \
+	    wmi.o \
+	    mac.o \
+	    reg.o \
+	    htc.o \
+	    qmi.o \
+	    dp.o  \
+	    dp_tx.o \
+	    dp_rx.o \
+	    debug.o \
+	    ce.o \
+	    peer.o \
+	    dbring.o \
+	    hw.o \
+	    mhi.o \
+	    pci.o \
+	    dp_mon.o
+
+ath12k-$(CONFIG_ATH12K_TRACING) += trace.o
+
+# for tracing framework to find trace.h
+CFLAGS_trace.o := -I$(src)

