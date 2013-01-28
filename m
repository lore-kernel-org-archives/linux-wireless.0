Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:55390 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab3A1Qih (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 11:38:37 -0500
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
Subject: [PATCH 10/14] wil6210: Reorder reset preparation sequence
Date: Mon, 28 Jan 2013 18:31:05 +0200
Message-ID: <1359390669-9310-11-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20130128_173846_692194_C4D1A0F5)
In-Reply-To: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1359390669-9310-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Disable interrupts first to prevent spurious WMI events arrival

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/main.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index 4c15330..aa598f3 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -250,13 +250,13 @@ int wil_reset(struct wil6210_priv *wil)
 	cancel_work_sync(&wil->disconnect_worker);
 	wil6210_disconnect(wil, NULL);
 
+	wil6210_disable_irq(wil);
+	wil->status = 0;
+
 	wmi_event_flush(wil);
 
-	flush_workqueue(wil->wmi_wq);
 	flush_workqueue(wil->wmi_wq_conn);
-
-	wil6210_disable_irq(wil);
-	wil->status = 0;
+	flush_workqueue(wil->wmi_wq);
 
 	/* TODO: put MAC in reset */
 	wil_target_reset(wil);
-- 
1.7.10.4

