Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45813 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab1IRMJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Sep 2011 08:09:17 -0400
Received: by mail-ww0-f44.google.com with SMTP id 22so6827729wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Sep 2011 05:09:16 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl12xx: handle CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID
Date: Sun, 18 Sep 2011 15:09:19 +0300
Message-Id: <1316347759-22030-2-git-send-email-eliad@wizery.com> (sfid-20110918_140921_316145_0972DBB7)
In-Reply-To: <1316347759-22030-1-git-send-email-eliad@wizery.com>
References: <1316347759-22030-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The fw sends the CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID event
when it wants the driver to increase the dynamic ps (auto-mode)
timeout (or restore the original timeout).

unmask CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID, and increase/restore
the dynamic ps default timeout upon getting this event.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c  |    1 +
 drivers/net/wireless/wl12xx/event.c |    8 ++++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 6d5664b..13798a3 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -496,6 +496,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
 		SOFT_GEMINI_SENSE_EVENT_ID |
+		CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID |
 		PERIODIC_SCAN_REPORT_EVENT_ID |
 		PERIODIC_SCAN_COMPLETE_EVENT_ID |
 		DUMMY_PACKET_EVENT_ID |
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c73fe4c..79ff3bb 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -258,6 +258,14 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl12xx_event_soft_gemini_sense(wl,
 					       mbox->soft_gemini_sense_info);
 
+	if (vector & CHANGE_AUTO_MODE_TIMEOUT_EVENT_ID &&
+	    wl->bss_type == BSS_TYPE_STA_BSS) {
+		int timeout = -1;
+		if (mbox->change_auto_mode_timeout)
+			timeout = 500;
+		ieee80211_set_dyn_ps_timeout(wl->vif, timeout);
+	}
+
 	/*
 	 * The BSS_LOSE_EVENT_ID is only needed while psm (and hence beacon
 	 * filtering) is enabled. Without PSM, the stack will receive all
-- 
1.7.6.401.g6a319

