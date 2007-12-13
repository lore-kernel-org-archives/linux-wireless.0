Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:56009 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762607AbXLMHAQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 02:00:16 -0500
Subject: [PATCH 96/48] libertas: use spin_is_locked() instead of spin_trylock() in lbs_interrupt()
From: David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <libertas-12345@shinybook.infradead.org>
To: John Linville <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, libertas-dev@lists.infradead.org,
	linux-wireless@vger.kernel.org
Message-Id: <E1J2i3R-0005uz-52@shinybook.infradead.org> (sfid-20071213_070637_107618_9B53AD06)
Date: Thu, 13 Dec 2007 02:00:21 -0500
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Date: Thu, 13 Dec 2007 01:53:57 -0500

We get scary warnings on UP if we use spin_trylock() and find, as we
hoped, that the lock in question is already locked.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
---
 drivers/net/wireless/libertas/main.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 9232b97..5d2bf53 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1414,8 +1414,7 @@ void lbs_interrupt(struct lbs_private *priv)
 
 	lbs_deb_thread("lbs_interrupt: intcounter=%d\n", priv->intcounter);
 
-	if (spin_trylock(&priv->driver_lock)) {
-		spin_unlock(&priv->driver_lock);
+	if (!spin_is_locked(&priv->driver_lock)) {
 		printk(KERN_CRIT "%s called without driver_lock held\n", __func__);
 		WARN_ON(1);
 	}
-- 
1.5.3.4

