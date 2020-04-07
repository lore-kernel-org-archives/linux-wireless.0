Return-Path: <SRS0=LB6b=5X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D6E8C2BA1A
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Apr 2020 00:07:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1037620768
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Apr 2020 00:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586218041;
	bh=RAwU162BS26ai5syTm5AqPDNd16wG2wCjwkS9R5Y0xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=iaXNSa2IWtcJFQsJbj/E+0wZJXjGalMp8Q/oV4YJLJZ5EiC1eZgps7Q8OHuGBWML6
	 TQC89nYWGLmQ/gKNfjOMTtGIYQUxoUrhByyk22/nHQRnVpb8v7xNCo4wgBncK4/+vB
	 lOWmldpQldM7rKhGuxuev4g26NLrrz4Z7CpAOH5w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbgDGAHQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:07:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgDGACB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Apr 2020 20:02:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8016F2083E;
        Tue,  7 Apr 2020 00:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217721;
        bh=RAwU162BS26ai5syTm5AqPDNd16wG2wCjwkS9R5Y0xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y0pDEekeh3iXTwTxfJQHVif6oK8nTKfXcFIco6TtWCMAL9Wd9oWYSFMOtMu4FEUW2
         Pd0XBy2zz0H/om3mt6zrp4N4qk+681igQUVPkJvp2UUln0aQzstA6cS2H0ObJfZZ0J
         3O3+99ubAMxXdg/cI7OGnA/sPGxm6orfMIMiimbI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 07/32] iwlwifi: yoyo: don't add TLV offset when reading FIFOs
Date:   Mon,  6 Apr 2020 20:01:25 -0400
Message-Id: <20200407000151.16768-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000151.16768-1-sashal@kernel.org>
References: <20200407000151.16768-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit a5688e600e78f9fc68102bf0fe5c797fc2826abe ]

The TLV offset is only used to read registers, while the offset used for
the FIFO addresses are hard coded in the driver and not given by the
TLV.

If we try to apply the TLV offset when reading the FIFOs, we'll read
from invalid addresses, causing the driver to hang.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: 8d7dea25ada7 ("iwlwifi: dbg_ini: implement Rx fifos dump")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151129.fbab869c26fa.I4ddac20d02f9bce41855a816aa6855c89bc3874e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
index 386ca67ec7b4e..ef65e1ea374fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
+++ b/drivers/net/wireless/intel/iwlwifi/fw/dbg.c
@@ -8,7 +8,7 @@
  * Copyright(c) 2008 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -31,7 +31,7 @@
  * Copyright(c) 2005 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * Copyright(c) 2015 - 2017 Intel Deutschland GmbH
- * Copyright(c) 2018 - 2019 Intel Corporation
+ * Copyright(c) 2018 - 2020 Intel Corporation
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -1373,11 +1373,7 @@ static int iwl_dump_ini_rxf_iter(struct iwl_fw_runtime *fwrt,
 		goto out;
 	}
 
-	/*
-	 * region register have absolute value so apply rxf offset after
-	 * reading the registers
-	 */
-	offs += rxf_data.offset;
+	offs = rxf_data.offset;
 
 	/* Lock fence */
 	iwl_write_prph_no_grab(fwrt->trans, RXF_SET_FENCE_MODE + offs, 0x1);
-- 
2.20.1

