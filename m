Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:59526 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758773AbYGOTcP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jul 2008 15:32:15 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 3/4] rfkill: document the rfkill struct locking
Date: Tue, 15 Jul 2008 16:32:06 -0300
Message-Id: <1216150327-10904-4-git-send-email-hmh@hmh.eng.br> (sfid-20080715_213220_484858_BF76D05F)
In-Reply-To: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
References: <1216150327-10904-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reorder fields in struct rfkill and add comments to make it clear
which fields are protected by rfkill->mutex.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/linux/rfkill.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
index c5f6e54..630b573 100644
--- a/include/linux/rfkill.h
+++ b/include/linux/rfkill.h
@@ -89,13 +89,14 @@ struct rfkill {
 	const char *name;
 	enum rfkill_type type;
 
-	enum rfkill_state state;
+	void *data;
 	bool user_claim_unsupported;
 	bool user_claim;
 
+	/* the mutex serializes callbacks and also protects
+	 * the state */
 	struct mutex mutex;
-
-	void *data;
+	enum rfkill_state state;
 	int (*toggle_radio)(void *data, enum rfkill_state state);
 	int (*get_state)(void *data, enum rfkill_state *state);
 
-- 
1.5.6.2

