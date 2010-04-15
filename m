Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f220.google.com ([209.85.219.220]:35717 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752038Ab0DOMRQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Apr 2010 08:17:16 -0400
Received: by ewy20 with SMTP id 20so459287ewy.1
        for <linux-wireless@vger.kernel.org>; Thu, 15 Apr 2010 05:17:15 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] p54pci: fix serious sparse warning
Date: Thu, 15 Apr 2010 14:17:07 +0200
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201004151417.07538.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug which was just recently introduced by
("p54pci: prevent stuck rx-ring on slow system").

make M=drivers/net/wireless/p54 C=2 CF=-D__CHECK_ENDIAN__
  CHECK   drivers/net/wireless/p54/p54pci.c                                                                 
drivers/net/wireless/p54/p54pci.c:143:11: warning: cast to restricted __le32                                
  CC [M]  drivers/net/wireless/p54/p54pci.o

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 86f3e9a..679da7e 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -140,7 +140,7 @@ static void p54p_refill_rx_ring(struct ieee80211_hw *dev,
 
 	idx = le32_to_cpu(ring_control->host_idx[ring_index]);
 	limit = idx;
-	limit -= le32_to_cpu(index);
+	limit -= index;
 	limit = ring_limit - limit;
 
 	i = idx % ring_limit;
