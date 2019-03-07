Return-Path: <SRS0=M0/e=RK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B4D2C43381
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:24:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDADB20675
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Mar 2019 10:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbfCGKYK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Mar 2019 05:24:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55624 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbfCGKYK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Mar 2019 05:24:10 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 113C081DFF;
        Thu,  7 Mar 2019 10:24:10 +0000 (UTC)
Received: from localhost (unknown [10.43.2.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7C89E60E3D;
        Thu,  7 Mar 2019 10:24:09 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Jakub Kicinski <kubakici@wp.pl>,
        Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] mt7601u: check chip version on probe
Date:   Thu,  7 Mar 2019 11:24:06 +0100
Message-Id: <1551954246-18859-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 07 Mar 2019 10:24:10 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since some USB device IDs are duplicated between mt7601u and mt76x0u
devices, check chip version on probe and return error if not match
0x7601.

Don't think this is serious issue, probe most likely will fail at
some other point for wrong device, but we do not have to configure
it if we know is not mt7601u device.

Reported-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt7601u/usb.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index d8b7863f7926..be3c794612b2 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -303,6 +303,10 @@ static int mt7601u_probe(struct usb_interface *usb_intf,
 	mac_rev = mt7601u_rr(dev, MT_MAC_CSR0);
 	dev_info(dev->dev, "ASIC revision: %08x MAC revision: %08x\n",
 		 asic_rev, mac_rev);
+	if ((asic_rev >> 16) != 0x7601) {
+		ret = -EINVAL;
+		goto err;
+	}
 
 	/* Note: vendor driver skips this check for MT7601U */
 	if (!(mt7601u_rr(dev, MT_EFUSE_CTRL) & MT_EFUSE_CTRL_SEL))
-- 
1.9.3

