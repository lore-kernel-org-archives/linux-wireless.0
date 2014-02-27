Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:17631 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753454AbaB0OVp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 09:21:45 -0500
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 12/16] wil6210: Fill vring2cid_tid table early
Date: Thu, 27 Feb 2014 16:20:51 +0200
Message-ID: <1393510855-17566-13-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140227_154709_241121_AAB36E6B)
In-Reply-To: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1393510855-17566-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Need to fill translation table before calling WMI with WMI_VRING_CFG_CMDID
since firmware may generate events during this call; and events need translation
table filled to be properly dispatched

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/txrx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index baced1b..9b4388b 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -610,6 +610,9 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	if (rc)
 		goto out;
 
+	wil->vring2cid_tid[id][0] = cid;
+	wil->vring2cid_tid[id][1] = tid;
+
 	cmd.vring_cfg.tx_sw_ring.ring_mem_base = cpu_to_le64(vring->pa);
 
 	rc = wmi_call(wil, WMI_VRING_CFG_CMDID, &cmd, sizeof(cmd),
@@ -625,9 +628,6 @@ int wil_vring_init_tx(struct wil6210_priv *wil, int id, int size,
 	}
 	vring->hwtail = le32_to_cpu(reply.cmd.tx_vring_tail_ptr);
 
-	wil->vring2cid_tid[id][0] = cid;
-	wil->vring2cid_tid[id][1] = tid;
-
 	return 0;
  out_free:
 	wil_vring_free(wil, vring, 1);
-- 
1.8.3.2

