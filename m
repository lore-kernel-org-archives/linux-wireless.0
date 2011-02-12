Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60854 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab1BLPBF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Feb 2011 10:01:05 -0500
Received: by bwz15 with SMTP id 15so4128018bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 12 Feb 2011 07:00:40 -0800 (PST)
Date: Sat, 12 Feb 2011 18:00:33 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: brudley@broadcom.com, gregkh@suse.de
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <20110212150033.GA1941@sdf-MacBook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This causes an oops when the bcm43xx_hdr-0.fw binary is not found.

Signed-off-by: Stanislav Fomichev <s@fomichev.me>
---
 drivers/staging/brcm80211/sys/wl_mac80211.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index cd8392b..5faa521 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1767,7 +1767,6 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 		if (status) {
 			printf("%s: fail to load firmware %s\n",
 				KBUILD_MODNAME, fw_name);
-			wl_release_fw(wl);
 			return status;
 		}
 		WL_NONE("request fw %s\n", fw_name);
@@ -1777,7 +1776,6 @@ static int wl_request_fw(struct wl_info *wl, struct pci_dev *pdev)
 		if (status) {
 			printf("%s: fail to load firmware %s\n",
 				KBUILD_MODNAME, fw_name);
-			wl_release_fw(wl);
 			return status;
 		}
 		wl->fw.hdr_num_entries[i] =
-- 
1.7.1
