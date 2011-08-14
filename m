Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36108 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab1HNKRw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:52 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so4060970wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:51 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 25/40] wl12xx: don't remove key if hlid was already deleted
Date: Sun, 14 Aug 2011 13:17:24 +0300
Message-Id: <1313317059-16567-26-git-send-email-eliad@wizery.com> (sfid-20110814_121756_260703_A624BCC9)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hlid was already removed, there is no need to remove
its key (it might cause a fw crash, as the key is invalid).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index d655e62..261807b 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1200,12 +1200,16 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
+	/* hlid might have already been deleted */
+	if (wl->sta_hlid == WL12XX_INVALID_LINK_ID)
+		return 0;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-- 
1.7.6.401.g6a319

