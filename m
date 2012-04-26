Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:52031 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab2DZUHw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Apr 2012 16:07:52 -0400
Received: by wibhj6 with SMTP id hj6so6512176wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2012 13:07:51 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] wl1251: fix crash on remove due to leftover work item
Date: Thu, 26 Apr 2012 23:07:44 +0300
Message-Id: <1335470864-25422-2-git-send-email-notasas@gmail.com> (sfid-20120426_220802_353080_688CD58E)
In-Reply-To: <1335470864-25422-1-git-send-email-notasas@gmail.com>
References: <1335470864-25422-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver currently leaves elp_work behind when stopping, which
occasionally results in data corruption because work function ends
up accessing freed memory, typical symptoms of this are various
worker_thread crashes. Fix it by cancelling elp_work.

Cc: stable@vger.kernel.org # v2.6.37+
Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl1251/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 41302c7..d1afb8e 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -479,6 +479,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_work_sync(&wl->filter_work);
+	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
 
-- 
1.7.0.4

