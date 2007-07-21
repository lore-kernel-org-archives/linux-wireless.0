Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:3989 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754451AbXGUU6x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jul 2007 16:58:53 -0400
From: Daniel Drake <dsd@gentoo.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Cc: kune@deine-taler.de
Subject: [PATCH] zd1211rw-mac80211: fix filter for PSPOLL frames
Message-Id: <20070721205856.57B607B40A0@zog.reactivated.net>
Date: Sat, 21 Jul 2007 21:58:56 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ulrich Kunitz <kune@deine-taler.de>

While filling the control set the driver tests for a PSPOLL frame.
But it tested only the subtype of the packet. The full type needs
to be tested to identify those packets reliably.

Signed-off-by: Ulrich Kunitz <kune@deine-taler.de>
Signed-off-by: Daniel Drake <dsd@gentoo.org>
---
 drivers/net/wireless/mac80211/zd1211rw/zd_mac.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
index d093841..1a7aaef 100644
--- a/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
+++ b/drivers/net/wireless/mac80211/zd1211rw/zd_mac.c
@@ -467,7 +467,8 @@ static void cs_set_control(struct zd_mac *mac, struct zd_ctrlset *cs,
 		cs->control |= ZD_CS_MULTICAST;
 
 	/* PS-POLL */
-	if ((fctl & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
+	if ((fctl & (IEEE80211_FCTL_FTYPE|IEEE80211_FCTL_STYPE)) ==
+	    (IEEE80211_FTYPE_CTL|IEEE80211_STYPE_PSPOLL))
 		cs->control |= ZD_CS_PS_POLL_FRAME;
 
 	if (flags & IEEE80211_TXCTL_USE_RTS_CTS)
-- 
1.5.2.2

