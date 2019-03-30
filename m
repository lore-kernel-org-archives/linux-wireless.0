Return-Path: <SRS0=EA+v=SB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF97EC10F05
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 01:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AF992217F5
	for <linux-wireless@archiver.kernel.org>; Sat, 30 Mar 2019 01:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1553910087;
	bh=7Hqa+hd3SjcWJChOGFb42MMRW0TR0vlPtBDXq6GjTGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=RZ8XMyBwUzpDmt9TU6peqrz1yDYpox5zABNvSmxeGYHK7XNXGcP/kOtWG7zsLr7wi
	 QYBjzJ6/c2PQ028N/sAhahQUBY0LExUK3BmQUwluHvZzYyWmO9phSPjVjU2zCN1rLO
	 SPjS4vdmVIYkHjmmDKYOIW2q88uJ4ldyptWwSKKY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731107AbfC3BlV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 29 Mar 2019 21:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730664AbfC3B27 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Mar 2019 21:28:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BCC5218A6;
        Sat, 30 Mar 2019 01:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553909338;
        bh=7Hqa+hd3SjcWJChOGFb42MMRW0TR0vlPtBDXq6GjTGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeoMkCkkrhlbCA7CUSP/Tkg2U9ZpFRABR1HhkD83IQeKnKz+kBrT4OihjN3At6v0r
         WgxNpkIbdKfFMgCs5CD4ZE0o8xxLHs8vaCoxQWZ/yvXVGCFUpdj/Wsy1/34JkSEg+v
         izLE5m/jA/ErUFnW1TLFRVnS9hELE0V7kETKWBW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 03/57] rsi: improve kernel thread handling to fix kernel panic
Date:   Fri, 29 Mar 2019 21:27:56 -0400
Message-Id: <20190330012854.32212-3-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190330012854.32212-1-sashal@kernel.org>
References: <20190330012854.32212-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

[ Upstream commit 4c62764d0fc21a34ffc44eec1210038c3a2e4473 ]

While running regressions, observed below kernel panic when sdio disconnect
called. This is because of, kthread_stop() is taking care of
wait_for_completion() by default. When wait_for_completion triggered
in kthread_stop and as it was done already, giving kernel panic.
Hence, removing redundant wait_for_completion() from rsi_kill_thread().

... skipping ...
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff810a63df>] exit_creds+0x1f/0x50
PGD 0
Oops: 0002 [#1] SMP
CPU: 0 PID: 6502 Comm: rmmod Tainted: G  OE   4.15.9-Generic #154-Ubuntu
Hardware name: Dell Inc. Edge Gateway 3003/ , BIOS 01.00.00 04/17/2017
Stack:
ffff88007392e600 ffff880075847dc0 ffffffff8108160a 0000000000000000
ffff88007392e600 ffff880075847de8 ffffffff810a484b ffff880076127000
ffff88003cd3a800 ffff880074f12a00 ffff880075847e28 ffffffffc09bed15
Call Trace:
[<ffffffff8108160a>] __put_task_struct+0x5a/0x140
[<ffffffff810a484b>] kthread_stop+0x10b/0x110
[<ffffffffc09bed15>] rsi_disconnect+0x2f5/0x300 [ven_rsi_sdio]
[<ffffffff81578bcb>] ? __pm_runtime_resume+0x5b/0x80
[<ffffffff816f0918>] sdio_bus_remove+0x38/0x100
[<ffffffff8156cc64>] __device_release_driver+0xa4/0x150
[<ffffffff8156d7a5>] driver_detach+0xb5/0xc0
[<ffffffff8156c6c5>] bus_remove_driver+0x55/0xd0
[<ffffffff8156dfbc>] driver_unregister+0x2c/0x50
[<ffffffff816f0b8a>] sdio_unregister_driver+0x1a/0x20
[<ffffffffc09bf0f5>] rsi_module_exit+0x15/0x30 [ven_rsi_sdio]
[<ffffffff8110cad8>] SyS_delete_module+0x1b8/0x210
[<ffffffff81851dc8>] entry_SYSCALL_64_fastpath+0x1c/0xbb

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/rsi/rsi_common.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index d9ff3b8be86e..60f1f286b030 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -75,7 +75,6 @@ static inline int rsi_kill_thread(struct rsi_thread *handle)
 	atomic_inc(&handle->thread_done);
 	rsi_set_event(&handle->event);
 
-	wait_for_completion(&handle->completion);
 	return kthread_stop(handle->task);
 }
 
-- 
2.19.1

