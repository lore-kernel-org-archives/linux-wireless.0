Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:61193 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaIDWJ2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Sep 2014 18:09:28 -0400
Received: by mail-wg0-f45.google.com with SMTP id k14so10876777wgh.16
        for <linux-wireless@vger.kernel.org>; Thu, 04 Sep 2014 15:09:27 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org
Subject: [PATCH 1/2] staging: vt6655: device_free_info() warn: variable dereferenced before check
Date: Thu,  4 Sep 2014 23:08:36 +0100
Message-Id: <1409868517-4270-1-git-send-email-tvboxspy@gmail.com> (sfid-20140905_000931_905567_5EC449F6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pDevice is never NULL when this function is called remove the check.

This fixes smatch warning
drivers/staging/vt6655/device_main.c:1023 device_free_info() warn: variable dereferenced
before check 'pDevice' (see line 1021)

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@01.org
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index f33795f..7e7d9af 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -1008,9 +1008,6 @@ static void device_free_info(struct vnt_private *pDevice)
 {
 	struct net_device *dev = pDevice->dev;
 
-	if (!pDevice)
-		return;
-
 	ASSERT(pDevice);
 //2008-0714-01<Add>by chester
 	device_release_WPADEV(pDevice);
-- 
1.9.1

