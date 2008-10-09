Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43030 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYJIVPk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 17:15:40 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/5] rfkill: use killable locks instead of interruptible
Date: Thu,  9 Oct 2008 18:15:29 -0300
Message-Id: <1223586933-17753-2-git-send-email-hmh@hmh.eng.br> (sfid-20081009_231548_222270_76C4B3E8)
In-Reply-To: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
References: <1223586933-17753-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently, many applications don't expect to get EAGAIN from fd read/write
operations, since POSIX doesn't mandate it.

Use mutex_lock_killable instead of mutex_lock_interruptible, which won't
cause issues.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index f949a48..08be968 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -431,8 +431,9 @@ static ssize_t rfkill_state_store(struct device *dev,
 	    state != RFKILL_STATE_SOFT_BLOCKED)
 		return -EINVAL;
 
-	if (mutex_lock_interruptible(&rfkill->mutex))
-		return -ERESTARTSYS;
+	error = mutex_lock_killable(&rfkill->mutex);
+	if (error)
+		return error;
 	error = rfkill_toggle_radio(rfkill, state, 0);
 	mutex_unlock(&rfkill->mutex);
 
@@ -472,7 +473,7 @@ static ssize_t rfkill_claim_store(struct device *dev,
 	 * Take the global lock to make sure the kernel is not in
 	 * the middle of rfkill_switch_all
 	 */
-	error = mutex_lock_interruptible(&rfkill_global_mutex);
+	error = mutex_lock_killable(&rfkill_global_mutex);
 	if (error)
 		return error;
 
-- 
1.5.6.5

