Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:58849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891AbXJOFq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 01:46:58 -0400
Date: Mon, 15 Oct 2007 00:42:23 -0500
From: Anton Blanchard <anton@samba.org>
To: Larry.Finger@lwfinger.net, mb@bu3sch.de, st3@riseup.net
Cc: arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH] jiffies_round -> jiffies_round_relative conversion -
	b43/b43legacy
Message-ID: <20071015054223.GD3257@kryten> (sfid-20071015_064701_861200_36962309)
References: <20071015053428.GA3257@kryten> <20071015053801.GB3257@kryten> <20071015054034.GC3257@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20071015054034.GC3257@kryten>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


When rounding a relative timeout we need to use round_jiffies_relative(). 

Signed-off-by: Anton Blanchard <anton@samba.org>
---

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index c141a26..41049a4 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -2392,7 +2392,7 @@ out_requeue:
 	if (b43_debug(dev, B43_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ * 15);
+		delay = round_jiffies_relative(HZ * 15);
 	queue_delayed_work(wl->hw->workqueue, &dev->periodic_work, delay);
 out:
 	mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/b43legacy/main.c b/drivers/net/wireless/b43legacy/main.c
index f074951..bd0bd9b 100644
--- a/drivers/net/wireless/b43legacy/main.c
+++ b/drivers/net/wireless/b43legacy/main.c
@@ -2260,7 +2260,7 @@ out_requeue:
 	if (b43legacy_debug(dev, B43legacy_DBG_PWORK_FAST))
 		delay = msecs_to_jiffies(50);
 	else
-		delay = round_jiffies(HZ);
+		delay = round_jiffies_relative(HZ);
 	queue_delayed_work(dev->wl->hw->workqueue,
 			   &dev->periodic_work, delay);
 out:
