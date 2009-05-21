Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55552 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754216AbZEUDEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 23:04:32 -0400
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: [PATCH 2/3] rfkill: fix input event handling in rfkill conversion
Date: Thu, 21 May 2009 00:04:18 -0300
Message-Id: <1242875059-9627-3-git-send-email-hmh@hmh.eng.br>
In-Reply-To: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
References: <1242875059-9627-1-git-send-email-hmh@hmh.eng.br>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using break/continue inside a for() which is itself inside a do {} while,
is asking for trouble...

Instead of replacing the bogus "break" with "continue", use something far
more readable, instead.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
---
 net/rfkill/input.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/rfkill/input.c b/net/rfkill/input.c
index f708d74..a7295ad 100644
--- a/net/rfkill/input.c
+++ b/net/rfkill/input.c
@@ -123,14 +123,14 @@ static void rfkill_op_handler(struct work_struct *work)
 			continue;
 
 		for (i = 0; i < NUM_RFKILL_TYPES; i++) {
-			if (!__test_and_clear_bit(i, rfkill_sw_pending))
-				break;
-			c = __test_and_clear_bit(i, rfkill_sw_state);
-			spin_unlock_irq(&rfkill_op_lock);
+			if (__test_and_clear_bit(i, rfkill_sw_pending)) {
+				c = __test_and_clear_bit(i, rfkill_sw_state);
+				spin_unlock_irq(&rfkill_op_lock);
 
-			__rfkill_handle_normal_op(i, c);
+				__rfkill_handle_normal_op(i, c);
 
-			spin_lock_irq(&rfkill_op_lock);
+				spin_lock_irq(&rfkill_op_lock);
+			}
 		}
 	} while (rfkill_op_pending);
 	spin_unlock_irq(&rfkill_op_lock);
-- 
1.6.3.1

