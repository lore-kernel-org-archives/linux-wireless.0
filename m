Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D00AC43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 285D621852
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 15:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731229AbeLTPQQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 10:16:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33888 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729011AbeLTPQQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 10:16:16 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EA197E9CF;
        Thu, 20 Dec 2018 15:16:15 +0000 (UTC)
Received: from localhost (ovpn-204-224.brq.redhat.com [10.40.204.224])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBCBF5D78E;
        Thu, 20 Dec 2018 15:16:14 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Randy Oostdyk <linux-kernel@oostdyk.com>,
        =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [PATCH v2 2/3] rt2x00: check number of EPROTO errors
Date:   Thu, 20 Dec 2018 16:16:10 +0100
Message-Id: <1545318971-28351-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Thu, 20 Dec 2018 15:16:15 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Some USB host devices/drivers on some conditions can always return
EPROTO error on submitted URBs. That can cause infinity loop in the
rt2x00 driver.

Since we can have single EPROTO errors we can not mark as device as
removed to avoid infinity loop. However we can count consecutive
EPROTO errors and mark device as removed if get lot of it.
I choose number 10 as threshold.

Reported-and-tested-by: Randy Oostdyk <linux-kernel@oostdyk.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00usb.c | 22 +++++++++++++++++++---
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 94459d5ee01b..88e0dc803227 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -1022,6 +1022,7 @@ struct rt2x00_dev {
 	unsigned int extra_tx_headroom;
 
 	struct usb_anchor *anchor;
+	unsigned int num_proto_errs;
 
 	/* Clock for System On Chip devices. */
 	struct clk *clk;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 086aad22743d..60b8bccab83d 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -31,6 +31,22 @@
 #include "rt2x00.h"
 #include "rt2x00usb.h"
 
+static bool rt2x00usb_check_usb_error(struct rt2x00_dev *rt2x00dev, int status)
+{
+	if (status == -ENODEV || status == -ENOENT)
+		return true;
+	
+	if (status == -EPROTO)
+		rt2x00dev->num_proto_errs++;
+	else
+		rt2x00dev->num_proto_errs = 0;
+
+	if (rt2x00dev->num_proto_errs > 10)
+		return true;
+
+	return false;
+}
+
 /*
  * Interfacing with the HW.
  */
@@ -57,7 +73,7 @@ int rt2x00usb_vendor_request(struct rt2x00_dev *rt2x00dev,
 		if (status >= 0)
 			return 0;
 
-		if (status == -ENODEV || status == -ENOENT) {
+		if (rt2x00usb_check_usb_error(rt2x00dev, status)) {
 			/* Device has disappeared. */
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 			break;
@@ -321,7 +337,7 @@ static bool rt2x00usb_kick_tx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV || status == -ENOENT)
+		if (rt2x00usb_check_usb_error(rt2x00dev, status))
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
@@ -410,7 +426,7 @@ static bool rt2x00usb_kick_rx_entry(struct queue_entry *entry, void *data)
 
 	status = usb_submit_urb(entry_priv->urb, GFP_ATOMIC);
 	if (status) {
-		if (status == -ENODEV || status == -ENOENT)
+		if (rt2x00usb_check_usb_error(rt2x00dev, status))
 			clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 		set_bit(ENTRY_DATA_IO_FAILED, &entry->flags);
 		rt2x00lib_dmadone(entry);
-- 
2.7.5

