Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:29329 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Qcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:32:51 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 09/14] wil6210: Separate common code for mbox regs caching to function
Date: Mon, 28 Jan 2013 18:31:04 +0200
Message-ID: <1359390669-9310-10-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173254_348003_2E5B85A4)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 3e9a71f..4c15330 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -109,6 +109,15 @@ static void wil_connect_timer_fn(ulong x)
 	schedule_work(&wil->disconnect_worker);
 }
 
+static void wil_cache_mbox_regs(struct wil6210_priv *wil)
+{
+	/* make shadow copy of registers that should not change on run time */
+	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
+			     sizeof(struct wil6210_mbox_ctl));
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
+	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+}
+
 int wil_priv_init(struct wil6210_priv *wil)
 {
 	wil_dbg_MISC(wil, "%s()\n", __func__);
@@ -138,11 +147,7 @@ int wil_priv_init(struct wil6210_priv *wil)
 		return -EAGAIN;
 	}
 
-	/* make shadow copy of registers that should not change on run time */
-	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
-			     sizeof(struct wil6210_mbox_ctl));
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+	wil_cache_mbox_regs(wil);
 
 	return 0;
 }
@@ -260,11 +265,7 @@ int wil_reset(struct wil6210_priv *wil)
 	wil->pending_connect_cid = -1;
 	INIT_COMPLETION(wil->wmi_ready);
 
-	/* make shadow copy of registers that should not change on run time */
-	wil_memcpy_fromio_32(&wil->mbox_ctl, wil->csr + HOST_MBOX,
-			     sizeof(struct wil6210_mbox_ctl));
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.rx);
-	wil_mbox_ring_le2cpus(&wil->mbox_ctl.tx);
+	wil_cache_mbox_regs(wil);
 
 	/* TODO: release MAC reset */
 	wil6210_enable_irq(wil);
-- 
1.7.10.4

