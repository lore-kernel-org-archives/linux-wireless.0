Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:9835 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755498Ab2IFOQz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2012 10:16:55 -0400
Message-ID: <5048ADFC.1010708@sonymobile.com> (sfid-20120906_161659_043721_12893A62)
Date: Thu, 6 Sep 2012 16:06:52 +0200
From: Vitaly Wool <vitaly.wool@sonymobile.com>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>, <vitalywool@gmail.com>
Subject: [PATCH/RFC] rfkill: prevent unnecessary event generation
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Prevent unnecessary rfkill event generation when the state has
not actually changed. These events have to be delivered to
relevant userspace processes, causing these processes to wake
up and do something while they could as well have slept. This
obviously results in more CPU usage, longer time-to-sleep-again
and therefore higher power consumption.

Signed-off-by: Vitaly Wool <vitalywool@gmail.com>
Signed-off-by: Mykyta Iziumtsev <nikita.izyumtsev@gmail.com>

---
  net/rfkill/core.c |    8 +++++++-
  1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 752b723..520617c 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -256,6 +256,7 @@ static bool __rfkill_set_hw_state(struct rfkill *rfkill,
  static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
  {
  	unsigned long flags;
+	bool prev, curr;
  	int err;
  
  	if (unlikely(rfkill->dev.power.power_state.event & PM_EVENT_SLEEP))
@@ -270,6 +271,8 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
  		rfkill->ops->query(rfkill, rfkill->data);
  
  	spin_lock_irqsave(&rfkill->lock, flags);
+	prev = rfkill->state & RFKILL_BLOCK_SW;
+
  	if (rfkill->state & RFKILL_BLOCK_SW)
  		rfkill->state |= RFKILL_BLOCK_SW_PREV;
  	else
@@ -299,10 +302,13 @@ static void rfkill_set_block(struct rfkill *rfkill, bool blocked)
  	}
  	rfkill->state &= ~RFKILL_BLOCK_SW_SETCALL;
  	rfkill->state &= ~RFKILL_BLOCK_SW_PREV;
+	curr = rfkill->state & RFKILL_BLOCK_SW;
  	spin_unlock_irqrestore(&rfkill->lock, flags);
  
  	rfkill_led_trigger_event(rfkill);
-	rfkill_event(rfkill);
+
+	if (prev != curr)
+		rfkill_event(rfkill);
  }
  
  #ifdef CONFIG_RFKILL_INPUT
-- 
1.7.5.4

