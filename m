Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31526 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaIJNfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 09:35:09 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 02/22] wil6210: debug prints for vring de-allocation
Date: Wed, 10 Sep 2014 16:34:31 +0300
Message-ID: <1410356091-19219-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140910_153524_099273_32AC0DED)
In-Reply-To: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1410356091-19219-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 9bd920d..2cc3569 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -143,6 +143,18 @@ static void wil_vring_free(struct wil6210_priv *wil, struct vring *vring,
 	struct device *dev = wil_to_dev(wil);
 	size_t sz = vring->size * sizeof(vring->va[0]);
 
+	if (tx) {
+		int vring_index = vring - wil->vring_tx;
+
+		wil_dbg_misc(wil, "free Tx vring %d [%d] 0x%p:%pad 0x%p\n",
+			     vring_index, vring->size, vring->va,
+			     &vring->pa, vring->ctx);
+	} else {
+		wil_dbg_misc(wil, "free Rx vring [%d] 0x%p:%pad 0x%p\n",
+			     vring->size, vring->va,
+			     &vring->pa, vring->ctx);
+	}
+
 	while (!wil_vring_is_empty(vring)) {
 		dma_addr_t pa;
 		u16 dmalen;
-- 
1.9.1

