Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EC6CECDE43
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D90A2147D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 20:13:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4D90A2147D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbeJGDRd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 23:17:33 -0400
Received: from shell.v3.sk ([90.176.6.54]:35982 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbeJGDRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 23:17:32 -0400
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 53111BA209;
        Sat,  6 Oct 2018 22:12:51 +0200 (CEST)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 1Xs29S_Ml8F1; Sat,  6 Oct 2018 22:12:46 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 3451FBA21A;
        Sat,  6 Oct 2018 22:12:46 +0200 (CEST)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4_JCNAzmniX6; Sat,  6 Oct 2018 22:12:37 +0200 (CEST)
Received: from belphegor.lan (ip-89-102-31-34.net.upcbroadband.cz [89.102.31.34])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 9614CBAA64;
        Sat,  6 Oct 2018 22:12:37 +0200 (CEST)
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lubomir Rintel <lkundrak@v3.sk>, stable@vger.kernel.org
Subject: [PATCH] libertas: don't set URB_ZERO_PACKET on IN USB transfer
Date:   Sat,  6 Oct 2018 22:12:32 +0200
Message-Id: <20181006201232.2789936-1-lkundrak@v3.sk>
X-Mailer: git-send-email 2.19.0
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The USB core gets rightfully upset:

  usb 1-1: BOGUS urb flags, 240 --> 200
  WARNING: CPU: 0 PID: 60 at drivers/usb/core/urb.c:503 usb_submit_urb+0x=
2f8/0x3ed
  Modules linked in:
  CPU: 0 PID: 60 Comm: kworker/0:3 Not tainted 4.19.0-rc6-00319-g5206d00a=
45c7 #39
  Hardware name: OLPC XO/XO, BIOS OLPC Ver 1.00.01 06/11/2014
  Workqueue: events request_firmware_work_func
  EIP: usb_submit_urb+0x2f8/0x3ed
  Code: 75 06 8b 8f 80 00 00 00 8d 47 78 89 4d e4 89 55 e8 e8 35 1c f6 ff=
 8b 55 e8 56 52 8b 4d e4 51 50 68 e3 ce c7 c0 e8 ed 18 c6 ff <0f> 0b 83 c=
4 14 80 7d ef 01 74 0a 80 7d ef 03 0f 85 b8 00 00 00 8b
  EAX: 00000025 EBX: ce7d4980 ECX: 00000000 EDX: 00000001
  ESI: 00000200 EDI: ce7d8800 EBP: ce7f5ea8 ESP: ce7f5e70
  DS: 007b ES: 007b FS: 0000 GS: 00e0 SS: 0068 EFLAGS: 00210292
  CR0: 80050033 CR2: 00000000 CR3: 00e80000 CR4: 00000090
  Call Trace:
   ? if_usb_fw_timeo+0x64/0x64
   __if_usb_submit_rx_urb+0x85/0xe6
   ? if_usb_fw_timeo+0x64/0x64
   if_usb_submit_rx_urb_fwload+0xd/0xf
   if_usb_prog_firmware+0xc0/0x3db
   ? _request_firmware+0x54/0x47b
   ? _request_firmware+0x89/0x47b
   ? if_usb_probe+0x412/0x412
   lbs_fw_loaded+0x55/0xa6
   ? debug_smp_processor_id+0x12/0x14
   helper_firmware_cb+0x3c/0x3f
   request_firmware_work_func+0x37/0x6f
   process_one_work+0x164/0x25a
   worker_thread+0x1c4/0x284
   kthread+0xec/0xf1
   ? cancel_delayed_work_sync+0xf/0xf
   ? kthread_create_on_node+0x1a/0x1a
   ret_from_fork+0x2e/0x38
  ---[ end trace 3ef1e3b2dd53852f ]---

Cc: stable@vger.kernel.org
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/net/wireless/marvell/libertas/if_usb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net=
/wireless/marvell/libertas/if_usb.c
index 5fee555a3d60..220dcdee8d2b 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -459,8 +459,6 @@ static int __if_usb_submit_rx_urb(struct if_usb_card =
*cardp,
 			  MRVDRV_ETH_RX_PACKET_BUFFER_SIZE, callbackfn,
 			  cardp);
=20
-	cardp->rx_urb->transfer_flags |=3D URB_ZERO_PACKET;
-
 	lbs_deb_usb2(&cardp->udev->dev, "Pointer for rx_urb %p\n", cardp->rx_ur=
b);
 	if ((ret =3D usb_submit_urb(cardp->rx_urb, GFP_ATOMIC))) {
 		lbs_deb_usbd(&cardp->udev->dev, "Submit Rx URB failed: %d\n", ret);
--=20
2.19.0

