Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34852 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbbILSLK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:10 -0400
Received: by wicge5 with SMTP id ge5so96622906wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 05/11] staging: vt6655: vt6655_init_info remove memset.
Date: Sat, 12 Sep 2015 19:10:32 +0100
Message-Id: <1442081438-3485-5-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201128_298489_132AD72D)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vnt_private is allocated with kzalloc so is already zero.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index fcc4510..03cc52e 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -439,8 +439,6 @@ static void device_print_info(struct vnt_private *pDevice)
 static void vt6655_init_info(struct pci_dev *pcid,
 			     struct vnt_private **ppDevice)
 {
-	memset(*ppDevice, 0, sizeof(**ppDevice));
-
 	(*ppDevice)->pcid = pcid;
 
 	spin_lock_init(&((*ppDevice)->lock));
-- 
2.5.0

