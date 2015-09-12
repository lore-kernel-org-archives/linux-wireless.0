Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34897 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915AbbILSLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Sep 2015 14:11:15 -0400
Received: by wicge5 with SMTP id ge5so96624529wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 12 Sep 2015 11:11:14 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 10/11] staging: vt6655: device_get_pci_info pcid already assigned.
Date: Sat, 12 Sep 2015 19:10:37 +0100
Message-Id: <1442081438-3485-10-git-send-email-tvboxspy@gmail.com> (sfid-20150912_201133_640715_7EEEA231)
In-Reply-To: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
References: <1442081438-3485-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

pcid has already been assigned earlier in vt6655_probe.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index edda836..add9cdf 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -438,8 +438,6 @@ static bool device_get_pci_info(struct vnt_private *pDevice,
 	pDevice->memaddr = pci_resource_start(pcid, 0);
 	pDevice->ioaddr = pci_resource_start(pcid, 1);
 
-	pDevice->pcid = pcid;
-
 	return true;
 }
 
-- 
2.5.0

