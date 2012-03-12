Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:51519 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753012Ab2CLOh6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Mar 2012 10:37:58 -0400
Received: by mail-gx0-f173.google.com with SMTP id j2so3115221ggn.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Mar 2012 07:37:58 -0700 (PDT)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <coelho@ti.com>
Subject: [PATCH] wl12xx: fix station channel switch
Date: Mon, 12 Mar 2012 16:36:48 +0200
Message-Id: <1331563008-25481-1-git-send-email-victorg@ti.com> (sfid-20120312_153804_342107_744BC572)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Channel switch complete event wasn't handled
properly in station mode, as we checked wrong
CS flag.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 drivers/net/wireless/wl12xx/event.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index c953717..60e6f27 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -196,7 +196,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			bool success;
 
 			if (!test_and_clear_bit(WLVIF_FLAG_CS_PROGRESS,
-						&wl->flags))
+						&wlvif->flags))
 				continue;
 
 			success = mbox->channel_switch_status ? false : true;
-- 
1.7.5.4

