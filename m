Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39161 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751782AbYGCQPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2008 12:15:03 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <IvDoorn@gmail.com>
Subject: [PATCH 1/2] rfkill: some minor kernel-doc changes for rfkill_toggle_radio
Date: Thu,  3 Jul 2008 13:14:56 -0300
Message-Id: <1215101697-30576-2-git-send-email-hmh@hmh.eng.br> (sfid-20080703_181507_930881_8A4C142D)
In-Reply-To: <1215101697-30576-1-git-send-email-hmh@hmh.eng.br>
References: <1215101697-30576-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Improve rfkill_toggle_radio's kernel-doc header a bit.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Ivo van Doorn <IvDoorn@gmail.com>
---
 net/rfkill/rfkill.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index ce0e231..aa7039d 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -130,17 +130,19 @@ static void update_rfkill_state(struct rfkill *rfkill)
 
 /**
  * rfkill_toggle_radio - wrapper for toggle_radio hook
- * calls toggle_radio taking into account a lot of "small"
- * details.
+ *
  * @rfkill: the rfkill struct to use
  * @force: calls toggle_radio even if cache says it is not needed,
  *	and also makes sure notifications of the state will be
  *	sent even if it didn't change
  * @state: the new state to call toggle_radio() with
  *
- * This wrappen protects and enforces the API for toggle_radio
- * calls.  Note that @force cannot override a (possibly cached)
- * state of RFKILL_STATE_HARD_BLOCKED.  Any device making use of
+ * Calls rfkill->toggle_radio, enforcing the API for toggle_radio
+ * calls and handling all the red tape such as issuing notifications
+ * if the call is successful.
+ *
+ * Note that @force cannot override a (possibly cached) state of
+ * RFKILL_STATE_HARD_BLOCKED.  Any device making use of
  * RFKILL_STATE_HARD_BLOCKED implements either get_state() or
  * rfkill_force_state(), so the cache either is bypassed or valid.
  *
-- 
1.5.5.4

