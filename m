Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C681AC46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 17:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD8520665
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 17:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="RIJyuP+t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7FD8520665
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbeJZCbR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 22:31:17 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39030 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbeJZCbQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 22:31:16 -0400
Received: by mail-pg1-f194.google.com with SMTP id r9-v6so4356245pgv.6
        for <linux-wireless@vger.kernel.org>; Thu, 25 Oct 2018 10:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BfPqDKGw3o0KXK8SulRln3sQqjmzSCqI/iaJQG9ROBQ=;
        b=RIJyuP+tj6g+p4R8MLIQZDjLwRuXwA1PMtCy9NT3n4DxhrfZJSIh6QYXcYuhRbARSV
         XRDOyMZRKk8+zVRXZn7/WvtOlLCeL5gE/I/FOP4Hsfj8ZnGHnbV6ZGYXN9aclQUZeUb/
         Gkj182asMJJfL/JShP++JVXaL/FTKGok3Qh9E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BfPqDKGw3o0KXK8SulRln3sQqjmzSCqI/iaJQG9ROBQ=;
        b=UUzmFkxTCSKaVJGmBrgH3qfhEDCWNl1PisfENqlfbjxCUX65A85638blrT+pvn0B8X
         4HRudngAp0+BQ8jTjn7zFmzN4UZFbTcq5idumbL0XNPLPn2yTZiFraVJoYXAcj/VrEel
         CZsbpjZoyiPcDZvXj7uFtjjDLzGpDRI7/6HpSAjDSfedCc7ujCVOz/tKCtOz9ioTZz32
         YjRLaHi/rmlheBz4v1np51r3L6OaPRNcwFbSayr45fk4yh3I2oFZPBlk13ta/TDvhDFy
         KY4O/FivJFtIofB09dzTX/Lmlz4+QZ/LzA1aeRtDf1QU+kLN8ZCF4JsXnx0nryT9NjaT
         Ahgg==
X-Gm-Message-State: AGRZ1gIsLub+2j3aYAEf8jzNX/pgDrh0O3QCcyalzmuuHzCS4JOdJcV9
        akhZBfGNo6zaSwGwdW2+pFXQKA==
X-Google-Smtp-Source: AJdET5fTu9CtHiYyqEMgkudSPH+oYSTySimynSP5+IXhdQSA/U0o0+m6LTb2SPrfC/iHoCciTu/MvQ==
X-Received: by 2002:a63:4d5d:: with SMTP id n29-v6mr204008pgl.270.1540490247767;
        Thu, 25 Oct 2018 10:57:27 -0700 (PDT)
Received: from localhost.localdomain ([2601:1c2:680:1319:4e72:b9ff:fe99:466a])
        by smtp.gmail.com with ESMTPSA id e2-v6sm10239554pgv.25.2018.10.25.10.57.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 25 Oct 2018 10:57:26 -0700 (PDT)
From:   John Stultz <john.stultz@linaro.org>
To:     lkml <linux-kernel@vger.kernel.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>, Eyal Reizer <eyalr@ti.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-wireless@vger.kernel.org
Subject: [RFC][PATCH] wlcore: Fixup "Add support for optional wakeirq"
Date:   Thu, 25 Oct 2018 10:57:21 -0700
Message-Id: <1540490241-32021-1-git-send-email-john.stultz@linaro.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

After commit 3c83dd577c7f ("wlcore: Add support for optional
wakeirq") landed upstream, I started seeing the following oops
on my HiKey board:

[    1.870279] Unable to handle kernel read from unreadable memory at virtual address 0000000000000010
[    1.870283] Mem abort info:
[    1.870287]   ESR = 0x96000005
[    1.870292]   Exception class = DABT (current EL), IL = 32 bits
[    1.870296]   SET = 0, FnV = 0
[    1.870299]   EA = 0, S1PTW = 0
[    1.870302] Data abort info:
[    1.870306]   ISV = 0, ISS = 0x00000005
[    1.870309]   CM = 0, WnR = 0
[    1.870312] [0000000000000010] user address but active_mm is swapper
[    1.870318] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[    1.870327] CPU: 0 PID: 5 Comm: kworker/0:0 Not tainted 4.19.0-05129-gb3d1e8e #48
[    1.870331] Hardware name: HiKey Development Board (DT)
[    1.870350] Workqueue: events_freezable mmc_rescan
[    1.870358] pstate: 60400005 (nZCv daif +PAN -UAO)
[    1.870366] pc : wl1271_probe+0x210/0x350
[    1.870371] lr : wl1271_probe+0x210/0x350
[    1.870374] sp : ffffff80080739b0
[    1.870377] x29: ffffff80080739b0 x28: 0000000000000000
[    1.870384] x27: 0000000000000000 x26: 0000000000000000
[    1.870391] x25: 0000000000000036 x24: ffffffc074ecb598
[    1.870398] x23: ffffffc07ffdce78 x22: ffffffc0744ed808
[    1.870404] x21: ffffffc074ecbb98 x20: ffffff8008ff9000
[    1.870411] x19: ffffffc0744ed800 x18: ffffff8008ff9a48
[    1.870418] x17: 0000000000000000 x16: 0000000000000000
[    1.870425] x15: ffffffc074ecb503 x14: ffffffffffffffff
[    1.870431] x13: ffffffc074ecb502 x12: 0000000000000030
[    1.870438] x11: 0101010101010101 x10: 0000000000000040
[    1.870444] x9 : ffffffc075400248 x8 : ffffffc075400270
[    1.870451] x7 : 0000000000000000 x6 : 0000000000000000
[    1.870457] x5 : 0000000000000000 x4 : 0000000000000000
[    1.870463] x3 : 0000000000000000 x2 : 0000000000000000
[    1.870469] x1 : 0000000000000028 x0 : 0000000000000000
[    1.870477] Process kworker/0:0 (pid: 5, stack limit = 0x(____ptrval____))
[    1.870480] Call trace:
[    1.870485]  wl1271_probe+0x210/0x350
[    1.870491]  sdio_bus_probe+0x100/0x128
[    1.870500]  really_probe+0x1a8/0x2b8
[    1.870506]  driver_probe_device+0x58/0x100
[    1.870511]  __device_attach_driver+0x94/0xd8
[    1.870517]  bus_for_each_drv+0x70/0xc8
[    1.870522]  __device_attach+0xe0/0x140
[    1.870527]  device_initial_probe+0x10/0x18
[    1.870532]  bus_probe_device+0x94/0xa0
[    1.870537]  device_add+0x374/0x5b8
[    1.870542]  sdio_add_func+0x60/0x88
[    1.870546]  mmc_attach_sdio+0x1b0/0x358
[    1.870551]  mmc_rescan+0x2cc/0x390
[    1.870558]  process_one_work+0x12c/0x320
[    1.870563]  worker_thread+0x48/0x458
[    1.870569]  kthread+0xf8/0x128
[    1.870575]  ret_from_fork+0x10/0x18
[    1.870583] Code: 92400c21 b2760021 a90687a2 97e95bf9 (f9400803)
[    1.870587] ---[ end trace 1e15f81d3c139ca9 ]---

It seems since we don't have a wakeirq value in the dts, the wakeirq
value in wl1271_probe() is zero, which then causes trouble in
irqd_get_trigger_type(irq_get_irq_data(wakeirq)).

This patch tries to address this by checking if wakeirq is zero,
and not trying to add it to the resources if that is the case.

Cc: Tony Lindgren <tony@atomide.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>
Cc: Anders Roxell <anders.roxell@linaro.org>
Cc: linux-wireless@vger.kernel.org
Acked-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: John Stultz <john.stultz@linaro.org>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 4c2154b..bd10165 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -285,7 +285,7 @@ static int wl1271_probe(struct sdio_func *func,
 	struct resource res[2];
 	mmc_pm_flag_t mmcflags;
 	int ret = -ENOMEM;
-	int irq, wakeirq;
+	int irq, wakeirq, num_irqs;
 	const char *chip_family;
 
 	/* We are only able to handle the wlan function */
@@ -353,12 +353,17 @@ static int wl1271_probe(struct sdio_func *func,
 		       irqd_get_trigger_type(irq_get_irq_data(irq));
 	res[0].name = "irq";
 
-	res[1].start = wakeirq;
-	res[1].flags = IORESOURCE_IRQ |
-		       irqd_get_trigger_type(irq_get_irq_data(wakeirq));
-	res[1].name = "wakeirq";
 
-	ret = platform_device_add_resources(glue->core, res, ARRAY_SIZE(res));
+	if (wakeirq > 0) {
+		res[1].start = wakeirq;
+		res[1].flags = IORESOURCE_IRQ |
+			       irqd_get_trigger_type(irq_get_irq_data(wakeirq));
+		res[1].name = "wakeirq";
+		num_irqs = 2;
+	} else {
+		num_irqs = 1;
+	}
+	ret = platform_device_add_resources(glue->core, res, num_irqs);
 	if (ret) {
 		dev_err(glue->dev, "can't add resources\n");
 		goto out_dev_put;
-- 
2.7.4

