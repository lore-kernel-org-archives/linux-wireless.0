Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33134 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbbKBPFG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 10:05:06 -0500
Received: by wijp11 with SMTP id p11so53499396wij.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2015 07:05:04 -0800 (PST)
From: Chaitanya T K <chaitanya.mgit@gmail.com>
To: hostap@lists.infradead.org, linux-wireless@vger.kernel.org, j@w1.fi
Cc: tkc <chaitanya.mgit@gmail.com>
Subject: [PATCH] offchannel: Cancel the pending_action TX wait, before starting new one.
Date: Mon,  2 Nov 2015 20:34:42 +0530
Message-Id: <1446476682-23007-1-git-send-email-chaitanya.mgit@gmail.com> (sfid-20151102_160511_266002_74D59CF8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: tkc <chaitanya.mgit@gmail.com>

From: Chaitanya T K <chaitanya.mgit@gmail.com>

Before the tx_status is received for the action frame, if we
get another request, we respond to that by freeing the memory
for pending_action_tx, but we don't cancel the TX wait, so
in the kernel the ROC will not be cancelled.

Due to above issue, wpa_supplicant assumes that all pending
RoC's are cancelled and proceeds with interface creation and
connection, where as state in mac80211/driver will be roc_in_progress.

This is leading to issues at driver level.

Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
---
 wpa_supplicant/offchannel.c |    8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/wpa_supplicant/offchannel.c b/wpa_supplicant/offchannel.c
index 6b3f83c..bd2f905 100644
--- a/wpa_supplicant/offchannel.c
+++ b/wpa_supplicant/offchannel.c
@@ -254,13 +254,7 @@ int offchannel_send_action(struct wpa_supplicant *wpa_s, unsigned int freq,
 	wpa_s->pending_action_tx_status_cb = tx_cb;
 
 	if (wpa_s->pending_action_tx) {
-		wpa_printf(MSG_DEBUG, "Off-channel: Dropped pending Action "
-			   "frame TX to " MACSTR " (pending_action_tx=%p)",
-			   MAC2STR(wpa_s->pending_action_dst),
-			   wpa_s->pending_action_tx);
-		wpa_hexdump_buf(MSG_MSGDUMP, "Pending TX frame",
-				wpa_s->pending_action_tx);
-		wpabuf_free(wpa_s->pending_action_tx);
+		offchannel_send_action_done(wpa_s);
 	}
 	wpa_s->pending_action_tx_done = 0;
 	wpa_s->pending_action_tx = wpabuf_alloc(len);
-- 
1.7.9.5

