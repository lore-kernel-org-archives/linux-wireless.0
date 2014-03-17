Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45364 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933490AbaCQNfH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2014 09:35:07 -0400
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 13/21] wil6210: fix memory leak in the AP flow
Date: Mon, 17 Mar 2014 15:34:17 +0200
Message-ID: <1395063265-6522-14-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20140317_143519_437026_B808608A)
In-Reply-To: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1395063265-6522-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When switching between STA and AP modes, memory allocated for Rx vring leaks
This is because start_ap() allocates Rx vring but stop_ap() do not free it.
Logically, Rx vring is not valid (HW can't use it anymore), so free it in reset()
Also, check double init for Rx vring and bail out with -EINVAL

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 ++
 drivers/net/wireless/ath/wil6210/txrx.c | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 6847622..de952ab 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -343,6 +343,8 @@ int wil_reset(struct wil6210_priv *wil)
 	/* TODO: put MAC in reset */
 	wil_target_reset(wil);
 
+	wil_rx_fini(wil);
+
 	/* init after reset */
 	wil->pending_connect_cid = -1;
 	reinit_completion(&wil->wmi_ready);
diff --git a/drivers/net/wireless/ath/wil6210/txrx.c b/drivers/net/wireless/ath/wil6210/txrx.c
index 5cda0ea9..97d036ad 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.c
+++ b/drivers/net/wireless/ath/wil6210/txrx.c
@@ -557,6 +557,11 @@ int wil_rx_init(struct wil6210_priv *wil)
 	struct vring *vring = &wil->vring_rx;
 	int rc;
 
+	if (vring->va) {
+		wil_err(wil, "Rx ring already allocated\n");
+		return -EINVAL;
+	}
+
 	vring->size = WIL6210_RX_RING_SIZE;
 	rc = wil_vring_alloc(wil, vring);
 	if (rc)
-- 
1.8.3.2

