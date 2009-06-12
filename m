Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:64712 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672AbZFLLQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 07:16:20 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 17/33] wl12xx: Fix incorrect warning message.
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 12 Jun 2009 14:16:07 +0300
Message-ID: <20090612111607.8877.84870.stgit@tikku>
In-Reply-To: <20090612110225.8877.92418.stgit@tikku>
References: <20090612110225.8877.92418.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ari Kauppi <Ext-Ari.Kauppi@nokia.com>

A warning message in wl12xx_acx_event_mbox_mask has a copy/paste
error. Fix it to print the correct acx command.

Signed-off-by: Ari Kauppi <Ext-Ari.Kauppi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/acx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index a6b8945..8227d6d 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -735,7 +735,7 @@ int wl12xx_acx_event_mbox_mask(struct wl12xx *wl, u32 event_mask)
 	ret = wl12xx_cmd_configure(wl, ACX_EVENT_MBOX_MASK,
 				   mask, sizeof(*mask));
 	if (ret < 0) {
-		wl12xx_warning("failed to set aid: %d", ret);
+		wl12xx_warning("failed to set acx_event_mbox_mask: %d", ret);
 		goto out;
 	}
 

