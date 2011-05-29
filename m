Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38481 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab1E2M46 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 May 2011 08:56:58 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3143732wwa.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 May 2011 05:56:57 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] wl12xx: clear wl->wow_enabled on resume
Date: Sun, 29 May 2011 15:56:50 +0300
Message-Id: <1306673812-27978-2-git-send-email-eliad@wizery.com> (sfid-20110529_145702_081742_9D23E395)
In-Reply-To: <1306673812-27978-1-git-send-email-eliad@wizery.com>
References: <1306673812-27978-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We set wl->wow_enabled on every suspend(), so we need to clear it
on every resume().
(we can't rely on setting wl->wow_enabled=false in suspend(),
as it being called only when wowlan triggers are configured)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8eb52b7..4f20711 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1606,6 +1606,7 @@ static int wl1271_op_resume(struct ieee80211_hw *hw)
 		wl1271_enable_interrupts(wl);
 	}
 	wl1271_configure_resume(wl);
+	wl->wow_enabled = false;
 
 	return 0;
 }
-- 
1.7.0.4

