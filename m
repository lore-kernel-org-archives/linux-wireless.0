Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:39184 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZFHMM3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 08:12:29 -0400
Received: by bwz9 with SMTP id 9so2994139bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Jun 2009 05:12:30 -0700 (PDT)
Message-ID: <4A2D0027.6030100@tuffmail.co.uk>
Date: Mon, 08 Jun 2009 13:12:23 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] rfkill: don't impose global states on resume (just restore
 the previous states)
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Once rfkill-input is disabled, the "global" states will only be used as
default initial states.

Since the states will always be the same after resume, we shouldn't
generate events on resume.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

---
 include/linux/rfkill.h |    7 ++++---
 net/rfkill/core.c      |    6 +-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index e98a4b3..7b27a68 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -211,7 +211,7 @@ void rfkill_destroy(struct rfkill *rfkill);
  *
  * rfkill drivers that get events when the hard-blocked state changes
  * use this function to notify the rfkill core (and through that also
- * userspace) of the current state -- they should also use this after
+ * userspace) of the current state.  They should also use this after
  * resume if the state could have changed.
  *
  * You need not (but may) call this function if poll_state is assigned.
@@ -233,8 +233,9 @@ bool __must_check rfkill_set_hw_state(struct rfkill *rfkill, bool blocked);
  * rfkill drivers that get events when the soft-blocked state changes
  * (yes, some platforms directly act on input but allow changing again)
  * use this function to notify the rfkill core (and through that also
- * userspace) of the current state -- they should also use this after
- * resume if the state could have changed.
+ * userspace) of the current state.  It is not necessary to notify on
+ * resume; since hibernation can always change the soft-blocked state,
+ * the rfkill core will unconditionally restore the previous state.
  *
  * This function can be called in any context, even from within rfkill
  * callbacks.
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index d14493f..c02bda8 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -728,15 +728,11 @@ static int rfkill_resume(struct device *dev)
 	struct rfkill *rfkill = to_rfkill(dev);
 	bool cur;
 
-	mutex_lock(&rfkill_global_mutex);
-	cur = rfkill_global_states[rfkill->type].cur;
+	cur = !!(rfkill->state & RFKILL_BLOCK_SW);
 	rfkill_set_block(rfkill, cur);
-	mutex_unlock(&rfkill_global_mutex);
 
 	rfkill->suspended = false;
 
-	schedule_work(&rfkill->uevent_work);
-
 	rfkill_resume_polling(rfkill);
 
 	return 0;


