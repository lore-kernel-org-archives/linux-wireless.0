Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47303C04EBB
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 22:57:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 181C320892
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 22:57:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 181C320892
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726570AbeKYJrA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 25 Nov 2018 04:47:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35002 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726433AbeKYJq7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Nov 2018 04:46:59 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CD1F4C05000A;
        Sat, 24 Nov 2018 22:57:26 +0000 (UTC)
Received: from whitewolf.lyude.net.com (ovpn-120-179.rdu2.redhat.com [10.10.120.179])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0F619A395B;
        Sat, 24 Nov 2018 22:57:21 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     brcm80211-dev-list@cypress.com
Cc:     Hante Meuleman <hante.meuleman@broadcom.com>,
        Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
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
Subject: [PATCH] brcmfmac: Fix out of bounds memory access during fw load
Date:   Sat, 24 Nov 2018 17:57:05 -0500
Message-Id: <20181124225707.12262-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Sat, 24 Nov 2018 22:57:27 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I ended up tracking down some rather nasty issues with f2fs (and other
filesystem modules) constantly crashing on my kernel down to a
combination of out of bounds memory accesses, one of which was coming
from brcmfmac during module load:

[   30.891382] brcmfmac: brcmf_fw_alloc_request: using brcm/brcmfmac4356-sdio for chip BCM4356/2
[   30.894437] ==================================================================
[   30.901581] BUG: KASAN: global-out-of-bounds in brcmf_fw_alloc_request+0x42c/0x480 [brcmfmac]
[   30.909935] Read of size 1 at addr ffff2000024865df by task kworker/6:2/387
[   30.916805]
[   30.918261] CPU: 6 PID: 387 Comm: kworker/6:2 Tainted: G           O      4.20.0-rc3Lyude-Test+ #19
[   30.927251] Hardware name: amlogic khadas-vim2/khadas-vim2, BIOS 2018.07-rc2-armbian 09/11/2018
[   30.935964] Workqueue: events brcmf_driver_register [brcmfmac]
[   30.941641] Call trace:
[   30.944058]  dump_backtrace+0x0/0x3e8
[   30.947676]  show_stack+0x14/0x20
[   30.950968]  dump_stack+0x130/0x1c4
[   30.954406]  print_address_description+0x60/0x25c
[   30.959066]  kasan_report+0x1b4/0x368
[   30.962683]  __asan_report_load1_noabort+0x18/0x20
[   30.967547]  brcmf_fw_alloc_request+0x42c/0x480 [brcmfmac]
[   30.967639]  brcmf_sdio_probe+0x163c/0x2050 [brcmfmac]
[   30.978035]  brcmf_ops_sdio_probe+0x598/0xa08 [brcmfmac]
[   30.983254]  sdio_bus_probe+0x190/0x398
[   30.983270]  really_probe+0x2a0/0xa70
[   30.983296]  driver_probe_device+0x1b4/0x2d8
[   30.994901]  __driver_attach+0x200/0x280
[   30.994914]  bus_for_each_dev+0x10c/0x1a8
[   30.994925]  driver_attach+0x38/0x50
[   30.994935]  bus_add_driver+0x330/0x608
[   30.994953]  driver_register+0x140/0x388
[   31.013965]  sdio_register_driver+0x74/0xa0
[   31.014076]  brcmf_sdio_register+0x14/0x60 [brcmfmac]
[   31.023177]  brcmf_driver_register+0xc/0x18 [brcmfmac]
[   31.023209]  process_one_work+0x654/0x1080
[   31.032266]  worker_thread+0x4f0/0x1308
[   31.032286]  kthread+0x2a8/0x320
[   31.039254]  ret_from_fork+0x10/0x1c
[   31.039269]
[   31.044226] The buggy address belongs to the variable:
[   31.044351]  brcmf_firmware_path+0x11f/0xfffffffffffd3b40 [brcmfmac]
[   31.055601]
[   31.057031] Memory state around the buggy address:
[   31.061800]  ffff200002486480: 04 fa fa fa fa fa fa fa 00 00 00 00 00 00 00 00
[   31.068983]  ffff200002486500: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   31.068993] >ffff200002486580: 00 00 00 00 00 00 00 00 fa fa fa fa 00 00 00 00
[   31.068999]                                                     ^
[   31.069017]  ffff200002486600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
[   31.096521]  ffff200002486680: 00 00 00 00 00 00 00 00 00 00 00 00 fa fa fa fa
[   31.096528] ==================================================================
[   31.096533] Disabling lock debugging due to kernel taint

It appears that when trying to determine the length of the string in the
alternate firmware path, we make the mistake of not handling the case
where the firmware path is empty correctly. Since strlen(mp_path) can
return 0, we'll end up accessing mp_path[-1] when the firmware_path
isn't provided through the module arguments.

So, fix this by just setting the end char to '\0' by default, and only
changing it if we have a non-zero length. Additionally, use strnlen()
with BRCMF_FW_ALTPATH_LEN instead of strlen() just to be extra safe.

Signed-off-by: Lyude Paul <lyude@redhat.com>

Fixes: 2baa3aaee27f ("brcmfmac: introduce brcmf_fw_alloc_request() function")
Cc: Hante Meuleman <hante.meuleman@broadcom.com>
Cc: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Cc: Franky Lin <franky.lin@broadcom.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Himanshu Jha <himanshujha199640@gmail.com>
Cc: Dan Haab <dhaab@luxul.com>
Cc: Jia-Shyr Chuang <saint.chuang@cypress.com>
Cc: Ian Molton <ian@mnementh.co.uk>
Cc: <stable@vger.kernel.org> # v4.17+
Signed-off-by: Lyude Paul <lyude@redhat.com>
---
 .../net/wireless/broadcom/brcm80211/brcmfmac/firmware.c   | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
index 9095b830ae4d..9927079a9ace 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -641,8 +641,9 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 	struct brcmf_fw_request *fwreq;
 	char chipname[12];
 	const char *mp_path;
+	size_t mp_path_len;
 	u32 i, j;
-	char end;
+	char end = '\0';
 	size_t reqsz;
 
 	for (i = 0; i < table_size; i++) {
@@ -667,7 +668,10 @@ brcmf_fw_alloc_request(u32 chip, u32 chiprev,
 		   mapping_table[i].fw_base, chipname);
 
 	mp_path = brcmf_mp_global.firmware_path;
-	end = mp_path[strlen(mp_path) - 1];
+	mp_path_len = strnlen(mp_path, BRCMF_FW_ALTPATH_LEN);
+	if (mp_path_len)
+		end = mp_path[mp_path_len - 1];
+
 	fwreq->n_items = n_fwnames;
 
 	for (j = 0; j < n_fwnames; j++) {
-- 
2.19.1

