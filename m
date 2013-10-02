Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:38693 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738Ab3JBGtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 02:49:02 -0400
Received: by mail-ee0-f53.google.com with SMTP id b15so160603eek.12
        for <linux-wireless@vger.kernel.org>; Tue, 01 Oct 2013 23:49:01 -0700 (PDT)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/2] ath10k: extend the max_scan time
Date: Wed,  2 Oct 2013 08:48:52 +0200
Message-Id: <1380696532-4147-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20131002_084908_746746_0DDEC82E)
In-Reply-To: <1380696532-4147-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380696532-4147-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It was observed few times, the artificial max_scan limit we
are using mainly to detect FW hangs, can be not enough for
instance while being associated and during heavy traffic.

What we do if the FW won't return with scan results within
the max_time time is a scan abort.

This is especially visible with 10.X fw which in combination
with dual band HW (scanning 32 channels) can end up with
hw_scan close to 10 seconds.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 416dabb..f9766fa 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2522,7 +2522,7 @@ void ath10k_wmi_start_scan_init(struct ath10k *ar,
 	arg->repeat_probe_time = 0;
 	arg->probe_spacing_time = 0;
 	arg->idle_time = 0;
-	arg->max_scan_time = 5000;
+	arg->max_scan_time = 20000;
 	arg->probe_delay = 5;
 	arg->notify_scan_events = WMI_SCAN_EVENT_STARTED
 		| WMI_SCAN_EVENT_COMPLETED
-- 
1.7.9.5

