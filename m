Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:51851 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933303AbdJQArf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 20:47:35 -0400
Received: by mail-pf0-f170.google.com with SMTP id n14so66573pfh.8
        for <linux-wireless@vger.kernel.org>; Mon, 16 Oct 2017 17:47:34 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: "David S. Miller" <davem@davemloft.net>
Cc: Kees Cook <keescook@chromium.org>,
        Solomon Peachy <pizza@shaftnet.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 17/58] net/cw1200: Convert timers to use timer_setup()
Date: Mon, 16 Oct 2017 17:29:01 -0700
Message-Id: <1508200182-104605-18-git-send-email-keescook@chromium.org> (sfid-20171017_024936_419873_260430B7)
In-Reply-To: <1508200182-104605-1-git-send-email-keescook@chromium.org>
References: <1508200182-104605-1-git-send-email-keescook@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: Solomon Peachy <pizza@shaftnet.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/st/cw1200/pm.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/pm.c b/drivers/net/wireless/st/cw1200/pm.c
index d2202ae92bdd..ded23df1ac1d 100644
--- a/drivers/net/wireless/st/cw1200/pm.c
+++ b/drivers/net/wireless/st/cw1200/pm.c
@@ -91,7 +91,7 @@ struct cw1200_suspend_state {
 	u8 prev_ps_mode;
 };
 
-static void cw1200_pm_stay_awake_tmo(unsigned long arg)
+static void cw1200_pm_stay_awake_tmo(struct timer_list *unused)
 {
 	/* XXX what's the point of this ? */
 }
@@ -101,8 +101,7 @@ int cw1200_pm_init(struct cw1200_pm_state *pm,
 {
 	spin_lock_init(&pm->lock);
 
-	setup_timer(&pm->stay_awake, cw1200_pm_stay_awake_tmo,
-		    (unsigned long)pm);
+	timer_setup(&pm->stay_awake, cw1200_pm_stay_awake_tmo, 0);
 
 	return 0;
 }
-- 
2.7.4
