Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37140 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab1FFJVh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 05:21:37 -0400
Received: by mail-ww0-f44.google.com with SMTP id 36so3582178wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 02:21:36 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/4] wl12xx: clear wl->wow_enabled on resume
Date: Mon,  6 Jun 2011 12:21:53 +0300
Message-Id: <1307352115-28969-2-git-send-email-eliad@wizery.com> (sfid-20110606_112140_572728_3152E3FE)
In-Reply-To: <1307352115-28969-1-git-send-email-eliad@wizery.com>
References: <1307352115-28969-1-git-send-email-eliad@wizery.com>
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

