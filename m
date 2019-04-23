Return-Path: <SRS0=odSX=SZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E5FC10F14
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:37:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEBA2214AE
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Apr 2019 10:37:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfDWKhQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 23 Apr 2019 06:37:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41561 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbfDWKhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Apr 2019 06:37:16 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1C07308219E;
        Tue, 23 Apr 2019 10:37:16 +0000 (UTC)
Received: from localhost (ovpn-204-59.brq.redhat.com [10.40.204.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3A75F1A925;
        Tue, 23 Apr 2019 10:37:14 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 1/3] mt76x02u: remove bogus stop on suspend
Date:   Tue, 23 Apr 2019 12:37:07 +0200
Message-Id: <20190423103709.7272-2-sgruszka@redhat.com>
In-Reply-To: <20190423103709.7272-1-sgruszka@redhat.com>
References: <20190423103709.7272-1-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Tue, 23 Apr 2019 10:37:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On suspend mac80211 .stop callback is called before .suspend(), so
hw mac is already stopped and we do not have to do this again.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c | 1 -
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 1ef00e971cfa..3276382b2180 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -314,7 +314,6 @@ static int __maybe_unused mt76x0_suspend(struct usb_interface *usb_intf,
 	struct mt76x02_dev *dev = usb_get_intfdata(usb_intf);
 
 	mt76u_stop_queues(&dev->mt76);
-	mt76x0u_mac_stop(dev);
 	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mt76.state);
 	mt76x0_chip_onoff(dev, false, false);
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index d08bb964966b..af90774cae32 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -108,7 +108,6 @@ static int __maybe_unused mt76x2u_suspend(struct usb_interface *intf,
 	struct mt76x02_dev *dev = usb_get_intfdata(intf);
 
 	mt76u_stop_queues(&dev->mt76);
-	mt76x2u_stop_hw(dev);
 
 	return 0;
 }
-- 
2.20.1

