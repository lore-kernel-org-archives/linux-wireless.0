Return-Path: <SRS0=H9Fc=TO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7678C04AB4
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 21:14:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7874E20881
	for <linux-wireless@archiver.kernel.org>; Tue, 14 May 2019 21:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfENVOM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 May 2019 17:14:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53330 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726211AbfENVOL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 May 2019 17:14:11 -0400
Received: from cpc129250-craw9-2-0-cust139.know.cable.virginm.net ([82.43.126.140] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hQekQ-0003ZL-OY; Tue, 14 May 2019 21:14:06 +0000
From:   Colin King <colin.king@canonical.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] libertas/libertas_tf: fix spelling mistake "Donwloading" -> "Downloading"
Date:   Tue, 14 May 2019 22:14:06 +0100
Message-Id: <20190514211406.6353-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is are two spelling mistakes in lbtf_deb_usb2 messages, fix these.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/marvell/libertas/if_usb.c    | 2 +-
 drivers/net/wireless/marvell/libertas_tf/if_usb.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 220dcdee8d2b..1d06fa564e28 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -367,7 +367,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 			     cardp->fwseqnum, cardp->totalbytes);
 	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
 		lbs_deb_usb2(&cardp->udev->dev, "Host has finished FW downloading\n");
-		lbs_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
+		lbs_deb_usb2(&cardp->udev->dev, "Downloading FW JUMP BLOCK\n");
 
 		cardp->fwfinalblk = 1;
 	}
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index a4b9ede70705..38f77b1a02ca 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -319,7 +319,7 @@ static int if_usb_send_fw_pkt(struct if_usb_card *cardp)
 	} else if (fwdata->hdr.dnldcmd == cpu_to_le32(FW_HAS_LAST_BLOCK)) {
 		lbtf_deb_usb2(&cardp->udev->dev,
 			"Host has finished FW downloading\n");
-		lbtf_deb_usb2(&cardp->udev->dev, "Donwloading FW JUMP BLOCK\n");
+		lbtf_deb_usb2(&cardp->udev->dev, "Downloading FW JUMP BLOCK\n");
 
 		/* Host has finished FW downloading
 		 * Donwloading FW JUMP BLOCK
-- 
2.20.1

