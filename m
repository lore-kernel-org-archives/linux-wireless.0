Return-Path: <SRS0=fcMp=QR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C73A6C282C2
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 09:41:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E23320863
	for <linux-wireless@archiver.kernel.org>; Sun, 10 Feb 2019 09:41:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726157AbfBJJla (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 10 Feb 2019 04:41:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41618 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbfBJJla (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 10 Feb 2019 04:41:30 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2E4878667B;
        Sun, 10 Feb 2019 09:41:30 +0000 (UTC)
Received: from localhost (ovpn-204-24.brq.redhat.com [10.40.204.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A5C22D18A;
        Sun, 10 Feb 2019 09:41:25 +0000 (UTC)
Date:   Sun, 10 Feb 2019 10:41:24 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
Message-ID: <20190210094123.GB2913@redhat.com>
References: <2003727085.234456.1549714119945@email.ionos.de>
 <CAJ0CqmXSuNQ_tQOatyKwO9O2KsxqD5NZRQnngOme5PURssiv5Q@mail.gmail.com>
 <165515185.283024.1549744145982@email.ionos.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <165515185.283024.1549744145982@email.ionos.de>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Sun, 10 Feb 2019 09:41:30 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 09, 2019 at 09:29:05PM +0100, Stefan Wahren wrote:
> > could you please test the following series:
> > https://patchwork.kernel.org/cover/10764453/
> 
> yeah this fixed the probing timeout and the driver will probe successful. AFAIK the dwc2 host mode doesn't support scatter-gather yet.

So this is either dwc2 scatter-gather problem which should be addressed in
this driver or mt76x0u does something wrong when configuring SG.

Disabling SG is just workaround, which do not address actual problem.

I think I found mt76x0u issue that could cause this USB probe error
(and possibly also address AMD IOMMU issue). We seems do not correctly
set URB transfer length smaller than sg buffer length. Attached  patch
should correct that.

Stanislaw

--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="0001-mt76x02-usb-mcu-limit-sg-length.patch"

From bc09bc7fa604019a5ef90184390e7c2a3899869d Mon Sep 17 00:00:00 2001
From: Stanislaw Gruszka <sgruszka@redhat.com>
Date: Sun, 10 Feb 2019 08:09:48 +0100
Subject: [PATCH] mt76x02: usb_mcu: limit sg length

When sending fw data we limting urb transfer length by changing buf->len,
while keeping segment length at max_payload value. That may confuse
underlying drivers responsible for DMA.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
index da299b8a1334..cfa14506eca6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_usb_mcu.c
@@ -287,6 +287,7 @@ __mt76x02u_mcu_fw_send_data(struct mt76x02_dev *dev, struct mt76u_buf *buf,
 			MT_FCE_DMA_LEN, len << 16);
 
 	buf->len = MT_CMD_HDR_LEN + len + sizeof(info);
+	buf->urb->sg[0].length = buf->len;
 	err = mt76u_submit_buf(&dev->mt76, USB_DIR_OUT,
 			       MT_EP_OUT_INBAND_CMD,
 			       buf, GFP_KERNEL,
-- 
2.19.2


--bp/iNruPH9dso1Pn--
