Return-Path: <SRS0=TTqJ=XV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ECC7C4360C
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 13:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D08BD222C0
	for <linux-wireless@archiver.kernel.org>; Thu, 26 Sep 2019 13:36:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HCBsG2Kd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HCBsG2Kd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfIZNg0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 26 Sep 2019 09:36:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726094AbfIZNg0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Sep 2019 09:36:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5E9F760F3A; Thu, 26 Sep 2019 13:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569504985;
        bh=cLlAG1hDaIZeSw3bMsCwMXzg06crBIe5m/uqx7JPLG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCBsG2KdIRHlFVZKk++TFXl31T+IsOZZzYcXDptRRlq5XJQVQJiwFoTCUXisQ8ibc
         DshLcDWLDlNsAbTT6D3cRZTzhNEBQCvsFuKswkY3r+qpfV4nC6+P6d783eE3uWwCMG
         WGJ8xraWbcq/E5JJnC8cNlxIVEDrNreekLKGGiQs=
Received: from localhost (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: akolli@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B3CC60BF4;
        Thu, 26 Sep 2019 13:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569504985;
        bh=cLlAG1hDaIZeSw3bMsCwMXzg06crBIe5m/uqx7JPLG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCBsG2KdIRHlFVZKk++TFXl31T+IsOZZzYcXDptRRlq5XJQVQJiwFoTCUXisQ8ibc
         DshLcDWLDlNsAbTT6D3cRZTzhNEBQCvsFuKswkY3r+qpfV4nC6+P6d783eE3uWwCMG
         WGJ8xraWbcq/E5JJnC8cNlxIVEDrNreekLKGGiQs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B3CC60BF4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=akolli@codeaurora.org
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        Anilkumar Kolli <akolli@codeaurora.org>
Subject: [PATCH 2/2] ath10k: fix backtrace on coredump
Date:   Thu, 26 Sep 2019 19:07:01 +0530
Message-Id: <1569505021-20515-2-git-send-email-akolli@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1569505021-20515-1-git-send-email-akolli@codeaurora.org>
References: <1569505021-20515-1-git-send-email-akolli@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

In a multiradio board with one QCA9984 and one AR9987
after enabling the crashdump with module parameter
coredump_mask=7, below backtrace is seen.

vmalloc: allocation failure: 0 bytes
 kworker/u4:0: page allocation failure: order:0, mode:0x80d2
 CPU: 0 PID: 6 Comm: kworker/u4:0 Not tainted 3.14.77 #130
 Workqueue: ath10k_wq ath10k_core_register_work [ath10k_core]
 (unwind_backtrace) from [<c021abf8>] (show_stack+0x10/0x14)
 (dump_stack+0x80/0xa0)
 (warn_alloc_failed+0xd0/0xfc)
 (__vmalloc_node_range+0x1b4/0x1d8)
 (__vmalloc_node+0x34/0x40)
 (vzalloc+0x24/0x30)
 (ath10k_coredump_register+0x6c/0x88 [ath10k_core])
 (ath10k_core_register_work+0x350/0xb34 [ath10k_core])
 (process_one_work+0x20c/0x32c)
 (worker_thread+0x228/0x360)

This is due to ath10k_hw_mem_layout is not defined for AR9987.
For coredump undefined hw ramdump_size is 0.
Check for the ramdump_size before allocation memory.

Tested on: AR9987, QCA9984
FW version: 10.4-3.9.0.2-00044

Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index ecd3dd5d8356..a127122b4721 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1208,9 +1208,11 @@ static struct ath10k_dump_file_data *ath10k_coredump_build(struct ath10k *ar)
 		dump_tlv = (struct ath10k_tlv_dump_data *)(buf + sofar);
 		dump_tlv->type = cpu_to_le32(ATH10K_FW_CRASH_DUMP_RAM_DATA);
 		dump_tlv->tlv_len = cpu_to_le32(crash_data->ramdump_buf_len);
-		memcpy(dump_tlv->tlv_data, crash_data->ramdump_buf,
-		       crash_data->ramdump_buf_len);
-		sofar += sizeof(*dump_tlv) + crash_data->ramdump_buf_len;
+		if (crash_data->ramdump_buf_len) {
+			memcpy(dump_tlv->tlv_data, crash_data->ramdump_buf,
+			       crash_data->ramdump_buf_len);
+			sofar += sizeof(*dump_tlv) + crash_data->ramdump_buf_len;
+		}
 	}
 
 	mutex_unlock(&ar->dump_mutex);
@@ -1257,6 +1259,9 @@ int ath10k_coredump_register(struct ath10k *ar)
 	if (test_bit(ATH10K_FW_CRASH_DUMP_RAM_DATA, &ath10k_coredump_mask)) {
 		crash_data->ramdump_buf_len = ath10k_coredump_get_ramdump_size(ar);
 
+		if (!crash_data->ramdump_buf_len)
+			return 0;
+
 		crash_data->ramdump_buf = vzalloc(crash_data->ramdump_buf_len);
 		if (!crash_data->ramdump_buf)
 			return -ENOMEM;
-- 
1.7.9.5

