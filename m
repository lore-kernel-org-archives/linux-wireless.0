Return-Path: <SRS0=Li3M=OI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B608AC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 70E2721019
	for <linux-wireless@archiver.kernel.org>; Thu, 29 Nov 2018 15:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QymXH3lE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mul79NHO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 70E2721019
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728776AbeK3CjO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 21:39:14 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:49220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbeK3CjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 21:39:14 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B0C1C606DC; Thu, 29 Nov 2018 15:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505608;
        bh=vI3CRDq9fQFG3zn1ZuN+7eSrOpHD3gIy79+DkJYMbhQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=QymXH3lEtBEhKzYPUyakiqaAaRpo+VuFMmcccTAIphmrey74K0fx/VdXjb53CXd6V
         MOcPQJldr8DhpuIuPhmaQ2Jql0LV0OGSVUThwoRziI12scij8K5PCVlz4t5Bxm7nlm
         REi3+eBEYrKb0GS0Kh3Ge99fSFYY47yxDOyBxPY8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 72AAE60392;
        Thu, 29 Nov 2018 15:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543505608;
        bh=vI3CRDq9fQFG3zn1ZuN+7eSrOpHD3gIy79+DkJYMbhQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=mul79NHOSdt270pUr7bgoF3wBFsoB0rLpuRFZ7rMHSdXuuISHsfJZMcirvhYvVWuw
         L/Ok7d+pgGud26ijq4iCdfea8FI4vxxjEjf6CFA0gRHDN/fod9BF7S9T6j9UgVuVwh
         /uHAwc3MEmgYe2isMgSO2GdEgZ+n8MhoM9mX81KE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 72AAE60392
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] brcmfmac: Fix out of bounds memory access during fw load
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181124225707.12262-1-lyude@redhat.com>
References: <20181124225707.12262-1-lyude@redhat.com>
To:     Lyude Paul <lyude@redhat.com>
Cc:     brcm80211-dev-list@cypress.com,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Himanshu Jha <himanshujha199640@gmail.com>,
        Dan Haab <dhaab@luxul.com>,
        Jia-Shyr Chuang <saint.chuang@cypress.com>,
        Ian Molton <ian@mnementh.co.uk>, stable@vger.kernel.org,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181129153328.B0C1C606DC@smtp.codeaurora.org>
Date:   Thu, 29 Nov 2018 15:33:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lyude Paul <lyude@redhat.com> wrote:

> I ended up tracking down some rather nasty issues with f2fs (and other
> filesystem modules) constantly crashing on my kernel down to a
> combination of out of bounds memory accesses, one of which was coming
> from brcmfmac during module load:
> 
> [   30.891382] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
> [   30.894437] ==================================================================
> [   30.901581] BUG: KASAN: global-out-of-bounds in brcmf_fw_alloc_request+0x42c/0x480 [brcmfmac]
> [   30.909935] Read of size 1 at addr ffff2000024865df by task kworker/6:2/387
> [   30.916805]
> [   30.918261] CPU: 6 PID: 387 Comm: kworker/6:2 Tainted: G           O      4.20.0-rc3Lyude-Test+ #19
> [   30.927251] Hardware name: amlogic khadas-vim2/khadas-vim2, BIOS 2018.07-rc2-armbian 09/11/2018
> [   30.935964] Workqueue: events brcmf_driver_register [brcmfmac]
> [   30.941641] Call trace:
> [   30.944058]  dump_backtrace+0x0/0x3e8
> [   30.947676]  show_stack+0x14/0x20
> [   30.950968]  dump_stack+0x130/0x1c4
> [   30.954406]  print_address_description+0x60/0x25c
> [   30.959066]  kasan_report+0x1b4/0x368
> [   30.962683]  __asan_report_load1_noabort+0x18/0x20
> [   30.967547]  brcmf_fw_alloc_request+0x42c/0x480 [brcmfmac]
> [   30.967639]  brcmf_sdio_probe+0x163c/0x2050 [brcmfmac]
> [   30.978035]  brcmf_ops_sdio_probe+0x598/0xa08 [brcmfmac]
> [   30.983254]  sdio_bus_probe+0x190/0x398
> [   30.983270]  really_probe+0x2a0/0xa70
> [   30.983296]  driver_probe_device+0x1b4/0x2d8
> [   30.994901]  __driver_attach+0x200/0x280
> [   30.994914]  bus_for_each_dev+0x10c/0x1a8
> [   30.994925]  driver_attach+0x38/0x50
> [   30.994935]  bus_add_driver+0x330/0x608
> [   30.994953]  driver_register+0x140/0x388
> [   31.013965]  sdio_register_driver+0x74/0xa0
> [   31.014076]  brcmf_sdio_register+0x14/0x60 [brcmfmac]
> [   31.023177]  brcmf_driver_register+0xc/0x18 [brcmfmac]
> [   31.023209]  process_one_work+0x654/0x1080
> [   31.032266]  worker_thread+0x4f0/0x1308
> [   31.032286]  kthread+0x2a8/0x320
> [   31.039254]  ret_from_fork+0x10/0x1c
> [   31.039269]
> [   31.044226] The buggy address belongs to the variable:
> [   31.044351]  brcmf_firmware_path+0x11f/0xfffffffffffd3b40 [brcmfmac]
> [   31.055601]
> [   31.057031] Memory state around the buggy address:
> [   31.061800]  ffff200002486480: 04 fa fa fa fa fa fa fa 00 00 00 00 00 00 00 00
> [   31.068983]  ffff200002486500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   31.068993] >ffff200002486580: 00 00 00 00 00 00 00 00 fa fa fa fa 00 00 00 00
> [   31.068999]                                                     ^
> [   31.069017]  ffff200002486600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> [   31.096521]  ffff200002486680: 00 00 00 00 00 00 00 00 00 00 00 00 fa fa fa fa
> [   31.096528] ==================================================================
> [   31.096533] Disabling lock debugging due to kernel taint
> 
> It appears that when trying to determine the length of the string in the
> alternate firmware path, we make the mistake of not handling the case
> where the firmware path is empty correctly. Since strlen(mp_path) can
> return 0, we'll end up accessing mp_path[-1] when the firmware_path
> isn't provided through the module arguments.
> 
> So, fix this by just setting the end char to '\0' by default, and only
> changing it if we have a non-zero length. Additionally, use strnlen()
> with BRCMF_FW_ALTPATH_LEN instead of strlen() just to be extra safe.
> 
> Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() function")
> Cc: Hante Meuleman <hante.meuleman@broadcom.com>
> Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
> Cc: Franky Lin <franky.lin@broadcom.com>
> Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
> Cc: Himanshu Jha <himanshujha199640@gmail.com>
> Cc: Dan Haab <dhaab@luxul.com>
> Cc: Jia-Shyr Chuang <saint.chuang@cypress.com>
> Cc: Ian Molton <ian@mnementh.co.uk>
> Cc: <stable@vger.kernel.org> # v4.17+
> Signed-off-by: Lyude Paul <lyude@redhat.com>

Patch applied to wireless-drivers-next.git, thanks.

b72c51a58e6d brcmfmac: Fix out of bounds memory access during fw load

-- 
https://patchwork.kernel.org/patch/10696609/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

