Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-1920.google.com ([74.125.78.150]:18641 "EHLO
	ey-out-1920.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807AbZGLQDQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2009 12:03:16 -0400
Received: by ey-out-1920.google.com with SMTP id 3so347634eyh.36
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jul 2009 09:03:15 -0700 (PDT)
Message-ID: <4A5A0941.2000408@tuffmail.co.uk>
Date: Sun, 12 Jul 2009 17:03:13 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: alan-jenkins@tuffmail.co.uk, johannes@sipsolutions.net
CC: linux-wireless@vger.kernel.org
Subject: [PATCH] rfkill: fix rfkill_set_states() to set the hw state
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The point of this function is to set the software and hardware state at
the same time.  When I tried to use it, I found it was only setting the
software state.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
---
net/rfkill/core.c |    4 ++++
1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 79693fe..db9948e 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -549,6 +549,10 @@ void rfkill_set_states(struct rfkill *rfkill, bool 
sw, bool hw)
	swprev = !!(rfkill->state & RFKILL_BLOCK_SW);
	hwprev = !!(rfkill->state & RFKILL_BLOCK_HW);
	__rfkill_set_sw_state(rfkill, sw);
+	if (hw)
+		rfkill->state |= RFKILL_BLOCK_HW;
+	else
+		rfkill->state &= ~RFKILL_BLOCK_HW;

	spin_unlock_irqrestore(&rfkill->lock, flags);

-- 
1.5.4.3

