Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52767 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755072Ab0DVRwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Apr 2010 13:52:31 -0400
Received: by vws14 with SMTP id 14so38715vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Apr 2010 10:52:29 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] p54pci: fix bugs in p54p_check_tx_ring
Date: Thu, 22 Apr 2010 19:52:16 +0200
Cc: linville@tuxdriver.com, hdegoede@redhat.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004221952.16857.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hans de Goede <hdegoede@redhat.com>

Hans de Goede identified a bug in p54p_check_tx_ring:

there are two ring indices. 1 => tx data and 3 => tx management.
But the old code had a constant "1" and this resulted in spurious
dma unmapping failures. 

Cc: stable@kernel.org
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=583623
Bug-Identified-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 679da7e..cffe2f2 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -246,7 +246,7 @@ static void p54p_check_tx_ring(struct ieee80211_hw *dev, u32 *index,
 	u32 idx, i;
 
 	i = (*index) % ring_limit;
-	(*index) = idx = le32_to_cpu(ring_control->device_idx[1]);
+	(*index) = idx = le32_to_cpu(ring_control->device_idx[ring_index]);
 	idx %= ring_limit;
 
 	while (i != idx) {
