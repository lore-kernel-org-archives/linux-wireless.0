Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pmac.infradead.org ([90.155.92.200]:40761 "EHLO
	pmac.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558AbXLSQKA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 11:10:00 -0500
Subject: [PATCH 134/48] libertas: remove check for driver_lock in lbs_interrupt()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J50vP-00022E-J0@pmac.infradead.org> (sfid-20071219_161005_199456_8C1DA6B6)
Date: Wed, 19 Dec 2007 15:33:35 +0000
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Tue, 18 Dec 2007 11:41:43 +0000

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 74353e1..91b2f23 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1435,11 +1435,6 @@ void lbs_interrupt(struct lbs_private *priv)
 
 	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
 
-	if (!spin_is_locked(&priv->driver_lock)) {
-		printk(KERN_CRIT "%s called without driver_lock held\n", __func__);
-		WARN_ON(1);
-	}
-
 	priv->intcounter++;
 
 	if (priv->psstate == PS_STATE_SLEEP)
-- 
1.5.3.4

