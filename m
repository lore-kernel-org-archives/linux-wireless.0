Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:43460 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881AbXJOLhz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 07:37:55 -0400
Received: by py-out-1112.google.com with SMTP id u77so2942674pyb
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 04:37:54 -0700 (PDT)
Date: Mon, 15 Oct 2007 19:34:45 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@osdl.org>
Subject: [-mm Patch] drivers/net/wireless/b43/main.c: fix an uninitialized
	variable
Message-ID: <20071015113445.GO2444@hacking> (sfid-20071015_123759_681276_58D8577D)
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071014175142.GN4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071014175142.GN4211@stusta.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Fix an uninitialized variable in drivers/net/wireless/b43/main.c::b43_start().

From: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/net/wireless/b43/main.c
+++ linux-2.6.23-mm1/drivers/net/wireless/b43/main.c
@@ -3495,7 +3495,7 @@ static int b43_start(struct ieee80211_hw
 	struct b43_wl *wl = hw_to_b43_wl(hw);
 	struct b43_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
