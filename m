Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gv-out-0910.google.com ([216.239.58.185]:19508 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbYJVQxF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 12:53:05 -0400
Received: by gv-out-0910.google.com with SMTP id e6so571898gvc.37
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 09:53:03 -0700 (PDT)
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-input@vger.kernel.org,
	Dmitry Baryshkov <dbaryshkov@gmail.com>
Subject: [PATCH] RFKILL: fix input layer initialisation
Date: Wed, 22 Oct 2008 20:52:55 +0400
Message-Id: <1224694375-29318-1-git-send-email-dbaryshkov@gmail.com> (sfid-20081022_185310_718233_D107F477)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialise correctly last fields, so tasks can be actually executed.
On some architectures the initial jiffies value is not zero, so later
all rfkill incorrectly decides that rfkill_*.last is in future.

Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
---
 net/rfkill/rfkill-input.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/rfkill-input.c b/net/rfkill/rfkill-input.c
index e5b6955..cd93f48 100644
--- a/net/rfkill/rfkill-input.c
+++ b/net/rfkill/rfkill-input.c
@@ -255,6 +255,11 @@ static struct input_handler rfkill_handler = {
 
 static int __init rfkill_handler_init(void)
 {
+	unsigned long last_run = jiffies - msecs_to_jiffies(500);
+	rfkill_wlan.last = last_run;
+	rfkill_bt.last = last_run;
+	rfkill_uwb.last = last_run;
+	rfkill_wimax.last = last_run;
 	return input_register_handler(&rfkill_handler);
 }
 
-- 
1.5.6.5

