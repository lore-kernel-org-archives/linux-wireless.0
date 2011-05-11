Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55003 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab1EKQYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 12:24:15 -0400
Received: by wya21 with SMTP id 21so512787wya.19
        for <linux-wireless@vger.kernel.org>; Wed, 11 May 2011 09:24:14 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 6/7] wl12xx: add ps completion event
Date: Wed, 11 May 2011 11:54:27 +0300
Message-Id: <1305104068-32240-7-git-send-email-eliad@wizery.com> (sfid-20110511_182424_447616_B007E904)
In-Reply-To: <1305104068-32240-1-git-send-email-eliad@wizery.com>
References: <1305104068-32240-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signal when psm was entered successfully, if the completion
variable is being set.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    7 +++++++
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index ae69330..21e52ed 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -135,6 +135,13 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 		/* enable beacon early termination */
 		ret = wl1271_acx_bet_enable(wl, true);
+		if (ret < 0)
+			break;
+
+		if (wl->ps_compl) {
+			complete(wl->ps_compl);
+			wl->ps_compl = NULL;
+		}
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index daf941d..cf08a9d 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -512,6 +512,7 @@ struct wl1271 {
 	unsigned int rx_filter;
 
 	struct completion *elp_compl;
+	struct completion *ps_compl;
 	struct delayed_work elp_work;
 	struct delayed_work pspoll_work;
 
-- 
1.7.0.4

