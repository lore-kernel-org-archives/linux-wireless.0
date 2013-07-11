Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47627 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3GKHMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 03:12:25 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 2/3] wil6210: fix wrong index in wil_vring_free
Date: Thu, 11 Jul 2013 10:12:08 +0300
Message-ID: <1373526729-10908-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130711_091231_707156_A94D5EE5)
In-Reply-To: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1373526729-10908-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When destroying Rx vring, branch for Rx used wrong Tx descriptor:
while SW context was taken for "head", HW descriptor was, by mistake,
taken from "tail"

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d240b24..8fde73a 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -133,7 +133,7 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 		} else { /* rx */
 			struct vring_rx_desc dd, *d = &dd;
 			volatile struct vring_rx_desc *_d =
-					&vring->va[vring->swtail].rx;
+					&vring->va[vring->swhead].rx;
 
 			*d = *_d;
 			pa = wil_desc_addr(&d->dma.addr);
-- 
1.8.1.2

