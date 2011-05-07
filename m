Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54756 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab1EGJVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 May 2011 05:21:45 -0400
Received: by fxm17 with SMTP id 17so2791464fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 07 May 2011 02:21:43 -0700 (PDT)
Message-Id: <47a87105abcdba5cee38e2bf9ae56e1b59218ffb.1304759993.git.chunkeey@googlemail.com> (sfid-20110507_112203_231954_476C9FDF)
In-Reply-To: <882b3dbce3a3c6fa33ce02130d6bbf5fee348dfb.1304759993.git.chunkeey@googlemail.com>
References: <882b3dbce3a3c6fa33ce02130d6bbf5fee348dfb.1304759993.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Sat, 7 May 2011 11:16:08 +0200
Subject: [PATCH 2/2] p54pci: fix -Wunused-but-set-variable warnings
MIME-Version: 1.0
Content-Type: text/plain;
  charset=UTF-8
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

p54pci.c: In function ‘p54p_tx’:
p54pci.c:334:6: warning: variable ‘device_idx’ set but not used

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 drivers/net/wireless/p54/p54pci.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/p54/p54pci.c b/drivers/net/wireless/p54/p54pci.c
index 0494d7b..1b75317 100644
--- a/drivers/net/wireless/p54/p54pci.c
+++ b/drivers/net/wireless/p54/p54pci.c
@@ -331,10 +331,9 @@ static void p54p_tx(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54p_ring_control *ring_control = priv->ring_control;
 	struct p54p_desc *desc;
 	dma_addr_t mapping;
-	u32 device_idx, idx, i;
+	u32 idx, i;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	device_idx = le32_to_cpu(ring_control->device_idx[1]);
 	idx = le32_to_cpu(ring_control->host_idx[1]);
 	i = idx % ARRAY_SIZE(ring_control->tx_data);
 
-- 
1.7.5.1

