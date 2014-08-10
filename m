Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:53417 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584AbaHJOsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:48:06 -0400
Received: by mail-we0-f169.google.com with SMTP id u56so7535269wes.28
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:48:04 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 8/9] staging: vt6655: device_main Replace DEVICE_INFO with size of pointer
Date: Sun, 10 Aug 2014 15:47:02 +0100
Message-Id: <1407682023-2865-8-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164811_140071_1016B36C)
In-Reply-To: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
References: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 65de6c0..489bfc7 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -839,7 +839,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 		return -ENODEV;
 	}
 
-	dev = alloc_etherdev(sizeof(DEVICE_INFO));
+	dev = alloc_etherdev(sizeof(*pDevice));
 
 	pDevice = netdev_priv(dev);
 
@@ -999,7 +999,7 @@ static void vt6655_init_info(struct pci_dev *pcid,
 {
 	struct vnt_private *p;
 
-	memset(*ppDevice, 0, sizeof(DEVICE_INFO));
+	memset(*ppDevice, 0, sizeof(**ppDevice));
 
 	if (pDevice_Infos == NULL) {
 		pDevice_Infos = *ppDevice;
-- 
1.9.1

