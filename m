Return-Path: <SRS0=PZxT=RJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B3EEC10F00
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:51:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6BC2A20661
	for <linux-wireless@archiver.kernel.org>; Wed,  6 Mar 2019 09:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551865887;
	bh=QfPjGXGbAqUpiVceZIOLZIz3Ams+gdF/OrN2hGBu0b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mYPZcaDGwZ5SnJZMKan9apD4/e3q3SDejG7zU0iKjYXQhddq5CIEgxznEJnLRMGDJ
	 WljR+p4sEDKMD3KOxYQBQ3VGipyAE7iCnLjdhpy6FLXbOz/AX7x7hmAJWwhq1kimIf
	 pzyOdYKnrYaKAu5bVg9XDPKARrWs6aHuu9rvWmKo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729994AbfCFJv0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 6 Mar 2019 04:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729907AbfCFJvZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 6 Mar 2019 04:51:25 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52DB20661;
        Wed,  6 Mar 2019 09:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551865885;
        bh=QfPjGXGbAqUpiVceZIOLZIz3Ams+gdF/OrN2hGBu0b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP9SUO3PeHaXJqXgueyVntmLvUsQJo8kSz861QvvB8PyVTq4LwwoXbZQIkXAoS80f
         fVi1YBJHOoSE8urORXYgyqmWdCJxyi1cGiQf9zc9qX6F/yZZTk6YGJXslb7uPHAvBq
         IBV8uMoFWR7lQs8LGkC/HMmHeI3zEeX9cAc8oeDA=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     rosenp@gmail.com, linux-wireless@vger.kernel.org,
        xose.vazquez@gmail.com, sgruszka@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: [PATCH] mt76x2u: remove duplicated entry in mt76x2u_device_table
Date:   Wed,  6 Mar 2019 10:51:12 +0100
Message-Id: <34f3c8babc8192a2392f8e5b49c3cf405d306bc7.1551865527.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1551865527.git.lorenzo@kernel.org>
References: <cover.1551865527.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Remove duplicated entry in mt76x2u_device_table since Alfa AWUS036ACM
and Aukey USB-AC1200 have the same ids

Fixes: 62a25dc56990a ("mt76x2u: Add support for Alfa AWUS036ACM")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
index ddb6b2c48e01..7a5d539873ca 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb.c
@@ -21,11 +21,10 @@
 #include "mt76x2u.h"
 
 static const struct usb_device_id mt76x2u_device_table[] = {
-	{ USB_DEVICE(0x0e8d, 0x7612) }, /* Alfa AWUS036ACM */
 	{ USB_DEVICE(0x0b05, 0x1833) },	/* Asus USB-AC54 */
 	{ USB_DEVICE(0x0b05, 0x17eb) },	/* Asus USB-AC55 */
 	{ USB_DEVICE(0x0b05, 0x180b) },	/* Asus USB-N53 B1 */
-	{ USB_DEVICE(0x0e8d, 0x7612) },	/* Aukey USB-AC1200 */
+	{ USB_DEVICE(0x0e8d, 0x7612) },	/* Aukey USBAC1200 - Alfa AWUS036ACM */
 	{ USB_DEVICE(0x057c, 0x8503) },	/* Avm FRITZ!WLAN AC860 */
 	{ USB_DEVICE(0x7392, 0xb711) },	/* Edimax EW 7722 UAC */
 	{ USB_DEVICE(0x0846, 0x9053) },	/* Netgear A6210 */
-- 
2.20.1

