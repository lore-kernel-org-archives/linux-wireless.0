Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33146 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948Ab1BLRrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 12:47:08 -0500
Received: by bwz15 with SMTP id 15so4228362bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 09:47:07 -0800 (PST)
Date: Sat, 12 Feb 2011 20:47:00 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: brudley@broadcom.com, gregkh@suse.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] brcm80211: fix warnings in wl_check_firmwares
Message-ID: <20110212174700.GA2058@sdf-MacBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use %zu instead of %d for size_t

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/sys/wl_mac80211.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index 5faa521..0c87baa 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1822,12 +1822,12 @@ int wl_check_firmwares(struct wl_info *wl)
 			WL_ERROR("%s: invalid bin/hdr fw\n", __func__);
 			rc = -EBADF;
 		} else if (fw_hdr->size % sizeof(struct wl_fw_hdr)) {
-			WL_ERROR("%s: non integral fw hdr file size %d/%zu\n",
+			WL_ERROR("%s: non integral fw hdr file size %zu/%zu\n",
 				 __func__, fw_hdr->size,
 				 sizeof(struct wl_fw_hdr));
 			rc = -EBADF;
 		} else if (fw->size < MIN_FW_SIZE || fw->size > MAX_FW_SIZE) {
-			WL_ERROR("%s: out of bounds fw file size %d\n",
+			WL_ERROR("%s: out of bounds fw file size %zu\n",
 				 __func__, fw->size);
 			rc = -EBADF;
 		} else {
-- 
1.7.1
