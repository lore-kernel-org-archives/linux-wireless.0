Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:41846 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Qc5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:32:57 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 14/14] wil6210: fix wil_vring_init_tx status
Date: Mon, 28 Jan 2013 18:31:09 +0200
Message-ID: <1359390669-9310-15-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173300_298210_756CB875)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case vring setup with the firmware failed,
success status was returned. fix it.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 1985951..64b971f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -565,6 +565,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	if (reply.cmd.status != WMI_VRING_CFG_SUCCESS) {
 		wil_err(wil, "Tx config failed, status 0x%02x\n",
 			reply.cmd.status);
+		rc = -EINVAL;
 		goto out_free;
 	}
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
-- 
1.7.10.4

