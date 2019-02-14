Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADC33C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E0D3222B6
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 12:44:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UdfyLQY7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394386AbfBNMoO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 07:44:14 -0500
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:48270 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2393476AbfBNMoN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 07:44:13 -0500
Received: from mail-irv-17.broadcom.com (mail-irv-17.lvn.broadcom.net [10.75.224.233])
        by rnd-relay.smtp.broadcom.com (Postfix) with ESMTP id 2679C94A20;
        Thu, 14 Feb 2019 04:44:12 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.10.3 rnd-relay.smtp.broadcom.com 2679C94A20
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1550148252;
        bh=9j67uU8/0h2WLq0KCgC9/0n5Y5iNkwFlWTsLIsr2Lp4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UdfyLQY7NYU/WYwsemhBwi4NR0j5vQDqNPMH4CMEFDGhJMbXaUVL4JEc1tOAWGiRm
         7eD15n/rkulqqHAAs0CIrB6R+QQUFNWbW7uHotCLL2I91YXy4mHbzWovnxWEQhBrVt
         3v++BFaW9KauGREkdbnyK6dF2kSYFYJLml2KT4d0=
Received: from bld-bun-01.bun.broadcom.com (bld-bun-01.bun.broadcom.com [10.176.128.83])
        by mail-irv-17.broadcom.com (Postfix) with ESMTP id 762BF81EC6;
        Thu, 14 Feb 2019 04:44:12 -0800 (PST)
Received: by bld-bun-01.bun.broadcom.com (Postfix, from userid 25152)
        id 35FE0B02A75; Thu, 14 Feb 2019 13:44:08 +0100 (CET)
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 5/6] brcmfmac: check and dump trap info during sdio probe
Date:   Thu, 14 Feb 2019 13:43:51 +0100
Message-Id: <1550148232-4309-6-git-send-email-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1550148232-4309-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When the firmware crashes during the probe sequence we provide little
information on what really failed. This patch checks the sdpcm shared
location and show the trap information if a firmware trap has happened.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 59 +++++++++++++++-------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 5f9de61..4d104ab 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -2999,21 +2999,35 @@ static int brcmf_sdio_trap_info(struct seq_file *seq, struct brcmf_sdio *bus,
 	if (error < 0)
 		return error;
 
-	seq_printf(seq,
-		   "dongle trap info: type 0x%x @ epc 0x%08x\n"
-		   "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
-		   "  lr   0x%08x pc   0x%08x offset 0x%x\n"
-		   "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
-		   "  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
-		   le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
-		   le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
-		   le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
-		   le32_to_cpu(tr.pc), sh->trap_addr,
-		   le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
-		   le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
-		   le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
-		   le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
-
+	if (seq)
+		seq_printf(seq,
+			   "dongle trap info: type 0x%x @ epc 0x%08x\n"
+			   "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
+			   "  lr   0x%08x pc   0x%08x offset 0x%x\n"
+			   "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
+			   "  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
+			   le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
+			   le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
+			   le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
+			   le32_to_cpu(tr.pc), sh->trap_addr,
+			   le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
+			   le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
+			   le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
+			   le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
+	else
+		pr_debug("dongle trap info: type 0x%x @ epc 0x%08x\n"
+			 "  cpsr 0x%08x spsr 0x%08x sp 0x%08x\n"
+			 "  lr   0x%08x pc   0x%08x offset 0x%x\n"
+			 "  r0   0x%08x r1   0x%08x r2 0x%08x r3 0x%08x\n"
+			 "  r4   0x%08x r5   0x%08x r6 0x%08x r7 0x%08x\n",
+			 le32_to_cpu(tr.type), le32_to_cpu(tr.epc),
+			 le32_to_cpu(tr.cpsr), le32_to_cpu(tr.spsr),
+			 le32_to_cpu(tr.r13), le32_to_cpu(tr.r14),
+			 le32_to_cpu(tr.pc), sh->trap_addr,
+			 le32_to_cpu(tr.r0), le32_to_cpu(tr.r1),
+			 le32_to_cpu(tr.r2), le32_to_cpu(tr.r3),
+			 le32_to_cpu(tr.r4), le32_to_cpu(tr.r5),
+			 le32_to_cpu(tr.r6), le32_to_cpu(tr.r7));
 	return 0;
 }
 
@@ -3067,8 +3081,10 @@ static int brcmf_sdio_checkdied(struct brcmf_sdio *bus)
 	else if (sh.flags & SDPCM_SHARED_ASSERT)
 		brcmf_err("assertion in dongle\n");
 
-	if (sh.flags & SDPCM_SHARED_TRAP)
+	if (sh.flags & SDPCM_SHARED_TRAP) {
 		brcmf_err("firmware trap in dongle\n");
+		brcmf_sdio_trap_info(NULL, bus, &sh);
+	}
 
 	return 0;
 }
@@ -4199,7 +4215,7 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	} else {
 		/* Disable F2 again */
 		sdio_disable_func(sdiod->func2);
-		goto release;
+		goto checkdied;
 	}
 
 	if (brcmf_chip_sr_capable(bus->ci)) {
@@ -4220,8 +4236,10 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	}
 
 	/* If we didn't come up, turn off backplane clock */
-	if (err != 0)
+	if (err != 0) {
 		brcmf_sdio_clkctl(bus, CLK_NONE, false);
+		goto checkdied;
+	}
 
 	sdio_release_host(sdiod->func1);
 
@@ -4235,12 +4253,15 @@ static void brcmf_sdio_firmware_callback(struct device *dev, int err,
 	err = brcmf_attach(sdiod->dev, sdiod->settings);
 	if (err != 0) {
 		brcmf_err("brcmf_attach failed\n");
-		goto fail;
+		sdio_claim_host(sdiod->func1);
+		goto checkdied;
 	}
 
 	/* ready */
 	return;
 
+checkdied:
+	brcmf_sdio_checkdied(bus);
 release:
 	sdio_release_host(sdiod->func1);
 fail:
-- 
1.9.1

