Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:42184 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbaDVAKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2014 20:10:30 -0400
Received: by mail-ee0-f50.google.com with SMTP id c13so3978902eek.37
        for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2014 17:10:29 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>,
	David Gnedt <david.gnedt@davizone.at>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 4/4] wl1251: only call ieee80211_beacon_loss in managed mode
Date: Tue, 22 Apr 2014 03:09:55 +0300
Message-Id: <1398125395-5579-5-git-send-email-notasas@gmail.com> (sfid-20140422_021035_573397_4FC6006C)
In-Reply-To: <1398125395-5579-1-git-send-email-notasas@gmail.com>
References: <1398125395-5579-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_beacon_loss() is only to be called in managed mode,
but the firmware may send the sync timeout event at any time,
so do a check before calling.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/ti/wl1251/event.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index db01053..c986303 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -124,11 +124,12 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 			return ret;
 	}
 
-	if (wl->vif && vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
+	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
 		/* indicate to the stack, that beacons have been lost */
-		ieee80211_beacon_loss(wl->vif);
+		if (wl->vif && wl->vif->type == NL80211_IFTYPE_STATION)
+			ieee80211_beacon_loss(wl->vif);
 	}
 
 	if (vector & REGAINED_BSS_EVENT_ID) {
-- 
1.7.9.5

