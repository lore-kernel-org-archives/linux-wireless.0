Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33910 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936234Ab3DRLeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Apr 2013 07:34:15 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 2/4] wil6210: Tx init optimization
Date: Thu, 18 Apr 2013 14:33:51 +0300
Message-ID: <1366284834-540-3-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130418_133419_999016_C1395F5D)
In-Reply-To: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1366284834-540-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

vring size is known from the beginning, fill it immediately
in the struct initializer
This is minor optimization that reduces code size.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index d861944..3d9afc5 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -527,6 +527,7 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		.vring_cfg = {
 			.tx_sw_ring = {
 				.max_mpdu_size = cpu_to_le16(TX_BUF_LEN),
+				.ring_size = cpu_to_le16(size),
 			},
 			.ringid = id,
 			.cidxtid = (cid & 0xf) | ((tid & 0xf) << 4),
@@ -558,7 +559,6 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 		goto out;
 
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
-	cmd.vring_cfg.tx_sw_ring.ring_size = cpu_to_le16(vring->size);
 
 	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, &cmd, sizeof(cmd),
 		      WMI_VRING_CFG_DONE_EVENTID, &reply, sizeof(reply), 100);
-- 
1.7.10.4

