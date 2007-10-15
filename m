Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:35529 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758926AbXJOMDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 08:03:06 -0400
Received: by an-out-0708.google.com with SMTP id d31so111324and
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 05:03:04 -0700 (PDT)
Date: Mon, 15 Oct 2007 19:59:36 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: mb@bu3sch.de, st3@riseup.net, Larry.Finger@lwfinger.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@osdl.org>
Subject: [-mm Patch] drivers/net/wireless/b43legacy/main.c: initialize the
	correct return value
Message-ID: <20071015115936.GP2444@hacking> (sfid-20071015_130309_975511_F46F5587)
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <20071014175142.GN4211@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071014175142.GN4211@stusta.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Initialize "err" in drivers/net/wireless/b43legacy/main.c::b43legacy_start()
in case of returning an uninitialized value.

From: Adrian Bunk <bunk@kernel.org>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
 drivers/net/wireless/b43/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
===================================================================
--- linux-2.6.23-mm1.orig/drivers/net/wireless/b43legacy/main.c
+++ linux-2.6.23-mm1/drivers/net/wireless/b43legacy/main.c
@@ -3306,7 +3306,7 @@ static int b43legacy_start(struct ieee80
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
 	struct b43legacy_wldev *dev = wl->current_dev;
 	int did_init = 0;
-	int err;
+	int err = 0;
 
 	mutex_lock(&wl->mutex);
 
