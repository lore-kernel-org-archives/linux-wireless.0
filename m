Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab1HIJOS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:18 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210739wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:18 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 25/40] wl12xx: don't remove key if hlid was already deleted
Date: Tue,  9 Aug 2011 12:13:38 +0300
Message-Id: <1312881233-9366-26-git-send-email-eliad@wizery.com> (sfid-20110809_111426_490221_C97963A5)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If hlid was already removed, there is no need to remove
its key (it might cause a fw crash, as the key is invalid).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 7cf4d53..41dee4f 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1200,12 +1200,16 @@ int wl1271_cmd_set_sta_key(struct wl1271 *wl, u16 action, u8 id, u8 key_type,
 		       u8 key_size, const u8 *key, const u8 *addr,
 		       u32 tx_seq_32, u16 tx_seq_16)
 {
 	struct wl1271_cmd_set_keys *cmd;
 	int ret = 0;
 
+	/* hlid might have already been deleted */
+	if (wl->sta_hlid == WL1271_INVALID_LINK_ID)
+		return 0;
+
 	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
 	if (!cmd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-- 
1.7.6.401.g6a319

