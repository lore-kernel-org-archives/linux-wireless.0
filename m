Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEFE8C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 36EAE214C5
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 06:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 36EAE214C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbeIYMz4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 08:55:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56850 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727114AbeIYMz4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 08:55:56 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 905C8308FB86;
        Tue, 25 Sep 2018 06:49:52 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 47C5B1077D48;
        Tue, 25 Sep 2018 06:49:50 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Sid Hayn <sidhayn@gmail.com>
Subject: [PATCH] mt76x0: add quirk to disable 2.4GHz band for Archer T1U
Date:   Tue, 25 Sep 2018 08:49:48 +0200
Message-Id: <1537858188-7815-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 25 Sep 2018 06:49:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

TP-LINK Archer T1U do not support 2.4GHz band despite EEPROM
reports that. Add quirk to mask out 2.4GHz support.

Reported-by: Sid Hayn <sidhayn@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c | 5 +++++
 drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h | 2 ++
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c    | 7 ++++++-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
index 18bd80adbb51..3d712f6d7078 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/eeprom.c
@@ -62,6 +62,11 @@ static void mt76x0_set_chip_cap(struct mt76x0_dev *dev)
 	dev_dbg(dev->mt76.dev, "2GHz %d 5GHz %d\n",
 		dev->mt76.cap.has_2ghz, dev->mt76.cap.has_5ghz);
 
+	if (dev->no_2ghz) {
+		dev->mt76.cap.has_2ghz = false;
+		dev_dbg(dev->mt76.dev, "mask out 2GHz support\n");
+	}
+
 	if (!mt76x02_field_valid(nic_conf1 & 0xff))
 		nic_conf1 &= 0xff00;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
index 7e131241344b..242abab69cdb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/mt76x0.h
@@ -108,6 +108,8 @@ struct mt76x0_dev {
 	u8 agc_save;
 	u16 chainmask;
 
+	bool no_2ghz;
+
 	struct mac_stats stats;
 };
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 76d607f73758..b7a1069ecd0e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -45,7 +45,8 @@
 	{ USB_DEVICE(0x20f4, 0x806b) },	/* TRENDnet TEW-806UBH  */
 	{ USB_DEVICE(0x7392, 0xc711) }, /* Devolo Wifi ac Stick */
 	{ USB_DEVICE(0x0df6, 0x0079) }, /* Sitecom Europe B.V. ac  Stick */
-	{ USB_DEVICE(0x2357, 0x0105) }, /* TP-LINK Archer T1U */
+	{ USB_DEVICE(0x2357, 0x0105),
+	  .driver_info = 1,	     }, /* TP-LINK Archer T1U */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0E8D, 0x7630, 0xff, 0x2, 0xff)}, /* MT7630U */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x0E8D, 0x7650, 0xff, 0x2, 0xff)}, /* MT7650U */
 	{ 0, }
@@ -222,6 +223,10 @@ static int mt76x0u_probe(struct usb_interface *usb_intf,
 	if (!dev)
 		return -ENOMEM;
 
+	/* Quirk for Archer T1U */
+	if (id->driver_info)
+		dev->no_2ghz = true;
+
 	usb_dev = usb_get_dev(usb_dev);
 	usb_reset_device(usb_dev);
 
-- 
1.9.3

