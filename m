Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:45163 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaGKTCs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2014 15:02:48 -0400
Received: by mail-wi0-f180.google.com with SMTP id n3so162690wiv.7
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2014 12:02:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: vt6656: vnt_init_bands fix missing default.
Date: Fri, 11 Jul 2014 20:02:17 +0100
Message-Id: <1405105338-3073-1-git-send-email-tvboxspy@gmail.com> (sfid-20140711_210251_790376_8B81BA08)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The default is that all the channels are enabled for rf types
not mentioned here.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/channel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/vt6656/channel.c b/drivers/staging/vt6656/channel.c
index 5202633..fb1838e 100644
--- a/drivers/staging/vt6656/channel.c
+++ b/drivers/staging/vt6656/channel.c
@@ -148,6 +148,7 @@ void vnt_init_bands(struct vnt_private *priv)
 	switch (priv->byRFType) {
 	case RF_AIROHA7230:
 	case RF_VT3342A0:
+	default:
 		ch = vnt_channels_5ghz;
 
 		for (i = 0; i < ARRAY_SIZE(vnt_channels_5ghz); i++) {
-- 
1.9.1

