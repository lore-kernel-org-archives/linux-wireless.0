Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:55248 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751071AbdLNKNZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Dec 2017 05:13:25 -0500
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] mt76: fix memcpy to potential null pointer on failed allocation
Date: Thu, 14 Dec 2017 10:13:22 +0000
Message-Id: <20171214101322.10178-1-colin.king@canonical.com> (sfid-20171214_111344_989768_53968583)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Currently if the allocation of skb fails and returns NULL then the
call to skb_put will cause a null pointer dereference. Fix this by
checking for a null skb and returning NULL.  Note that calls to
function mt76x2_mcu_msg_alloc don't directly check the null return
but instead pass the NULL pointer to mt76x2_mcu_msg_send which
checks for the NULL and returns ENOMEM in this case.

Detected by CoverityScan, CID#1462624 ("Dereference null return value")

Fixes: 7bc04215a66b ("mt76: add driver code for MT76x2e")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
index d45737ee1412..15820b11f9db 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2_mcu.c
@@ -45,6 +45,8 @@ static struct sk_buff *mt76x2_mcu_msg_alloc(const void *data, int len)
 	struct sk_buff *skb;
 
 	skb = alloc_skb(len, GFP_KERNEL);
+	if (!skb)
+		return NULL;
 	memcpy(skb_put(skb, len), data, len);
 
 	return skb;
-- 
2.14.1
